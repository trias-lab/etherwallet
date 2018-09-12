"""
index message
"""
import time
from django.http import JsonResponse
import json
from wallet.utils.time_util import stamp2UTCdatetime
import string
import random

_cache = {}

def random_str(len):
    base_list = string.ascii_letters+string.digits
    random_list = [random.choice(base_list) for i in range(len)]
    return ''.join(random_list)

def rate(request):
    re_dict = {
        "objects": [{
            "pair": "TRIETH",
            "rate": "0.450000",
            "source": "ETH",
            "target": "TRI",
            "timestamp": "2018-09-05T08:27:00.926076"
        },
            {
                "pair": "ETHTRI",
                "rate": "2.200000",
                "source": "TRI",
                "target": "ETH",
                "timestamp": "2018-09-05T08:27:00.926076"
            }
        ]
    }
    return JsonResponse(re_dict)


def order(request):
    try:
        params = json.loads(request.body.decode('utf-8'))
    except Exception as e:
        return JsonResponse({"error": True, "msg": "body should json type"})

    if not params['amount']:
        return JsonResponse({"error": True, "msg": "Need param amount"})
    if not params['destAddress']:
        return JsonResponse({"error": True, "msg": "Need param destAddress"})
    if not params['pair']:
        return JsonResponse({"error": True, "msg": "Need param pair"})
    if not params['pair'] in ["TRIETH", "ETHTRI"]:
        return JsonResponse({"error": True, "msg": "Not support pair"})

    seconds = time.time()
    timestamp = stamp2UTCdatetime(seconds)
    re_dict = {
        "error": False,
        "msg": "",
        "data": {
            "id": "69b968c0020a78c389f815e889720e6f279521eaa5ce81c2291b571c89f5209cabcee6d8b7edb099dc61a82e4a63d5968kZZkZcKDVNANFHPmP78Hw==",
            "amount": "1",
            "pair": "TRIETH",
            "payment_address": "0x7D164c43a7dD36B1a309D0bfD6c66f63f77CBc27",
            "validFor": 600,
            "timestamp_created": "2018-09-05T09:57:32.412800Z",
            "status": "OPEN",
            "input": {
                "amount": "1.00000000",
                "currency": "ETH"
            },
            "output": {
                "amount": "2.100000",
                "currency": "TRI"
            }
        }
    }
    re_dict["data"]["id"] = random_str(120)
    re_dict["data"]["amount"] = params['amount']
    re_dict["data"]["pair"] = params['pair']
    re_dict["data"]["timestamp_created"] = timestamp
    re_dict["data"]["input"]['amount'] = float(params['amount'])
    re_dict["data"]["input"]['currency'] = params['pair'][3:]
    if params['pair'] == "TRIETH":
        re_dict["data"]["output"]['amount'] = float(params['amount']) * 2.2
    else:
        re_dict["data"]["output"]['amount'] = float(params['amount']) * 0.45
    re_dict["data"]["output"]['currency'] = params['pair'][0:3]

    _cache[ re_dict["data"]["id"] ] = {
        "amount":float(params['amount']),
        "pair":params['pair'],
        "seconds":seconds
    }

    response = JsonResponse(re_dict)
    return response


def status(request):
    try:
        params = json.loads(request.body.decode('utf-8'))
    except Exception as e:
        return JsonResponse({"error": True, "msg": "body should json type"})

    if not params['orderid']:
        return JsonResponse({"error": True, "msg": "Need param orderid"})

    seconds = time.time()
    timestamp = stamp2UTCdatetime(seconds)
    re_dict = {
        "error": False,
        "msg": "",
        "data": {
            "id": "69b968c0020a78c389f815e889720e6f279521eaa5ce81c2291b571c89f5209cabcee6d8b7edb099dc61a82e4a63d5968kZZkZcKDVNANFHPmP78Hw==",
            "status": "OPEN",
            "input": {
                "amount": "1.00000000",
                "currency": "ETH",
                "reference": "https://ropsten.etherscan.io/tx/0x8cf75bdfce39ab01a5565140c7dc10a886f40f746000b45772ce7a7e00d0d5b4"
            },
            "output": {
                "amount": "2.100000",
                "currency": "TRI",
                "reference": "https://explorer.trias.one/translist/0x7278f03c8de47f5b66fc2f7835be0e23b8cb2570ad12e61645c26b5fcbd2bced"
            }
        }
    }
    re_dict["data"]["id"] = params['orderid']

    cache_obj = _cache.get(params['orderid'])
    if cache_obj:
        re_dict["data"]["input"]['amount'] = cache_obj["amount"]
        re_dict["data"]["input"]['currency'] = cache_obj['pair'][3:]
        if cache_obj['pair'] == "TRIETH":
            re_dict["data"]["output"]['amount'] = cache_obj['amount'] * 2.2
        else:
            re_dict["data"]["output"]['amount'] = cache_obj['amount'] * 0.45
        re_dict["data"]["output"]['currency'] = cache_obj['pair'][0:3]
        elapsed = (int)(seconds - cache_obj["seconds"])
        if elapsed >= 10 and elapsed < 20:
            re_dict["data"]["status"] = "RCVE"
        elif elapsed >= 20:
            re_dict["data"]["status"] = "FILL"

    for key in list(_cache):
        elapsed = seconds - _cache[key]["seconds"]
        if elapsed > 30:
            _cache.pop(key)

    response = JsonResponse(re_dict)
    return response



