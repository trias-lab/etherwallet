'use strict';
var http;
var ethPrice = function () {}
var getValue = function (arr, pair) {
    for (var i in arr)
        if (arr[i].pair == pair) return arr[i].rate;
}
var BITYRATEAPI = "https://bity.com/api/v1/rate2/";
var CCRATEAPI = "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD,EUR,GBP,BTC,CHF,REP";
ethPrice.getETHvalue = function (callback) {
    ajaxReq.http.get(CCRATEAPI).then(function (data) {
        data = data['data'];
        var priceObj = {
            usd: parseFloat(data['USD']).toFixed(6),
            eur: parseFloat(data['EUR']).toFixed(6),
            btc: parseFloat(data['BTC']).toFixed(6),
            chf: parseFloat(data['CHF']).toFixed(6),
            rep: parseFloat(data['REP']).toFixed(6),
            gbp: parseFloat(data['GBP']).toFixed(6),
        };
        callback(priceObj);
    });
}
// http://localhost:8000/api/swap/rate/
ethPrice.getRates = function (callback) {
    ajaxReq.http.get("http://127.0.1:8701/api/swap/rate/").then(function (data) {
        callback(data['data']['objects']);
    });
    // ajaxReq.http.get(BITYRATEAPI).then(function (data) {
    //     callback(data['data']['objects']);
    // });
}
module.exports = ethPrice;