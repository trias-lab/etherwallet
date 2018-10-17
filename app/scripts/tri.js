'use strict';
var tri = function () { }
// tri.SERVERURL = "http://172.21.0.46:8701";
tri.SERVERURL = "https://wallet.trias.one";
// tri.SERVERURL = "http://192.144.140.64:8701";
tri.decimals = 6;
tri.ethExplorer = 'https://explorer.trias.one/translist/[[txHash]]';
tri.validStatus = ["RCVE", "FILL", "CONF", "EXEC"];
tri.invalidStatus = ["CANC"];
tri.mainPairs = ['TRI','ETH'];
tri.min = 0.01;
tri.max = 3;
tri.prototype.priceLoaded = false;
tri.prototype.refreshRates = function (callback) {
    var _this = this;
    ajaxReq.getTRIRates(function (data) {
        _this.curRate = {};
        data.forEach(function (pair) {
            _this.curRate[pair.pair] = parseFloat(pair.rate)
        });
        _this.priceLoaded = true;
        if (callback) callback();
    });
}
module.exports = tri;
