"""
"""
from django.http import HttpResponse
from django.http import JsonResponse
from urllib import request as HttpReq
import json
from etherwallet.settings import CONF_JSON
from wallet.utils.logger import logger
from wallet.utils.common_util import load_json
import traceback
from eth_account import Account
import eth_utils
import os
import requests
from wallet.utils.tx_cli import new_coinbase_tx, new_utxo_transaction
from hexbytes import HexBytes
import sys
from django.shortcuts import render
from etherwallet.settings import records
import eth_account

UTXO_URL = records['utxo_url']

def eth_blockNumber(reqDict):
    height = utxoGetLatestHeight();
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": hex(height)
    }
    return ret

def net_version(reqDict):
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": "1553656630962"
    }
    return ret

def eth_getBalance(reqDict):
    address = reqDict['params'][0]
    balance = utxoGetBalance(address.lower())
    logger.info('eth_getBalance address=%s, balance=%s' % (address, balance));
    if not balance:
        balance = 0
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": hex(balance)
    }
    return ret

def eth_getTransactionByHash(reqDict):
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": {
            "hash": reqDict['params'][0],
            "nonce": "0x0",
            "blockHash": "0xb33fc81c35bd01741c96b3ee641940ce752cafbbef17e95410b57c4a1163a98a",
            "blockNumber": "0x1",
            "transactionIndex": "0x0",
            "from": "0x42499eaa37fb588cc360f45e840e160f50d092a7",
            "to": "0x1cb83acaf2257117ab7288af7f57940845e050db",
            "value": "0x8ac7230489e80000",
            "gas": "0x15f90",
            "gasPrice": "0x4a817c800",
            "input": "0x",
            "v": "0x1b",
            "r": "0xbb879a04efad6a76b09edbd8d41e71ccfbe064355df9784abb4d99ceda2c8f29",
            "s": "0x14675703404e3480d59328ceb418b9ea3dc0a44d74962a85494475e6096fc0d6"
        }
    }
    return ret


def eth_gasPrice(reqDict):
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": "0x09184e72a000"
    }
    return ret


def eth_getTransactionCount(reqDict):
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": "0x1"
    }
    return ret

def recoverTransactionRaw(rawTx):
    try:
        from transactions import Transaction, vrs_from
        from signing import hash_of_signed_transaction
    except Exception as e:
        logger.info('import eth_account path')
        eth_dir = eth_account.__path__[0]
        lib_path = os.path.abspath(os.path.join(eth_dir, 'internal'))
        sys.path.append(lib_path)
        from transactions import Transaction, vrs_from
        from signing import hash_of_signed_transaction

    txn_bytes = HexBytes(rawTx)
    txn = Transaction.from_bytes(txn_bytes)
    msg_hash = hash_of_signed_transaction(txn)
    sender = eth_account.Account.recoverHash(msg_hash, vrs=vrs_from(txn))
    txn.sender = sender
    return txn


def eth_sendRawTransaction(reqDict):
    rawTx = reqDict['params'][0]

    txn = recoverTransactionRaw(rawTx)
    #logger.info('txn: %s' % txn)
    #logger.info('nonce: %s' % txn.nonce)
    #logger.info('gasPrice: %s' % txn.gasPrice)
    #logger.info('gas: %s' % txn.gas)
    #logger.info('to: %s, len=%d, type=%s' % (txn.to, len(txn.to), type(txn.to)))
    toAddr = eth_utils.to_checksum_address(txn.to)
    #logger.info('toAddr: %s' % toAddr)
    #logger.info('value: %s, type=%s, int=%d' % (txn.value, type(txn.value), int(txn.value)))
    #logger.info('data: %s' % txn.data)
    #logger.info('v: %s' % txn.v)
    #logger.info('r: %s' % txn.r)
    #logger.info('s: %s' % txn.s)
    #logger.info('sender: %s' % txn.sender)

    resp = utxoGetUnspendOutput(txn.sender.lower(), int(txn.value))
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": "0xe670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331"
    }
    if not resp:
        return ret

    tx = new_utxo_transaction(txn.sender.lower(), toAddr.lower(), int(txn.value), resp['accumulated'], resp['unspent_outs'])
    if not tx:
        return ret
    ret['result'] = tx.ID
    logger.info('eth_sendRawTransaction tx.ID=%s' % tx.ID)
    trans = tx.serialize().replace('"', "'", -1)
    resp = utxoBroadTx(trans)
    return ret

def eth_call(reqDict):
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": "0x"
    }
    return ret

def trace_call(reqDict):
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": "0x"
    }
    return ret

def eth_estimateGas(reqDict):
    ret = {
        "id": reqDict['id'],
        "jsonrpc": "2.0",
        "result": "0x5208"
    }
    return ret

def tri(request):
    postBody = request.body
    headers = {'Content-Type': 'application/json; charset=UTF-8'}
    if request.method == 'OPTIONS':
        return HttpResponse()

    supportedMethods = {'eth_blockNumber': eth_blockNumber,
               'net_version': net_version,
               'eth_getBalance': eth_getBalance,
               'eth_getTransactionByHash': eth_getTransactionByHash,
               'eth_gasPrice': eth_gasPrice,
               'eth_getTransactionCount': eth_getTransactionCount,
               'eth_sendRawTransaction': eth_sendRawTransaction,
               'eth_call': eth_call,
               'trace_call': trace_call,
               'eth_estimateGas': eth_estimateGas,
               }

    try:
        reqObject = load_json(postBody)
        if isinstance(reqObject, dict):
            method = reqObject["method"]
            if not method:
                raise (Exception("method not find"))
            if not method in supportedMethods:
                raise (Exception("method not supported %s" % method))
            func = supportedMethods[method]
            retObject = func(reqObject)
        elif isinstance(reqObject, list):
            retObject = []
            for reqDict in reqObject:
                method = reqDict["method"]
                if not method:
                    raise (Exception("method not find"))
                if not method in supportedMethods:
                    raise (Exception("method not supported %s" % method))
                func = supportedMethods[method]
                retObjectSingle = func(reqDict)
                retObject.append(retObjectSingle)
        else:
            raise (Exception("method not find"))
    except Exception as e:
        logger.error("tri receive error, e=%s, body=%s" % (e, request.body))
        traceback.print_exc()
        err = {
            "jsonrpc": "2.0",
            "id": 1,
            "error": {
                "code": -1,
                "message": "not support method " + method
            }
        }
        return JsonResponse(err)

    return JsonResponse(retObject, safe=False)

def newCoinbase(request):
    postBody = request.body
    headers = {'Content-Type': 'application/json; charset=UTF-8'}
    if request.method == 'OPTIONS':
        return HttpResponse()

    try:
        reqObject = load_json(postBody)
        if isinstance(reqObject, dict):
            address = reqObject["address"]
            if not address:
                raise (Exception("body need address param"))
            tx = new_coinbase_tx(address.lower())
            trans = tx.serialize().replace('"', "'", -1)
            resp = utxoBroadTx(trans)
        else:
            raise (Exception("body need json"))
    except Exception as e:
        logger.error("newCoinbase error, e=%s, body=%s" % (e, request.body))
        traceback.print_exc()
        err = {
            "jsonrpc": "2.0",
            "id": 1,
            "error": {
                "code": -1,
                "message": "newCoinbase error "
            }
        }
        return JsonResponse(err)

    return HttpResponse(resp)


def utxoBroadTx(rawTx):
    url = UTXO_URL + '/broadcast_tx'
    data = {'tx': rawTx}
    logger.info('utxoBroadTx, rawTx=%s' % rawTx)
    resp = requests.post(url, data)
    logger.info('utxoBroadTx, resp=%s' % resp)
    return resp

def utxoGetLatestHeight():
    url = UTXO_URL + '/get_latest_block_height'
    resp = requests.get(url)
    resp = json.loads(resp.content.decode("utf-8"))
    logger.info('utxoGetLatestHeight resp=%s, url=%s' % (resp, url))
    return resp['latest_block_height']

def utxoGetBalance(address):
    url = UTXO_URL + '/get_balance?address=' + address.lower()
    resp = requests.get(url)
    resp = json.loads(resp.content.decode("utf-8"))
    if resp['code'] != 'success':
        logger.error('utxoGetBalance resp error: %s' % resp)
        return None
    logger.info('utxoGetBalance resp=%s, url=%s' % (resp, url))
    return resp['balance']

def utxoGetUnspendOutput(fromAddress, amount):
    url = UTXO_URL + '/find_spendable_outputs?from_address=' + fromAddress.lower() + '&amount=' + str(amount)
    resp = requests.get(url)
    resp = json.loads(resp.content.decode("utf-8"))
    if resp['code'] != 'success':
        logger.error('utxoGetUnspendOutput resp error: %s' % resp)
        return None
    logger.info('utxoGetUnspendOutput resp=%s, url=%s' % (resp, url))
    return resp

def getCoinbase(request):
    return render(request, 'get_coinbase.html')
