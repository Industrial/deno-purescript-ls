module Main where

import Prelude

import Cliffy (table)
import Data.Array (concat, filter, (!!), sort)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.String (Pattern(..), split)
import Data.Traversable (traverse)
import Deno (args)
import Deno.FileSystem (DirEntry, readDir, stat)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Format (formatPermissions, formatSize)
import Permissions (getPermissions)

getDirectory :: Effect String
getDirectory = do
  myargs <- args
  case myargs of
    []    -> pure "."
    [arg] -> pure arg
    _     -> pure "."

filePath :: String -> String -> String
filePath directory name = directory <> "/" <> name

formatEntryName :: DirEntry -> String
formatEntryName entry = case entry.isDirectory of
  true -> entry.name <> "/"
  _    -> entry.name

formatEntry :: String -> DirEntry -> Aff (Array String)
formatEntry directory entry = do
  let entryPath = filePath directory entry.name
  entryStat <- stat entryPath
  entryPermissions <- case getPermissions entryStat of
    Just perms -> pure perms
    Nothing -> pure [[false, false, false], [false, false, false], [false, false, false]]

  let name = formatEntryName entry
  let mode = formatPermissions entryPermissions
      size = split (Pattern " ") $ formatSize entryStat.size
      user = (show entryStat.gid) <> "/" <> (show entryStat.uid)

  let sizeAmount = fromMaybe "N/A" $ size !! 0
  let sizeMeasure = fromMaybe "N/A" $ size !! 1

  pure [
    name,
    mode,
    sizeAmount,
    sizeMeasure,
    user
  ]

main :: Effect Unit
main = launchAff_ do
  directory <- liftEffect getDirectory
  entries <- readDir directory

  let directories = filter (\entry -> entry.isDirectory) entries
  let files = filter (\entry -> not entry.isDirectory) entries

  directoryStats <- traverse (formatEntry directory) directories
  fileStats <- traverse (formatEntry directory) files

  let entryTable = table 1 0 false (concat [sort directoryStats, sort fileStats])

  liftEffect $ log entryTable
