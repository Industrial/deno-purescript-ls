module Format where

import Prelude

import Data.String (joinWith)
import Permissions (FilePermissions)

-- | Converts an octal digit to its corresponding permission character.
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

-- | Converts an octal integer to a Unix file permission string.
formatPermissions :: FilePermissions -> String
formatPermissions permissions = joinWith "" $ map permissionChar permissions
