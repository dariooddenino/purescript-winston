module Log.Winston.Types where

import Prelude
import Data.Foreign (Foreign)
import Data.Maybe (Maybe(..), maybe, isJust)
import Data.Options (Option, opt, options, optional, (:=))
import Data.StrMap as M
import Data.StrMap.ST as SM
import Data.Foldable (foldr, for_)

foreign import data LOG :: !
foreign import data Logger :: *
--foreign import data Transport :: *

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

data Transport = Transport

foreign import data WinstonOpts :: *

lvlOpt :: Option WinstonOpts (Maybe Level)
lvlOpt = optional $ opt "level"

transportsOpt :: Option WinstonOpts (Maybe (Array Transport))
transportsOpt = optional $ opt "transports"

levelsOpt :: Option WinstonOpts (Maybe (M.StrMap Int))
levelsOpt = optional $ opt "levels"

colorsOpt :: Option WinstonOpts (Maybe (M.StrMap String))
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
      for_ ls (\(LogLevel { level, color }) ->
        case color of
          (Just c) -> SM.poke s level c
          Nothing -> pure s)
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
