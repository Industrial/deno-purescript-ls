module Format where

import Prelude

import Data.String (joinWith)
import Permissions (FilePermissions)

-- | Converts an octal integer to a Unix file permission string.
formatPermissions :: FilePermissions -> String
formatPermissions permissions = joinWith "" $ map permissionChar permissions
  where
    permissionChar :: Array Boolean -> String
    permissionChar [false, false, false] = "---"
    permissionChar [false, false, true ] = "--x"
    permissionChar [false, true,  false] = "-w-"
    permissionChar [false, true,  true ] = "-wx"
    permissionChar [true,  false, false] = "r--"
    permissionChar [true,  false, true ] = "r-x"
    permissionChar [true,  true,  false] = "rw-"
    permissionChar [true,  true,  true ] = "rwx"
    permissionChar _                     = "???"

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
