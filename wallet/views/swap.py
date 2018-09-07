"""
index message
"""
import datetime
import time
from django.http import JsonResponse
from django.db.models import Q
from collections import OrderedDict


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
    return JsonResponse(re_dict)


def status(request):
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

    return JsonResponse(re_dict)



