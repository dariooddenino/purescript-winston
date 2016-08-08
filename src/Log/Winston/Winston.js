'use strict';

var winston = require('winston');

exports._defaultLogger = winston;

exports._createLogger = function _createLogger(options) {
  console.log(options);
  options.transports = [new winston.transports.Console({colorize: true})];
  var logger = new (winston.Logger)(options);
  //if (options.colors) {
    //winston.addColors(options.colors);
  //xs}
  return logger;
};

exports._log = function _log(wn, level, message) {
  return function() {
    wn.log(level, message);
    return {};
  };
};
