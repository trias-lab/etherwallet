"""
"""
from django.http import HttpResponse
from django.http import JsonResponse
from urllib import request as HttpReq
import json
from etherwallet.settings import CONF_JSON
from wallet.utils.logger import logger

def tri(request):
    postBody = request.body
    headers = {'Content-Type': 'application/json; charset=UTF-8'}

    with open(CONF_JSON, 'r') as conf:
        rec = conf.read()
    records = json.loads(rec)
    tri_ip = records['eth_ip']
    tri_port = records['eth_port']
    url = "http://" + tri_ip + ":" + tri_port
    req = HttpReq.Request(url, headers=headers, data=postBody)

    try:
        response = HttpReq.urlopen(req).read()
    except Exception as e:
        logger.error(e)
        err = {
            "jsonrpc": "2.0",
            "id": 1,
            "error": {
                "code": -1,
                "message": "tri node connect error"
            }
        }
        return JsonResponse(err)

    response = HttpResponse(response)
    return response





