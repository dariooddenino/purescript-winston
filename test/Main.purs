module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Log.Winston
import Log.Winston.Types

main :: forall e. Eff (log :: LOG | e) Unit
main = do
  let wn = defaultLogger
  debug wn "dudu"
