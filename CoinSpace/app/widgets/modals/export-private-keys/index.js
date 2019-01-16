'use strict';

var Ractive = require('widgets/modals/base');
var getWallet = require('lib/wallet').getWallet;
var showInfo = require('widgets/modals/flash').showInfo;
var isOpen = false;
// add translate user change 
var language = require('lib/i18n')
var translate = require('counterpart')
function open() {
  if (isOpen) return;
  isOpen = true;

  var ractive = new Ractive({
    el: document.getElementById('flash-modal'),
    partials: {
      content: require('./content.ract')
    },
    components: {
      ChangeLocales: import('lib/changeLocales/index.js')
    },
    data: {
      isShown: false,
      privateKeys: '',
      isPhonegap: process.env.BUILD_TYPE === 'phonegap',
      onDismiss: function() {
        isOpen = false;
      },
      // add translate user change 
      languageName:language.getLanguage(),
      translate:translate,
      translation:{},
    }
  });

  ractive.on('close', function(){
    ractive.fire('cancel');
  });

  ractive.on('show-keys', function() {
    var privateKeys = getWallet().exportPrivateKeys();
    if (privateKeys.length === 0) {
      ractive.fire('cancel');
      return showInfo({
        message: 'Your wallet has no private keys with coins for export.',
        fadeInDuration: 0
      });
    }
    ractive.set('privateKeys', privateKeys);
    ractive.set('isShown', true);
  });

  ractive.on('export-keys', function() {
    window.plugins.socialsharing.shareWithOptions({
      message: ractive.get('privateKeys')
    });
  });

  return ractive;
}

module.exports = open;
