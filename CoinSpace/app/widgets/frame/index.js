'use strict';

var Ractive = require('lib/ractive')
var emitter = require('lib/emitter')
var initHeader = require('widgets/header')
var initTabs = require('widgets/tabs')
var initSidebar = require('widgets/sidebar')
var initTerms = require('widgets/terms')
var initSend = require('pages/send')
var initReceive = require('pages/receive')
var initExchange = require('pages/exchange')
var initHistory = require('pages/history')
var initTokens = require('pages/tokens')
var Hammer = require('hammerjs')
var ads = require('lib/ads')
var language = require('lib/i18n')
var translate = require('counterpart')
module.exports = function(el){
  var ractive = new Ractive({
    el: el,
    template: require('./index.ract'),
    data:{
      languageName:language.getLanguage(),
      translate:translate,
    }
  })

  // widgets
  var header = initHeader(ractive.find('#header'))
  initTabs(ractive.find('#tabs'))
  initSidebar(ractive.find('#sidebar'))
  initTerms(ractive.find('#terms'))

  // tabs
  var tabs = {
    send: initSend(ractive.find('#send')),
    receive: initReceive(ractive.find('#receive')),
    exchange: initExchange(ractive.find('#exchange')),
    history: initHistory(ractive.find('#history')),
    tokens: initTokens(ractive.find('#tokens'))
  }

  var currentPage = tabs.send
  showPage(tabs.send)

  if (process.env.BUILD_TYPE === 'phonegap') {
    Hammer(ractive.find('#main'), {velocity: 0.1}).on('swipeleft', function() {
      if (currentPage === tabs.send) {
        emitter.emit('change-tab', 'receive')
      } else if (currentPage === tabs.receive) {
        emitter.emit('change-tab', 'exchange')
      } else if (currentPage === tabs.exchange) {
        emitter.emit('change-tab', 'history')
      } else if (currentPage === tabs.history) {
        emitter.emit('change-tab', 'tokens')
      }
    })

    Hammer(ractive.find('#main'), {velocity: 0.1}).on('swiperight', function() {
      if (currentPage === tabs.tokens) {
        emitter.emit('change-tab', 'history')
      } else if (currentPage === tabs.history) {
        emitter.emit('change-tab', 'exchange')
      } else if (currentPage === tabs.exchange) {
        emitter.emit('change-tab', 'receive')
      } else if (currentPage === tabs.receive) {
        emitter.emit('change-tab', 'send')
      }
    })
  }

  emitter.on('change-tab', function(tab) {
    var page = tabs[tab]
    if (process.env.BUILD_TYPE === 'phonegap' && currentPage !== page) {
      ads.showInterstitial()
    }
    showPage(page)
  })

  emitter.on('toggle-terms', function(open) {
    var classes = ractive.find('#main').classList
    if (open) {
      classes.add('terms-open')
      classes.add('closed')
    } else {
      classes.remove('terms-open')
      classes.remove('closed')
    }
  })

  function showPage(page){
    currentPage.hide()
    page.show()
    currentPage = page
  }

  // menu toggle
  emitter.on('toggle-menu', function(open) {
    var classes = ractive.find('#main').classList
    if(open) {
      ractive.set('sidebar_open', true)
      classes.add('closed')
    } else {
      ractive.set('sidebar_open', false)
      classes.remove('closed')
    }

    header.toggleIcon(open)
  })

  ractive.on('language-change',function(){
    $('.select-language .pick-wallet-list').toggle();
  })
  ractive.on('language-select',function(context){
    var languageName = context.node.textContent
    $('.select-language .pick-wallet-list').hide();
    if(languageName =="中文" || languageName == "Chinese"){

        var translation = require('lib/i18n/translations/zh-cn.json')

        changeLocales('zh-cn',translation)
        

    }else{

      var translation = require('lib/i18n/translations/en.json')

      changeLocales('en',translation)
    }
  })

  function changeLocales (languageName,translation){
      translate.registerTranslations(languageName, translation)

      translate.setLocale(languageName)
      ractive.set('languageName', languageName);
    return ractive.set('translate', function(translation){ return translate(translation)})
  }

  return ractive
}
