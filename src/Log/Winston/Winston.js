'use strict';

var winston = require('winston');

exports._defaultLogger = winston;

exports._createLogger = function _createLogger(options) {
  return new (winston.Logger)(options);
};

exports._log = function _log(wn, level, message) {
  return function() {
    wn.log(level, message);
    return {};
  };
};
