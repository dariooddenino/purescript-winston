module Log.Winston.Types where

import Prelude
import Data.Foreign (Foreign)
import Data.Maybe (Maybe(..), maybe, isJust)
import Data.Options (Option, opt, options, optional, (:=))
import Data.StrMap as M
import Data.StrMap.ST as SM
import Data.Foldable (for_)

foreign import data LOG :: !
foreign import data Logger :: *
foreign import data Transport :: *

data LogLevel = LogLevel
                { level :: Level
                , priority :: Priority
                , color :: Color
                }

type Level = String
type Priority = Int
type Color = Maybe String

errorLevel :: LogLevel
errorLevel = LogLevel
             { level: "error"
             , priority: 0
             , color: Nothing
             }

warnLevel :: LogLevel
warnLevel = LogLevel
            { level: "warn"
            , priority: 1
            , color: Nothing
            }

infoLevel :: LogLevel
infoLevel = LogLevel
            { level: "info"
            , priority: 2
            , color: Nothing
            }

verboseLevel :: LogLevel
verboseLevel = LogLevel
               { level: "verbose"
               , priority: 3
               , color: Nothing
               }

debugLevel :: LogLevel
debugLevel = LogLevel
             { level: "debug"
             , priority: 4
             , color: Nothing
             }

sillyLevel :: LogLevel
sillyLevel = LogLevel
             { level: "silly"
             , priority: 5
             , color: Nothing
             }

foreign import data WinstonOpts :: *

tipe WinstonOpt = Option WinstonOpts

lvlOpt :: WinstonOpt (Maybe Level)
lvlOpt = optional $ opt "level"

transportsOpt :: WinstonOpt (Maybe (Array Transport))
transportsOpt = optional $ opt "transports"

levelsOpt :: WinstonOpt (Maybe (M.StrMap Int))
levelsOpt = optional $ opt "levels"

colorsOpt :: WinstonOpt (Maybe (M.StrMap String))
colorsOpt = optional $ opt "colors"

_extractLevels :: Maybe (Array LogLevel) -> Maybe (M.StrMap Int)
_extractLevels Nothing = Nothing
_extractLevels (Just ls) =
  Just $ M.pureST
  (do
      s <- SM.new
      for_ ls (\(LogLevel { level, priority }) -> SM.poke s level priority)
      pure s)

_extractColors :: Maybe (Array LogLevel) -> Maybe (M.StrMap String)
_extractColors Nothing = Nothing
_extractColors (Just ls) =
  Just $ M.pureST
  (do
      s <- SM.new
      for_ ls (\(LogLevel { level, color }) -> maybe (pure s) (SM.poke s level) color)
      pure s)

-- level
-- levels { foo: 0, bar: 1, baz: 2 }
-- colors { foo: 'blue', bar: 'green', baz: 'yellow'}

_makeOptions :: Maybe LogLevel -> Maybe (Array LogLevel) -> Maybe (Array Transport) -> Foreign
_makeOptions l ls t = options $
  lvlOpt := (map (\(LogLevel { level }) -> level) l) <>
  levelsOpt := (_extractLevels ls) <>
  colorsOpt := (_extractColors ls) <>
  transportsOpt := t


-- Transports options

-- Console

silentOpt :: WinstonOpt Boolean
silentOpt = opt "silent"

colorizeOpt :: WinstonOpt Boolean
colorizeOpt = opt "colorize"

timestampOpt :: WinstonOpt Boolean
timestampOpt = opt "timestamp"

jsonOpt :: WinstonOpt Boolean
jsonOpt = opt "json"

stringifyOpt :: WinstonOpt Boolean
stringifyOpt = opt "stringify"

prettyPrintOpt :: WinstonOpt Boolean
prettyPrintOpt = opt "prettyPrint"

depthOpt :: WinstonOpt Int
depthOpt = opt "depth"

humanReadableUnhandledExceptionOpt :: WinstonOpt Boolean
humanReadableUnhandledExceptionOpt = opt "humanReadableUnhandledExceptionOpt"

showLevelOpt :: WinstonOpt Boolean
showLevelOpt = opt "showLevel"

-- formatterOpt ?

stderrLevelsOpt :: Array LogLevel -> WinstonOpt (Array String)
stderrLevelsOpt = opt "stderrLevel" <<< map (\ (LogLevel { level }) -> level)

-- File

filenameOpt :: WinstonOpt String
filenameOpt = opt "filename"

maxsizeOpt :: WinstonOpt Int
maxsizeOpt = opt "maxsize"

maxFilesOpt :: WinstonOpt Int
maxFilesOpt = opt "maxFiles"

-- streamOpt ?

eolOpt :: WinstonOpt String
eolOpt = opt "eol"

logstashOpt :: WinstonOpt Boolean
logstashOpt = opt "logstash"

tailableOpt :: WinstonOpt Boolean
tailableOpt = opt "tailable"

maxRetriesOpt :: WinstonOpt Int
maxRetriesOpt = opt "maxRetries"

zippedArchiveOpt :: WinstonOpt Boolean
zippedArchiveOpt = opt "zippedArchive"

-- optionsOps ?

-- HTTP

hostOpt :: WinstonOpt String
hostOpt = opt "host"

portOpt :: WinstonOpt Int
portOpt = opt "port"

pathOpt :: WinstonOpt String
pathOpt = opt "path"

-- auth ?

sslOpt :: WinstonOpt Boolean
sslOpt = opt "ssl"
