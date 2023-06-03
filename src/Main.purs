module Main where

import Prelude

import Data.Array (sortBy)
import Data.Foldable (for_)
import Deno (args)
import Deno.FileSystem (DirEntry, readDir)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)

getDirectory :: Effect String
getDirectory = do
  myargs <- args
  case myargs of
    []    -> pure "."
    [arg] -> pure arg
    _     -> pure "."

compareDirectory :: DirEntry -> DirEntry -> Ordering
compareDirectory a b = compare a.isDirectory b.isDirectory

compareName :: DirEntry -> DirEntry -> Ordering
compareName a b = compare a.name b.name

main :: Effect Unit
main = launchAff_ do
  directory <- liftEffect getDirectory
  entries <- readDir directory
  let sortedEntries = sortBy compareName $ sortBy compareDirectory entries
  for_ sortedEntries \entry -> do
    liftEffect $ log entry.name
