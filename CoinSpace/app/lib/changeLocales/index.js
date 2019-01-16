'use strict';

var Ractive = require('lib/ractive')
var emitter = require('lib/emitter')
var language = require('lib/i18n')
var translate = require('counterpart')


var ChangeLocales = Ractive.extend({
  template: require('./index.ract'),
  // 初始化方法
  oninit : function(){

    var ractive = this;
    ractive.on('language-change',function(){
      $('.select-language .pick-wallet-list').toggle();
    })
    ractive.on('language-select',function(context){
      var languageName = context.node.textContent
      $('.select-language .pick-wallet-list').hide();
  
      emitter.emit('changeLocales',languageName)
      
    })
    emitter.on('changeLocales',function(languageName){

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
  },
  data:function(){
    return {
        languageName:language.getLanguage(),
        translate:translate,
        translation:{},
    }
  }
});       

module.exports = ChangeLocales
