'use strict';

var Ractive = require('widgets/modals/base')
// add translate user change 
var language = require('lib/i18n')
var translate = require('counterpart')
module.exports = function(data) {
  var content = null;
  if (data.isNetwork('ethereum')) {
    data.isPendingFee = data.transaction.fee === -1;
    content = require('./contentEthereum.ract')
  } else if (data.isNetwork('ripple')) {
    content = require('./contentRipple.ract')
  } else if (data.isNetwork('stellar')) {
    content = require('./contentStellar.ract')
  } else {
    content = require('./contentBtcBchLtc.ract')
  }
  // // add translate user change 
  data.languageName = language.getLanguage()
  data.translate = translate
  data.translation = {}

  var ractive = new Ractive({
    el: document.getElementById('transaction-detail'),
    components: {
      ChangeLocales: import('lib/changeLocales/index.js')
    },
    partials: {
      content: content
    },
    data: data
  })

  ractive.on('close', function(){
    ractive.fire('cancel')
  })

  return ractive
}

