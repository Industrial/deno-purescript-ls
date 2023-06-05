module Main where

import Prelude

import Cliffy (table)
import Data.Array (filter, concat)
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Deno (args)
import Deno.FileSystem (DirEntry, readDir, stat)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Format (formatPermissions)
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
      size = show entryStat.size
      user = (show entryStat.gid) <> "/" <> (show entryStat.uid)

  pure [
    name,
    mode,
    size,
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

  let entryTable = table 1 0 false (concat [directoryStats, fileStats])

  liftEffect $ log entryTable
