'use strict'
var globalService = function($http, $httpParamSerializerJQLike) {

  globalFuncs.checkAndRedirectHTTPS()
  ajaxReq.http = $http
  ajaxReq.postSerializer = $httpParamSerializerJQLike
  ajaxReq.getETHvalue = nodes.ethPrice.getETHvalue
  ajaxReq.getTRIRates = nodes.ethPrice.getTRIRates
  ajaxReq.getRates = nodes.ethPrice.getRates

  var tabs = {
  homepage: {
    id: 0,
    name: "NAV_Homepage_alt",
    url: "homepage",
    mew: true,
    cx: false
  },
  generateWallet: {
    id: 1,
    name: "NAV_GenerateWallet_alt",
    url: "generate-wallet",
    mew: true,
    cx: false
  },
  myWallet: {
    id: 2,
    name: "NAV_MyWallets",
    url: "my-wallet",
    mew: false,
    cx: true
  },
  addWallet: {
    id: 3,
    name: "NAV_AddWallet",
    url: "add-wallet",
    mew: false,
    cx: true
  },
  sendTransaction: {
    id: 4,
    name: "NAV_SendTRI",
    url: "send-transaction",
    mew: true,
    cx: true
  },
  swap: {
    id: 5,
    name: "NAV_Swap",
    url: "swap",
    mew: true,
    cx: true
  },
  viewWalletInfo: {
    id: 6,
    name: "NAV_ViewAccount",
    url: "view-wallet-info",
    mew: true,
    cx: false
  },
  offlineTransaction: {
    id: 7,
    name: "NAV_Offline",
    url:"offline-transaction",
    mew: true,
    cx: false
  },
  signMsg: {
    id: 8,
    name: "NAV_SignMsg",
    url: "sign-message",
    mew: false,
    cx: false
  },
  bulkGenerate: {
    id: 9,
    name: "NAV_BulkGenerate",
    url: "bulk-generate",
    mew: false,
    cx: false
  }
  // contracts: {
  //   id: 7,
  //   name: "NAV_Contracts",
  //   url: "contracts",
  //   mew: true,
  //   cx: true
  // },
  // ens: {
  //   id:8,
  //   name: "NAV_ENS",
  //   url: "ens",
  //   mew: true,
  //   cx: true
  // },
  // domainsale: {
  //   id: 9,
  //   name: "NAV_DomainSale",
  //   url: "domainsale",
  //   mew: true,
  //   cx: true
  // },
  // txStatus: {
  //   id: 10,
  //   name: "NAV_CheckTxStatus",
  //   url: "check-tx-status",
  //   mew: true,
  //   cx: true
  // },
  }

  var currentTab = 0
  if(typeof chrome != 'undefined')
    currentTab = chrome.windows === undefined ? 0 : 3
  return {
    tabs: tabs,
    currentTab: currentTab
  }

  // var tokensLoaded = false

}

module.exports = globalService


