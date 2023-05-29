module Main where

import Data.Array (length)
import Deno (args)
import Effect (Effect)
import Effect.Console (log)
import Prelude

getDirectory :: Effect String
getDirectory = do
  myargs <- args
  case length myargs of
    0 -> pure "."
    1 -> pure (myargs !! 0)
    _ -> error "More then one argument passed"

main :: Effect Unit
main = do
  directory <- getDirectory
  log directory
