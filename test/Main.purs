module Test.Main where

import Prelude
import Log.Winston.Types
import Log.Winston
import Control.Monad.Eff
import Data.Maybe (Maybe(..))

err = LogLevel { level: "error", priority: 0, color: Just "red" }
dbug = LogLevel { level: "debug", priority: 1, color: Just "magenta"}
levels = [dbug, err]

main :: forall e. Eff (log :: LOG | e) Unit
main = do
  let wn = createLogger (Just dbug) (Just levels) Nothing
  --let wn = defaultLogger
  debug wn "debug"
  error wn "error"
