'use strict';

var Ractive = require('lib/ractive');
var emitter = require('lib/emitter');
var db = require('lib/db');
// add translate user change 
var language = require('lib/i18n')
var translate = require('counterpart')
module.exports = function(el) {
  var ractive = new Ractive({
    el: el,
    template: require('./index.ract'),
    components: {
      ChangeLocales: import('lib/changeLocales/index.js')
    },
    data: {
      message: '',
      // add translate user change 
      languageName:language.getLanguage(),
      translate:translate,
      translation:{},
    },
    partials: {
      footer: require('../footer.ract')
    }
  });

  ractive.on('before-show', function(context) {
    ractive.set('message', context.message);
  });

  ractive.on('close', function() {
    db.set('exchangeInfo', null).then(function() {
      emitter.emit('change-exchange-step', 'create');
    }).catch(function(err) {
      console.error(err);
    });
  });

  return ractive;
}
