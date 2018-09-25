import abc
import requests
import json
import threading
from wallet.models import Address, BalanceChange, CoinExchangeList, Order, Transaction
from etherwallet.settings import records
import time
from wallet.utils.account_util import TRIAccount, ETHAccount, DBOperation, COIN_NAME_ETH, COIN_NAME_TRI
import traceback
from decimal import *
from . import logger as log


logger = log.logger

def weiToETH(wei):
    return Decimal(wei / (10 **18))

def ethToWEI(eth):
    return (int)(eth * (10 **18))

class HttpReq:
    @staticmethod
    def GET(url):
        retryTime = 0
        while retryTime < 3:
            ret = HttpReq.doGET(url)
            if not ret:
                time.sleep(0.3)
                retryTime += 1
                continue
            return ret

    @staticmethod
    def doGET(url):
        try:
            res = requests.get(url).text
            result = json.loads(res)
            ret = result["result"]
            return ret
        except Exception as e:
            logger.error("GET url=%s, result=%s, e=%s" % (url, result, e))
            return None

    @staticmethod
    def POST(url, data):
        try:
            headers = {'Content-Type': 'application/json'}
            page = requests.post(url, headers=headers, data=data).text
            result = json.loads(page)
            ret = result["result"]
            return ret
        except Exception as e:
            logger.error("GET url=%s, data=%s, result=%s, e=%s" % (url, data, result, e))
            return None


class ReqData(metaclass = abc.ABCMeta):
    @abc.abstractmethod
    def latestBlockNumber(self):
        pass

    @abc.abstractmethod
    def getBlockByNumber(self, num):
        pass

    @abc.abstractmethod
    def getBalance(self, address):
        pass

    @abc.abstractmethod
    def getTransactionCount(self, address):
        pass

    @abc.abstractmethod
    def sendRawTransaction(self, hexData):
        pass

    @abc.abstractmethod
    def getTransactionReceipt(self, hash):
        pass

    @staticmethod
    def getReqDataForCoin(coin_name):
        if coin_name == COIN_NAME_TRI:
            return ReqDataTRI()
        elif coin_name == COIN_NAME_ETH:
            return ReqDataETH()
        else:
            return None

    @staticmethod
    def getTransactionWebUrl(coin_name, tx_hash):
        if coin_name == COIN_NAME_TRI:
            return "https://explorer.trias.one/translist/%s" % tx_hash
        elif coin_name == COIN_NAME_ETH:
            return "https://ropsten.etherscan.io/tx/%s" % tx_hash
        else:
            return None

class ReqDataETH(ReqData):
    def __init__(self):
        self.host = "https://api-ropsten.etherscan.io"
        self.apiKey = records['etherscan_key']
        super(ReqDataETH, self).__init__()

    def latestBlockNumber(self):
        url = "%s/api?module=proxy&action=eth_blockNumber&apikey=%s" % (self.host, self.apiKey)
        number = HttpReq.GET(url)
        return number

    def getBlockByNumber(self, num):
        url = "%s/api?module=proxy&action=eth_getBlockByNumber&tag=0x%x&boolean=true&apikey=%s" % (self.host, num, self.apiKey)
        block = HttpReq.GET(url)
        return block

    def getBalance(self, address):
        url = "%s/api?module=account&action=balance&address=%s&tag=latest&apikey=%s" % (self.host, address, self.apiKey)
        balance = HttpReq.GET(url)
        return balance

    def getTransactionCount(self, address):
        url = "%s/api?module=proxy&action=eth_getTransactionCount&address=%s&tag=latest&apikey=%s" %(self.host, address, self.apiKey)
        ret = HttpReq.GET(url)
        return ret

    def sendRawTransaction(self, hexData):
        url = "%s/api?module=proxy&action=eth_sendRawTransaction&hex=%s&apikey=%s" % (self.host, hexData, self.apiKey)
        ret = HttpReq.GET(url)
        return ret

    def getTransactionReceipt(self, hash):
        url = "%s/api?module=proxy&action=eth_getTransactionReceipt&txhash=%s&apikey=%s" % (self.host, hash, self.apiKey)
        ret = HttpReq.GET(url)
        return ret

class ReqDataTRI(ReqData):
    def getURL(self):
        tri_ip = records['eth_ip']
        tri_port = records['eth_port']
        url = "http://" + tri_ip + ":" + tri_port
        return url

    def latestBlockNumber(self):
        url = self.getURL()
        data = '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":83}'
        number = HttpReq.POST(url, bytes(data,'utf8'))
        return number

    def getBlockByNumber(self, num):
        url = self.getURL()
        data = '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["%s", true],"id":1}' % hex(num)
        block = HttpReq.POST(url, bytes(data,'utf8'))
        return block

    def getBalance(self, address):
        url = self.getURL()
        data = '{"jsonrpc":"2.0","method":"eth_getBalance","params":["%s", "latest"],"id":1}' % address
        balance = HttpReq.POST(url, bytes(data, 'utf8'))
        return balance

    def getTransactionCount(self, address):
        url = self.getURL()
        data = '{"jsonrpc":"2.0","method":"eth_getTransactionCount","params":["%s","latest"],"id":1}' % address
        count = HttpReq.POST(url, bytes(data, 'utf8'))
        return count

    def sendRawTransaction(self, hexData):
        url = self.getURL()
        data = '{"jsonrpc":"2.0","method":"eth_sendRawTransaction","params":["%s"],"id":1}' % hexData
        hash = HttpReq.POST(url, bytes(data, 'utf8'))
        return hash

    def getTransactionReceipt(self, hash):
        url = self.getURL()
        data = '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["%s"],"id":1}' % hash
        receipt = HttpReq.POST(url, bytes(data, 'utf8'))
        return receipt

class Worker(threading.Thread):
    def __init__(self, coinName, reqData):
        self.coinName = coinName
        if coinName == COIN_NAME_ETH:
            self.gasPrice = ETHAccount.defaultGasPrice
            self.gasLimit = ETHAccount.defaultGasLimit
            self.checkStartBlockNum = 10
            self.recentBlockNumber = 1
        elif coinName == COIN_NAME_TRI:
            self.gasPrice = TRIAccount.defaultGasPrice
            self.gasLimit = TRIAccount.defaultGasLimit
            self.checkStartBlockNum = 100
            self.recentBlockNumber = 1
        self.reqData = reqData
        self.checkedBlockNum = 0
        DBOperation.getInnerAddress(self.coinName)
        threading.Thread.__init__(self)

    def run(self):
        while True:
            latest = self.reqData.latestBlockNumber()
            latest = int(latest, 16)
            if not self.checkedBlockNum:
                self.checkedBlockNum = latest - self.checkStartBlockNum
                if self.checkedBlockNum < 0:
                    self.checkedBlockNum = 0
            if self.checkedBlockNum >= latest - self.recentBlockNumber - 1:
                time.sleep(0.5)
                continue
            for blockNum in range(self.checkedBlockNum+1, latest - self.recentBlockNumber):
                if (blockNum % 10000) == 0:
                    logger.info("%s cur block %s, latest %s" % (self.coinName, blockNum, latest))
                block = self.reqData.getBlockByNumber(blockNum)
                for tr in block["transactions"]:
                    toAddress = tr["to"]
                    # order in, not exist
                    try:
                        order = Order.objects.filter(source_coin_name=self.coinName, source_coin_payment_address=toAddress).first()
                        if order:
                            self.inertOrderInTransaction(tr, order)
                            self.sendInnerInTransaction(toAddress)
                    except Exception as e:
                        logger.error(traceback.format_exc())
                    # inner in, exist or not exist
                    try:
                        a = Address.objects.filter(address=toAddress, is_inner=True).first()
                        if a:
                            self.checkOrInsertInnerInTransaction(tr)
                    except Exception as e:
                        logger.error(traceback.format_exc())

                    fromAddress = tr["from"]
                    # inner out, exist
                    try:
                        a = Address.objects.filter(address=fromAddress, is_inner=True).first()
                        if a:
                            self.checkInnerOutTransaction(tr)
                    except Exception as e:
                        logger.error(traceback.format_exc())

                    # order out, exist
                    try:
                        a = Address.objects.filter(address=fromAddress, is_inner=False).first()
                        if a:
                            self.checkOrderOutAddress(toAddress, tr["hash"])
                    except Exception as e:
                        logger.error(traceback.format_exc())

            self.checkedBlockNum = latest - self.recentBlockNumber - 1
            self.checkDBPendingOrder()


    def inertOrderInTransaction(self, tr, order):
        #check exists
        try:
            transaction = Transaction.objects.filter(tx_hash=tr["hash"]).first()
        except:
            transaction = None
        if transaction:
            logger.error("%s insert already exist order_in transaction in db, id=%s" % (self.coinName, transaction.id))
            return
        #insert transaction
        transaction = Transaction()
        transaction.coin_name = self.coinName
        transaction.from_address = tr["from"]
        transaction.to_address = tr["to"]
        transaction.tx_hash = tr["hash"]
        transaction.is_to_address_mine = True
        transaction.is_from_address_mine = False
        transaction.amount = weiToETH( int(tr["value"],16) )
        transaction.is_confirmed = True
        try:
            transaction.save()
        except Exception as e:
            logger.error("%s transaction.save exception:%s" % (self.coinName, e))
        logger.info("%s insert order_in transaction in db, id=%s" % (self.coinName, transaction.id))
        #update order
        try:
            order.tx_in_hash = transaction.tx_hash
            order.source_coin_payment_amount += transaction.amount
            order.save(update_fields=['tx_in_hash', 'source_coin_payment_amount'])
        except Exception as e:
            logger.error("%s order.save exception:%s" % (self.coinName, e))
        logger.info("%s update order tx_in_hash in db, id=%s" % (self.coinName, order.id))
        #insert balance change
        try:
            originalBalance = BalanceChange.objects.filter(coin_name=self.coinName).last().balance_now
        except:
            originalBalance = 0
        try:
            balanceChange = BalanceChange()
            balanceChange.coin_name = self.coinName
            balanceChange.tx_from_address = transaction.from_address
            balanceChange.tx_to_address = transaction.to_address
            balanceChange.tx_hash = transaction.tx_hash
            balanceChange.tx_amount = transaction.amount
            balanceChange.tx_is_confirmed = True
            balanceChange.balance_original = originalBalance
            balanceChange.balance_now = Decimal(originalBalance) + Decimal(transaction.amount)
            balanceChange.save()
        except Exception as e:
            logger.error("%s balanceChange.save exception:%s" % (self.coinName, e))
        logger.info("%s insert balanceChange increase in db, id=%s" % (self.coinName, balanceChange.id))

    def sendInnerInTransaction(self, fromAddress):
        balance = self.reqData.getBalance(fromAddress)
        try:
            if balance[0:2] == '0x' or balance[0:2] == '0X':
                balance = int(balance, 16)
            else:
                balance = int(balance, 10)
        except:
            logger.error("%s balance error %s" % (self.coinName, fromAddress))
            return
        amount = balance - self.gasLimit * self.gasPrice
        if amount <= 0:
            logger.error("%s balance too few %s" % (self.coinName, fromAddress))
            return

        if self.coinName == COIN_NAME_TRI:
            account = DBOperation.getTriAccount(fromAddress)
        elif self.coinName == COIN_NAME_ETH:
            account = DBOperation.getETHAccount(fromAddress)
        if not account:
            logger.error("can not get account, coin name %s" %self.coinName)
            return
        nonce = self.reqData.getTransactionCount(fromAddress)
        nonce = int(nonce, 16)
        to = DBOperation.getInnerAddress(self.coinName)
        if not to:
            logger.error("not find inner address %s" % self.coinName)
            return
        raw = account.signTransaction(nonce, to, amount)
        hash = self.reqData.sendRawTransaction(raw)
        if not hash:
            logger.error("%s send inner_in raw transaction fail" % self.coinName)
            return
        #logger.error("sendInnerTransaction from=%s, to=%s, amount=%s, hash=%s" % (fromAddress, to, amount, hash))
        #insert transaction
        transaction = Transaction()
        transaction.coin_name = self.coinName
        transaction.from_address = fromAddress
        transaction.to_address = to
        transaction.tx_hash = hash
        transaction.is_to_address_mine = True
        transaction.is_from_address_mine = True
        transaction.amount = weiToETH( amount )
        transaction.is_confirmed = False
        try:
            transaction.save()
        except Exception as e:
            logger.error("%s transaction.save exception:%s" % (self.coinName, e))
        logger.info("%s insert inner_in transaction in db, id=%s" % (self.coinName, transaction.id))

    def checkOrInsertInnerInTransaction(self, tr):
        try:
            transaction = Transaction.objects.filter(tx_hash=tr["hash"]).first()
            if transaction:
                if transaction.is_confirmed:
                    logger.error("%s update already confirmed inner_in transaction in db, id=%s" % (self.coinName, transaction.id))
                    return
                receipt = self.reqData.getTransactionReceipt(tr["hash"])
                gasUsed = receipt["gasUsed"]
                gasUsed = int(gasUsed, 16)
                fee = weiToETH(self.gasPrice * gasUsed)
                transaction.fee = fee
                transaction.is_confirmed = True
                transaction.save(update_fields=['fee', 'is_confirmed'])
                logger.info("%s update inner_in transaction in db, id=%s" % (self.coinName, transaction.id))
                # insert balance change
                try:
                    originalBalance = BalanceChange.objects.filter(coin_name=self.coinName).last().balance_now
                except:
                    originalBalance = 0
                balanceChange = BalanceChange()
                balanceChange.coin_name = self.coinName
                balanceChange.tx_from_address = transaction.from_address
                balanceChange.tx_to_address = transaction.to_address
                balanceChange.tx_hash = transaction.tx_hash
                balanceChange.tx_amount = transaction.amount
                balanceChange.tx_is_confirmed = True
                balanceChange.tx_fee = fee
                balanceChange.balance_original = originalBalance
                balanceChange.balance_now = Decimal(originalBalance) - Decimal(fee)
                balanceChange.save()
                logger.info("%s insert balanceChange decrease fee in db, id=%s" % (self.coinName, transaction.id))
                return
        except Exception as e:
            logger.error(traceback.format_exc())
        #not exist
        # insert transaction
        transaction = Transaction()
        transaction.coin_name = self.coinName
        transaction.from_address = tr["from"]
        transaction.to_address = tr["to"]
        transaction.tx_hash = tr["hash"]
        transaction.is_to_address_mine = True
        transaction.is_from_address_mine = False
        transaction.amount = weiToETH(int(tr["value"], 16))
        transaction.is_confirmed = True
        try:
            transaction.save()
        except Exception as e:
            logger.error("%s transaction.save exception:%s" % (self.coinName, e))
        logger.info("%s insert inner_in transaction in db, id=%s" % (self.coinName, transaction.id))
        # insert balance change
        try:
            originalBalance = BalanceChange.objects.filter(coin_name=self.coinName).last().balance_now
        except:
            originalBalance = 0
        try:
            balanceChange = BalanceChange()
            balanceChange.coin_name = self.coinName
            balanceChange.tx_from_address = transaction.from_address
            balanceChange.tx_to_address = transaction.to_address
            balanceChange.tx_hash = transaction.tx_hash
            balanceChange.tx_amount = transaction.amount
            balanceChange.tx_is_confirmed = True
            balanceChange.balance_original = originalBalance
            balanceChange.balance_now = Decimal(originalBalance) + Decimal(transaction.amount)
            balanceChange.save()
        except Exception as e:
            logger.error("%s balanceChange.save exception:%s" % (self.coinName, e))
        logger.info("%s insert balanceChange increase in db, id=%s" % (self.coinName, balanceChange.id))

    def checkInnerOutTransaction(self, tr):
        try:
            transaction = Transaction.objects.filter(tx_hash=tr["hash"]).first()
            if transaction:
                if transaction.is_confirmed:
                    logger.error("%s update already exist inner out transaction in db, id=%s" % (self.coinName, transaction.id))
                    return
                receipt = self.reqData.getTransactionReceipt(tr["hash"])
                gasUsed = receipt["gasUsed"]
                gasUsed = int(gasUsed, 16)
                fee = weiToETH(self.gasPrice * gasUsed)
                transaction.fee = fee
                transaction.is_confirmed = True
                transaction.save(update_fields=['fee', 'is_confirmed'])
                logger.info("%s update inner out transaction in db, id=%s" % (self.coinName, transaction.id))
                # insert balance change
                try:
                    originalBalance = BalanceChange.objects.filter(coin_name=self.coinName).last().balance_now
                except:
                    originalBalance = 0
                balanceChange = BalanceChange()
                balanceChange.coin_name = self.coinName
                balanceChange.tx_from_address = transaction.from_address
                balanceChange.tx_to_address = transaction.to_address
                balanceChange.tx_hash = transaction.tx_hash
                balanceChange.tx_amount = transaction.amount
                balanceChange.tx_is_confirmed = True
                balanceChange.tx_fee = fee
                balanceChange.balance_original = originalBalance
                balanceChange.balance_now = Decimal(originalBalance) - Decimal(fee) - Decimal(transaction.amount)
                balanceChange.save()
                logger.error("%s insert balanceChange decrease amount and fee in db, id=%s" % (self.coinName, balanceChange.id))
                #update order
                try:
                    order = Order.objects.filter(target_coin_name=self.coinName, tx_out_hash=tr["hash"]).first()
                    if not order:
                        logger.error("%s inner_out transaction not find, tx_out_hash=%s" % (self.coinName, tr["hash"]))
                        return
                    if order.is_finished:
                        logger.error("%s inner_out transaction already finished, order id=%s" %(self.coinName, order.id))
                        return
                    order.is_finished = True
                    order.save(update_fields=['is_finished'])
                except Exception as e:
                    logger.error("%s order.save exception:" % self.coinName, e)
                logger.info("%s update order is_finished in db, id=%s" % (self.coinName, order.id))
                return
        except Exception as e:
            logger.error(traceback.format_exc())

    def checkOrderOutAddress(self, toAddress, hash):
        try:
            a = Address.objects.filter(address=toAddress, is_inner=True).first()
        except:
            a = None
        if not a:
            logger.error("%s order out dest address is not inner address, toAddress=%s, hash=%s" % (self.coinName, toAddress,hash))

    def checkDBPendingOrder(self):
        orders = Order.objects.filter(target_coin_name=self.coinName, is_finished=False, tx_in_hash__isnull=False, tx_out_hash__isnull=True)
        #logger.error("%s checkDBPendingOrder orders=%s" % (self.coinName, orders))
        for order in orders:
            amount = order.source_amount
            payAmount = order.source_coin_payment_amount
            if amount <=  payAmount:
                self.sendInnerOutTransaction(order.target_coin_address, order.target_amount, order)
            else:
                logger.error("%s receive order input amount %s, but less than required amount %s" % (self.coinName, payAmount, amount))

    def sendInnerOutTransaction(self, toAddress, amount, order):
        fromAddress = DBOperation.getInnerAddress(self.coinName)
        if not fromAddress:
            logger.error("not find inner address %s" % self.coinName)
            return
        amount = ethToWEI(amount)
        balance = self.reqData.getBalance(fromAddress)
        try:
            if balance[0:2] == '0x' or balance[0:2] == '0X':
                balance = int(balance, 16)
            else:
                balance = int(balance, 10)
        except:
            logger.error("%s balance error %s" % (self.coinName, fromAddress))
            return
        if balance < (amount + self.gasLimit * self.gasPrice):
            logger.error("%s insufficient balance %s < %s" % (self.coinName, balance, amount))
            return
        if self.coinName == COIN_NAME_TRI:
            account = DBOperation.getTriAccount(fromAddress)
        elif self.coinName == COIN_NAME_ETH:
            account = DBOperation.getETHAccount(fromAddress)
        else:
            account = None
        if not account:
            logger.error("%s not find inner account" % self.coinName)
            return
        nonce = self.reqData.getTransactionCount(fromAddress)
        nonce = int(nonce, 16)
        raw = account.signTransaction(nonce, toAddress, amount)
        hash = self.reqData.sendRawTransaction(raw)
        if not hash:
            logger.error("%s send inner_out raw transaction fail" % self.coinName)
            return
        #insert transaction
        transaction = Transaction()
        transaction.coin_name = self.coinName
        transaction.from_address = fromAddress
        transaction.to_address = toAddress
        transaction.tx_hash = hash
        transaction.is_to_address_mine = False
        transaction.is_from_address_mine = True
        transaction.amount = weiToETH( amount )
        transaction.is_confirmed = False
        try:
            transaction.save()
        except Exception as e:
            logger.error("%s transaction.save exception:%s" % (self.coinName, e))
        logger.info("%s insert inner_out transaction in db, id=%s" % (self.coinName, transaction.id))
        #update order
        try:
            order.tx_out_hash = transaction.tx_hash
            order.save(update_fields=['tx_out_hash'])
        except Exception as e:
            logger.error("%s order update exception:" % self.coinName, e)
        logger.info("%s update order tx_out_hash in db, id=%s" % (self.coinName, order.id))


class AllWorker:
    _ethWorker = None
    _triWorker = None

    @classmethod
    def startEthWorker(cls):
        try:
            if cls._ethWorker:
                return
                logger.info("start eth worker thread")
            cls._ethWorker = Worker("ETH", ReqDataETH())
            cls._ethWorker.setDaemon(True)
            cls._ethWorker.start()
        except Exception as e:
            logger.error(traceback.format_exc())

    @classmethod
    def startTRIWorker(cls):
        try:
            if cls._triWorker:
                return
            logger.info("start tri worker thread")
            cls._triWorker = Worker("TRI", ReqDataTRI())
            cls._triWorker.setDaemon(True)
            cls._triWorker.start()
        except Exception as e:
            logger.error(traceback.format_exc())
