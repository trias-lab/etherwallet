'use strict';
var footerCtrl = function($scope, globalService) {
    var gasPriceKey = "gasPrice";
    $scope.footerModal = new Modal(document.getElementById('disclaimerModal'));
    $scope.ethBlockNumber = "loading";
    $scope.etcBlockNumber = "loading";
    $scope.showBlocks = window.location.protocol == "https:";
    $scope.setBlockNumbers = function() {
        if (!$scope.showBlocks) return;
        ajaxReq.getCurrentBlock(function(data) { $scope.currentBlockNumber = data.data; });
    }
    $scope.setBlockNumbers();
    $scope.globalService = globalService;

    $scope.curLang = globalFuncs.curLang;
    $scope.gasChanged = function() {
        globalFuncs.localStorage.setItem(gasPriceKey, $scope.gas.value);
        ethFuncs.gasAdjustment = $scope.gas.value;
    }
    var setGasValues = function() {
        $scope.gas = {
            curVal: 41,
            value: globalFuncs.localStorage.getItem(gasPriceKey, null) ? parseInt(globalFuncs.localStorage.getItem(gasPriceKey)) : 41,
            max: 99,
            min: 1,
            step: 1
        }
        ethFuncs.gasAdjustment = $scope.gas.value;
    }
    setGasValues();
    $scope.gasChanged();
    // footer about us and concact 
    // control hide or show variate
    $scope.footer = {
        weChat:false,
        telegram:false,
        email:false,
    }
    // user click event
    // param : toggleName --- click concact icon
    $scope.footerWechatToggle = function(toggleName){
        switch(toggleName){
            case 'weChat' :
                $scope.footer.weChat = !$scope.footer.weChat
                break;
            case 'telegram' :
                $scope.footer.telegram = !$scope.footer.telegram
                break;
            case 'email' :
                $scope.footer.email = !$scope.footer.email
                break;
        }
        
    }
};
module.exports = footerCtrl;
