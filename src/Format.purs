module Format where

import Prelude

import Data.Array ((!!))
import Data.Maybe (fromMaybe)
import Data.String (Pattern(..), joinWith, split)
import Deno.FileSystem (DirEntry, FileInfo)
import Permissions (FilePermissions)

-- | Converts an octal integer to a Unix file permission string.
formatPermissions :: FilePermissions -> String
formatPermissions permissions = joinWith "" $ map permissionChar permissions
  where
  permissionChar :: Array Boolean -> String
  permissionChar [ false, false, false ] = "---"
  permissionChar [ false, false, true ] = "--x"
  permissionChar [ false, true, false ] = "-w-"
  permissionChar [ false, true, true ] = "-wx"
  permissionChar [ true, false, false ] = "r--"
  permissionChar [ true, false, true ] = "r-x"
  permissionChar [ true, true, false ] = "rw-"
  permissionChar [ true, true, true ] = "rwx"
  permissionChar _ = "???"

-- | Converts a file size in bytes to a string representation.
formatSize :: Int -> String
formatSize size
  | size < 1024 = show size <> " B"
  | size < 1024 * 1024 = show (size `div` 1024) <> " KiB"
  | size < 1024 * 1024 * 1024 = show (size `div` (1024 * 1024)) <> " MiB"
  | size < 1024 * 1024 * 1024 * 1024 = show (size `div` (1024 * 1024 * 1024)) <> " GiB"
  | size < 1024 * 1024 * 1024 * 1024 * 1024 = show (size `div` (1024 * 1024 * 1024 * 1024)) <> " TiB"
  | size < 1024 * 1024 * 1024 * 1024 * 1024 * 1024 = show (size `div` (1024 * 1024 * 1024 * 1024 * 1024)) <> " PiB"
  | otherwise = show (size `div` (1024 * 1024 * 1024 * 1024 * 1024 * 1024)) <> " EiB"

formatUser :: Int -> Int -> String
formatUser gid uid = (show gid) <> "/" <> (show uid)

formatName :: DirEntry -> String
formatName entry = case entry.isDirectory of
  true -> entry.name <> "/"
  _ -> entry.name

formatDirEntry :: DirEntry -> FileInfo -> FilePermissions -> Array String
formatDirEntry entry stat permissions =
  [ mode
  , sizeAmount
  , sizeMeasure
  , user
  , name
  ]
  where
  name = formatName entry
  mode = formatPermissions permissions
  size = formatSize stat.size
  user = formatUser stat.gid stat.uid
  splitSize = split (Pattern " ") size
  sizeAmount = fromMaybe "N/A" $ splitSize !! 0
  sizeMeasure = fromMaybe "N/A" $ splitSize !! 1
