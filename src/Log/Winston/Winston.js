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

exports._consoleTransport = function _consoleTransport(options) {
  return new (winston.transports.Console)(options);
};

exports._fileTransport = function _fileTransport(options) {
  return new (winston.transports.File)(options);
};

exports._httpTransport = function _httpTransport(options) {
  return new (winston.transports.HTTP)(options);
};
