from eth_account import Account
from Crypto.Cipher import AES
from etherwallet.settings import records
from wallet.models import Address, BalanceChange, CoinExchangeList, Order, Transaction
import threading
from . import block_util
from . import logger as log


logger = log.logger
COIN_NAME_ETH = "ETH"
COIN_NAME_TRI = "TRI"

def pad(text, ch):
    while len(text) % 16 != 0:
        text += ch
    return text

class AESCrypt():
    def __init__(self, key):
        self.key = pad(key, ' ')
        self.mode = AES.MODE_CBC
        self.iv = "IV" * 8

    def encrypt(self, buffer):
        cryptor = AES.new(self.key, self.mode, self.iv)
        text = buffer.hex()
        if text[0:2] == '0x' or text[0:2] == '0X':
            text = text[2:]
        pad_text = pad(text, '-')
        enc_buffer = cryptor.encrypt(pad_text)
        hex_text = enc_buffer.hex()
        return hex_text

    def decrypt(self, hex_text):
        cryptor = AES.new(self.key, self.mode, self.iv)
        buffer = bytes.fromhex(hex_text)
        pad_buffer = cryptor.decrypt(buffer)
        pad_text = pad_buffer.decode('ascii')
        text = pad_text.rstrip('-')
        plain_buffer = bytes.fromhex(text)
        return plain_buffer

def getPassword():
    return records["private_key_encrypt_pass"]

class ETHAccount:
    defaultGasPrice = 41 * (10 ** 9)
    defaultGasLimit =  21 * (10 **3)
    def __init__(self, encryptdPrivateKey):
        password = getPassword()
        crypt = AESCrypt(password)
        self.private_key = crypt.decrypt(encryptdPrivateKey)
        self.acct = Account.privateKeyToAccount(self.private_key)
        self.address = self.acct.address

    def signTransaction(self, nonce, to, amount, gas_price = defaultGasPrice, gas = defaultGasLimit):
        chainId = 3
        transaction = {
            # Note that the address must be in checksum format:
            'to': to,
            'value': amount,
            'gas': gas,
            'gasPrice': gas_price,
            'nonce': nonce,
            'chainId': chainId
        }
        signed = Account.signTransaction(transaction, self.private_key)
        raw = signed.rawTransaction
        raws = raw.hex()
        return raws

class TRIAccount(ETHAccount):
    def signTransaction(self, nonce, to, amount, gas_price = 41 * (10 ** 9), gas = 21 * (10 **3)):
        chainId = 15
        transaction = {
            # Note that the address must be in checksum format:
            'to': to,
            'value': amount,
            'gas': gas,
            'gasPrice': gas_price,
            'nonce': nonce,
            'chainId': chainId
        }
        signed = Account.signTransaction(transaction, self.private_key)
        raw = signed.rawTransaction
        raws = raw.hex()
        return raws

class DBOperation:
    @staticmethod
    def genNewAddress(coin_name, is_inner):
        try:
            acct = Account.create()
            private_key = acct.privateKey
            address = acct.address
            crypt = AESCrypt(getPassword())
            encrypt_buffer = crypt.encrypt(private_key)

            a = Address()
            a.coin_name = coin_name
            a.address = address
            a.encrpyted_private_key = encrypt_buffer
            a.is_used = True
            a.is_inner = is_inner
            a.save()
            return a.address
        except:
            return None

    @staticmethod
    def getInnerAddress(coin_name):
        try:
            a = Address.objects.filter(coin_name=coin_name, is_inner=True).first()
            if a:
                return a.address
        except:
            logger.error("inner address not exist, coin %s" % coin_name)
        DBOperation.genNewAddress(coin_name, True)
        try:
            a = Address.objects.filter(coin_name=coin_name, is_inner=True).first()
            return a.address
        except:
            return None

    @staticmethod
    def getTriAccount(address):
        try:
            a = Address.objects.filter(address=address).first()
        except:
            logger.error("not find tri account %s" % address)
            return None
        account = TRIAccount(a.encrpyted_private_key)
        return account

    @staticmethod
    def getETHAccount(address):
        try:
            a = Address.objects.filter(address=address).first()
        except:
            logger.error("not find eth account %s" % address)
            return None
        account = ETHAccount(a.encrpyted_private_key)
        return account

    @staticmethod
    def isBalanceSufficient(coin_name, rquiredAmount):
        address = DBOperation.getInnerAddress(coin_name)
        req = block_util.ReqData.getReqDataForCoin(coin_name)
        balance = req.getBalance(address)
        if not balance:
            logger.error("%s get balance fail" % coin_name)
            return False
        if balance[0:2] == '0x' or balance[0:2] == '0X':
            balance =  int(balance, 16)
        else:
            balance = int(balance, 10)
        balanceETH =  block_util.weiToETH(balance)
        #logger.error("%s isBalanceSufficient, balance %s, rquiredAmount %s" % (coin_name, balance, rquiredAmount))
        if coin_name == COIN_NAME_ETH:
            fee = ETHAccount.defaultGasLimit * ETHAccount.defaultGasPrice
        elif coin_name == COIN_NAME_TRI:
            fee = TRIAccount.defaultGasLimit * TRIAccount.defaultGasPrice
        if balanceETH >= rquiredAmount + block_util.weiToETH(fee):
            return True
        else:
            return False
