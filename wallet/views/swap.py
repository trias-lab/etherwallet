"""
index message
"""
import time
from django.http import JsonResponse
import json
from wallet.utils.time_util import stamp2UTCdatetime
import string
import random
from wallet.models import Address, BalanceChange, CoinExchangeList, Order, Transaction
from wallet.utils.account_util import  DBOperation
from wallet.utils.block_util import  ReqData
from decimal import *
from wallet.utils.logger import logger

def random_str(len):
    base_list = string.ascii_letters+string.digits
    random_list = [random.choice(base_list) for i in range(len)]
    return ''.join(random_list)

def rate(request):
    all = CoinExchangeList.objects.all()
    re_dict = { "objects": []}
    for ce in all:
        obj = {}
        obj["pair"] = ce.source_coin_name + ce.target_coin_name
        obj["rate"] = ce.rate
        obj["source"] = ce.source_coin_name
        obj["target"] = ce.target_coin_name
        obj["timestamp"] = stamp2UTCdatetime(ce.rate_update_time_stamp)
        re_dict["objects"].append(obj)
    return JsonResponse(re_dict)


def order(request):
    try:
        params = json.loads(request.body.decode('utf-8'))
    except Exception as e:
        return JsonResponse({"error": True, "msg": "body should json type"})

    if not params.get('amount'):
        return JsonResponse({"error": True, "msg": "Need param amount"})
    if not params.get('destAddress'):
        return JsonResponse({"error": True, "msg": "Need param destAddress"})
    if not params.get('pair'):
        return JsonResponse({"error": True, "msg": "Need param pair"})
    if not (params.get('pair') in ["TRIETH", "ETHTRI"]):
        return JsonResponse({"error": True, "msg": "Not support pair"})

    re_dict = {
        "error": False,
        "msg": "",
        "data": {
            "input":{},
            "output": {}
        }
    }

    try:
        sourceCoin = params['pair'][0:3]
        targetCoin = params['pair'][3:]
        ce = CoinExchangeList.objects.filter(source_coin_name=sourceCoin, target_coin_name=targetCoin).first()
        targetAmount = Decimal(params['amount']) * Decimal(ce.rate)
        if not DBOperation.isBalanceSufficient(targetCoin, targetAmount):
            re_dict["error"] = True
            re_dict["msg"] = "insufficient balance for coin %s of amount %s" % (targetCoin, targetAmount)
            response = JsonResponse(re_dict)
            return response

        re_dict["data"]["id"] = random_str(100)
        re_dict["data"]["amount"] = params['amount']
        re_dict["data"]["pair"] = params['pair']
        re_dict["data"]["payment_address"] = DBOperation.genNewAddress(sourceCoin, False)
        re_dict["data"]["validFor"] = ce.order_valid_seconds
        seconds = time.time()
        timestamp = stamp2UTCdatetime(seconds)
        re_dict["data"]["timestamp_created"] = timestamp
        re_dict["data"]["status"] = "OPEN"
        re_dict["data"]["input"]['amount'] = Decimal(params['amount'])
        re_dict["data"]["input"]['currency'] = sourceCoin
        re_dict["data"]["output"]['amount'] = targetAmount
        re_dict["data"]["output"]['currency'] = targetCoin

        order = Order()
        order.order_id = re_dict["data"]["id"]
        order.source_coin_name = sourceCoin
        order.source_amount = re_dict["data"]["input"]['amount']
        order.target_coin_name = targetCoin
        order.target_amount = re_dict["data"]["output"]['amount']
        order.create_time_stamp = seconds
        order.rate = ce.rate
        order.target_coin_address = params.get('destAddress')
        order.source_coin_payment_address = re_dict["data"]["payment_address"]
        order.source_coin_payment_amount = 0
        order.transaction_in_id = 0
        order.transaction_out_id = 0
        order.is_finished = False
        order.save()
        logger.info("%s->%s insert order in db, id=%s" % (sourceCoin, targetCoin, order.id))
        response = JsonResponse(re_dict)
    except Exception as e:
        logger.error(e)

    return response

def status(request):
    try:
        params = json.loads(request.body.decode('utf-8'))
    except Exception as e:
        return JsonResponse({"error": True, "msg": "body should json type"})

    if not params.get('orderid'):
        return JsonResponse({"error": True, "msg": "Need param orderid"})

    seconds = time.time()
    timestamp = stamp2UTCdatetime(seconds)
    re_dict = {
        "error": False,
        "msg": "",
        "data": {
            "id": "",
            "status": "OPEN",
            "input": {
                "amount": "",
                "currency": "",
                "reference": ""
            },
            "output": {
                "amount": "",
                "currency": "",
                "reference": ""
            }
        }
    }
    re_dict["data"]["id"] = params['orderid']
    try:
        order = Order.objects.filter(order_id=params['orderid']).first()
    except:
        order = None
    if not order:
        re_dict["error"] = True
        re_dict["msg"] = "can not find order"
        response = JsonResponse(re_dict)
        return response
    re_dict["data"]["input"]['amount'] = str(order.source_amount)
    re_dict["data"]["input"]['currency'] = order.source_coin_name
    re_dict["data"]["output"]['amount'] = str(order.target_amount)
    re_dict["data"]["output"]['currency'] = order.target_coin_name
    if order.is_finished:
        re_dict["data"]["input"]['reference'] = ReqData.getTransactionWebUrl(order.source_coin_name, order.tx_in_hash)
        re_dict["data"]["output"]['reference'] = ReqData.getTransactionWebUrl(order.target_coin_name, order.tx_out_hash)
        re_dict["data"]["status"] = "FILL"
        response = JsonResponse(re_dict)
        return response
    if order.tx_in_hash:
        if order.source_amount > order.source_coin_payment_amount:
            re_dict["data"]["input"]['reference'] = ReqData.getTransactionWebUrl(order.source_coin_name, order.tx_in_hash)
            re_dict["msg"] = "receive amount %s, less than required amount %s" % (order.source_coin_payment_amount, order.source_amount)
            response = JsonResponse(re_dict)
            return response
        else:
            re_dict["data"]["input"]['reference'] = ReqData.getTransactionWebUrl(order.source_coin_name, order.tx_in_hash)
            re_dict["data"]["status"] = "RCVE"
            response = JsonResponse(re_dict)
            return response
    response = JsonResponse(re_dict)
    return response



