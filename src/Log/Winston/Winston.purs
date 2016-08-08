module Log.Winston where

import Prelude
import Log.Winston.Types
import Control.Monad.Eff
import Data.Foreign
import Data.Foreign.Class
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Maybe (Maybe)

foreign import _defaultLogger :: Logger

defaultLogger :: Logger
defaultLogger = _defaultLogger

foreign import _createLogger :: Foreign -> Logger

-- level
-- Array LogLevel
-- Array Transports

createLogger :: Maybe LogLevel -> Maybe (Array LogLevel) -> Maybe (Array Transport) -> Logger
createLogger l ls t = _createLogger $ _makeOptions l ls t

foreign import _log
  :: forall eff
   . Fn3 Logger
     String
     String
     (Eff (log :: LOG | eff) Unit)

log
  :: forall eff m
   . Show m
  => Logger
  -> LogLevel
  -> m
  -> Eff (log :: LOG | eff) Unit
log wn (LogLevel { level }) m = runFn3 _log wn level (show m)

spyLog
  :: forall eff m
   . Show m
  => Logger
  -> LogLevel
  -> m
  -> Eff (log :: LOG | eff) m
spyLog wn l m = do
  log wn l m
  pure m

error
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) Unit
error wn = log wn errorLevel

spyError
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) m
spyError wn m = do
  error wn m
  pure m

warn
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) Unit
warn wn = log wn warnLevel

spyWarn
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) m
spyWarn wn m = do
  warn wn m
  pure m

info
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) Unit
info wn = log wn infoLevel

spyInfo
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) m
spyInfo wn m = do
  info wn m
  pure m

verbose
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) Unit
verbose wn = log wn verboseLevel

debug
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) Unit
debug wn = log wn debugLevel

spyDebug
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) m
spyDebug wn m = do
  debug wn m
  pure m

silly
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) Unit
silly wn = log wn sillyLevel

spySilly
  :: forall eff m
   . Show m
  => Logger
  -> m
  -> Eff (log :: LOG | eff) m
spySilly wn m = do
  silly wn m
  pure m
