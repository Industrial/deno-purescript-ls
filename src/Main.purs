module Main where

import Prelude

import Cliffy (table)
import Data.Array (concat, filter, sort)
import Data.Maybe (Maybe(..))
import Data.Traversable (traverse)
import Deno (args)
import Deno.FileSystem (DirEntry, readDir, stat)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Format (formatDirEntry)
import Permissions (getPermissions)

getDirectory :: Effect String
getDirectory = do
  myargs <- args
  case myargs of
    [] -> pure "."
    [ arg ] -> pure arg
    _ -> pure "."

filePath :: String -> String -> String
filePath directory name = directory <> "/" <> name

formatEntry :: String -> DirEntry -> Aff (Array String)
formatEntry directory entry = do
  let entryPath = filePath directory entry.name
  entryStat <- stat entryPath
  entryPermissions <- case getPermissions entryStat of
    Just perms -> pure perms
    Nothing -> pure [ [ false, false, false ], [ false, false, false ], [ false, false, false ] ]

  pure $ formatDirEntry entry entryStat entryPermissions

main :: Effect Unit
main = launchAff_ do
  directory <- liftEffect getDirectory
  entries <- readDir directory

  let directories = filter (\e -> e.isDirectory) entries
  let files = filter (\e -> not e.isDirectory) entries

  directoryStats <- traverse (formatEntry directory) directories
  fileStats <- traverse (formatEntry directory) files

  let entryTable = table 1 0 false (concat [ sort directoryStats, sort fileStats ])

  liftEffect $ log entryTable
