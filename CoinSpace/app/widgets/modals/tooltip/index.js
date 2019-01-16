'use strict';

var Ractive = require('widgets/modals/base')
// add translate user change 
var language = require('lib/i18n')
var translate = require('counterpart')

module.exports = function showTooltip(data){

  if (process.env.BUILD_TYPE === 'phonegap') {
    data.bottomLink = false
  }

  // // add translate user change 
  data.languageName = language.getLanguage()
  data.translate = translate
  data.translation = {}

  var ractive = new Ractive({
    el: document.getElementById('tooltip'),
    components: {
      ChangeLocales: import('lib/changeLocales/index.js')
    },
    partials: {
      content: require('./content.ract'),
    },
    data: data
  })

  ractive.on('close', function(){
    ractive.fire('cancel')
  })

  return ractive
}

