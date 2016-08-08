module Log.Winston.Types where

data LogLevel = LogLevel String Int

errorLevel :: LogLevel
errorLevel = LogLevel "error" 0

warnLevel :: LogLevel
warnLevel = LogLevel "warn" 1

infoLevel :: LogLevel
infoLevel = LogLevel "info" 2

verboseLevel :: LogLevel
verboseLevel = LogLevel "verbose" 3

debugLevel :: LogLevel
debugLevel = LogLevel "debug" 4

sillyLevel :: LogLevel
sillyLevel = LogLevel "silly" 5


data Message = Message String
