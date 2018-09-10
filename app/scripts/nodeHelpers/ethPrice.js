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
    //步骤一:创建异步对象
    // var ajax = new XMLHttpRequest();
    // //步骤二:设置请求的url参数,参数一是请求的类型,参数二是请求的url,可以带参数,动态的传递参数starName到服务端
    // ajax.open('get', 'http://localhost:8000/api/swap/rate/');
    // //步骤三:发送请求
    // ajax.send();
    // //步骤四:注册事件 onreadystatechange 状态改变就会调用
    // ajax.onreadystatechange = function () {
    //     if (ajax.readyState == 4 && ajax.status == 200) {
    //         //步骤五 如果能够进到这个判断 说明 数据 完美的回来了,并且请求的页面是存在的
    //         console.log('1111111'); //输入相应的内容
    //     }
    // }
    ajaxReq.http.get("http://192.144.140.64:8701/api/swap/rate/").then(function (data) {
        console.log('1111')
        console.log(data['data']['objects'])
        callback(data['data']['objects']);
    });
}
module.exports = ethPrice;