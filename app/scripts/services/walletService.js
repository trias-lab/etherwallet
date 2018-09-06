'use strict';
var walletService = function() {
	return {
        wallet: null,
        password:'',
        sendDealStep:1, //sendoffline step control
    }
};
module.exports = walletService;