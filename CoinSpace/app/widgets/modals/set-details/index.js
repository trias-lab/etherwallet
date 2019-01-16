'use strict';

var Ractive = require('widgets/modals/base')
var db = require('lib/db')
var emitter = require('lib/emitter')
var showError = require('widgets/modals/flash').showError
var setUsername = require('lib/wallet').setUsername
// add translate user change 
var language = require('lib/i18n')
var translate = require('counterpart')
function fetchDetails(callback){
  var userInfo = db.get('userInfo');
  var name = userInfo.firstName
  if(name && name !== '') {
    return callback()
  }

  openModal({
    name: name,
    email: userInfo.email,
    callback: callback
  })
}

function openModal(data){
  var ractive = new Ractive({
    components: {
      ChangeLocales: import('lib/changeLocales/index.js')
    },
    partials: {
      content: require('./content.ract')
    },
    data:{
      // add translate user change 
      languageName:language.getLanguage(),
      translate:translate,
      translation:{},
    }
  })

  var $nameEl = ractive.find('#set-details-name')

  $nameEl.onkeypress = function(e) {
    e = e || window.event;
    var charCode = e.keyCode || e.which;
    var charStr = String.fromCharCode(charCode);
    if(!charStr.match(/^[a-zA-Z0-9-]+$/)) {
      return false;
    }
  };

  ractive.on('close', function(){
    ractive.fire('cancel')
  })

  ractive.on('submit-details', function(){
    var details = {
      firstName: ractive.get('name') + '',
      email: ractive.get('email')
    }

    if(!details.firstName || details.firstName.trim() === 'undefined') {
      return showError({message: "Without a name, the payer would not be able to identify you on Mecto."})
    }

    ractive.set('submitting', true)

    setUsername(details.firstName, function(err, username){
      if(err) {
        ractive.set('submitting', false)
        if(err.message === 'username_exists') return showError({message: "Username not available"})
        return console.error(err);
      }

      details.firstName = username

      db.set('userInfo', details).then(function() {
        ractive.fire('cancel');
        ractive.set('submitting', false);
        emitter.emit('details-updated', details);
        data.callback();
      }).catch(function(err) {
        data.callback(err);
      });
    })
  })

  return ractive
}

module.exports = fetchDetails

