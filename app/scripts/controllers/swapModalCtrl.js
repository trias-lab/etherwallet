'use strict';
var swapModalCtrl = function ($scope, $sce, $rootScope) {
    $scope.ajaxReq = ajaxReq;
    $scope.tokensLoaded = false;
    $scope.showAllTokens = false;
    $scope.localToken = {
        contractAdd: "",
        symbol: "",
        decimals: "",
        type: "custom",
    };

    $scope.slide = 1;

    $scope.customTokenField = false;

    $scope.sureClick = function (signedTx, callback) {
        if (signedTx.slice(0, 2) !== '0x') {
            var txParams = JSON.parse(signedTx)
            window.web3.eth.sendTransaction(txParams, function (err, txHash) {
                if (err) {
                    return callback({
                        isError: true,
                        error: err.stack,
                    })
                }
                callback({
                    data: txHash
                })
            });
            return
        }

        ajaxReq.sendRawTx(signedTx, function (data) {
            var resp = {};
            if (data.error) {
                resp = {
                    isError: true,
                    error: data.msg
                };
            } else {
                resp = {
                    isError: false,
                    data: data.data
                };
            }
            if (callback !== undefined) callback(resp);
        });
        $scope.notifier.danger('哈哈,你在看啥子');
    }
};

module.exports = swapModalCtrl;
