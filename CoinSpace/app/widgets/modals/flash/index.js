'use strict';

var Ractive = require('widgets/modals/base')

// add translate user change 
var language = require('lib/i18n')
var translate = require('counterpart')

var defaults = {
  error: {
    error: true,
    title: 'Whoops!'
  },
  info: {
    warning: true,
    title: 'Just saying...'
  }
}

var isOpen = false;

function openModal(type, data) {
  if (isOpen) return;
  isOpen = true
  data = data || {}
  data.error = defaults[type].error
  data.warning = defaults[type].warning
  data.title = data.title || defaults[type].title
  data.type = type
  data.onDismiss = function() {
    isOpen = false;
  }

   // // add translate user change 
   data.languageName = language.getLanguage()
   data.translate = translate
   data.translation = {}

  var ractive = new Ractive({
    el: document.getElementById('flash-modal'),
    partials: {
      content: require('./content.ract')
    },
    components: {
      ChangeLocales: import('lib/changeLocales/index.js')
    },
    data: data
  })

  ractive.on('close', function(){
    ractive.fire('cancel')
  })

  return ractive
}

function showError(data) {
  if (data.message === 'Network Error') {
    data.message = 'Request timeout. Please check your internet connection.'
  }
  return openModal('error', data)
}

function showInfo(data) {
  return openModal('info', data)
}

module.exports = {
  showError: showError,
  showInfo: showInfo
}
