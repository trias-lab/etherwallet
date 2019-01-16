'use strict';

var Ractive = require('lib/ractive')
var emitter = require('lib/emitter')
// add translate user change 
var language = require('lib/i18n')
var translate = require('counterpart')
module.exports = function(el){
  var ractive = new Ractive({
    el: el,
    template: require('./index.ract'),
    components: {
      ChangeLocales: import('lib/changeLocales/index.js')
    },
    data:{
      // add translate user change 
      languageName:language.getLanguage(),
      translate:translate,
      translation:{},
    }
  })

  var tabElements = {
    send: '#send_tab',
    receive: '#receive_tab',
    exchange: '#exchange_tab',
    history: '#history_tab',
    tokens: '#tokens_tab'
  }
  var active;
  function highlightTab(node){
    if(node !== active && active && active.classList.contains('active')) {
      active.classList.remove('active')
    }
    node.classList.add('active')
    active = node
  }

  emitter.once('wallet-ready', function() {
    highlightTab(ractive.find(tabElements.send));
  });

  emitter.on('change-tab', function(tab) {
    highlightTab(ractive.find(tabElements[tab]));
  })

  emitter.on('toggle-menu', function(open) {
    var classes = ractive.el.classList
    if (open) {
      classes.add('open')
    } else {
      classes.remove('open')
    }
  })

  ractive.on('select', function(context){
    context.original.preventDefault();
    emitter.emit('change-tab', context.node.dataset.tab)
    highlightTab(context.node);
  })


  return ractive
}
