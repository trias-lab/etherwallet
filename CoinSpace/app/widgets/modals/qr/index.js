'use strict';

var Ractive = require('widgets/modals/base-qr')
var qrcode = require('lib/qrcode')
var getTokenNetwork = require('lib/token').getTokenNetwork;
// add translate user change 
var language = require('lib/i18n')
var translate = require('counterpart')
module.exports = function showTooltip(data){
  data.mailto = mailto
  data.title = data.title || 'Your wallet address'


  // // add translate user change 
  data.languageName = language.getLanguage()
  data.translate = translate
  data.translation = {}
  
  var ractive = new Ractive({
    el: document.getElementById('receive'),
    components: {
      ChangeLocales: import('lib/changeLocales/index.js')
    },
    partials: {
      content: require('./content.ract'),
    },
    data: data
  })

  var canvas = ractive.find('#qr-canvas')
  var name = data.name || getTokenNetwork();
  var qr = qrcode.encode(name + ':' + data.address)
  canvas.appendChild(qr)

  ractive.on('close', function(){
    ractive.fire('cancel')
  })

  function mailto() {
    return 'mailto:?body=' + encodeURIComponent(data.address + '\n\nSent from Coin Wallet\nhttps://coin.space')
  }

  return ractive
}

