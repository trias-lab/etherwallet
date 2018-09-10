"""
# middleware for dispatch url
"""

from django.shortcuts import render_to_response
from django.http import HttpResponse


class CrossDomainAccess(object):

    def process_response(self, request, response):
        origin = request.META.get('HTTP_ORIGIN')
        if origin:
            response["Access-Control-Allow-Origin"] = origin
        return response