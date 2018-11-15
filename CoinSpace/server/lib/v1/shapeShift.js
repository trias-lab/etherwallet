'use strict';

var db = require('./db');

function getToken(walletId) {
  var collection = db().collection('shapeShift');
  return collection
    .find()
    .limit(1)
    .next().then(function(doc) {
      if (!doc) return '';
      return doc;
    });
}

module.exports = {
  getToken: getToken
}
