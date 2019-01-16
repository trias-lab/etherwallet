'use strict';

var Ractive = require('lib/ractive');
var emitter = require('lib/emitter');
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
      // add translate user change 
      languageName:language.getLanguage(),
      translate:translate,
      translation:{},
    },
    partials: {
      footer: require('../footer.ract')
    }
  });

  var delay = 60 * 1000; // 60 seconds
  var interval;

  ractive.on('before-show', function() {
    interval = setInterval(function() {
      emitter.emit('shapeshift');
    }, delay);
  });

  ractive.on('before-hide', function() {
    clearInterval(interval);
  });

  return ractive;
}
