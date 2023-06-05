module Permissions where

import Prelude

import Data.Array (fromFoldable)
import Data.Int (fromStringAs, octal)
import Data.Int.Bits ((.&.))
import Data.Maybe (Maybe)
import Data.Traversable (sequence)
import Deno.FileSystem (FileInfo)

type FilePermissions = Array (Array Boolean)

stringAsOctalInt :: String -> Maybe Int
stringAsOctalInt = fromStringAs octal

getPermissions :: FileInfo -> Maybe FilePermissions
getPermissions fileInfo = do
  permissions' <- stringAsOctalInt "777"
  let permissions = fileInfo.mode .&. permissions'
      boolFromPermission 0 = false
      boolFromPermission _ = true

  userPerms <- sequence [
    stringAsOctalInt "400",
    stringAsOctalInt "200",
    stringAsOctalInt "100"
  ]
  groupPerms <- sequence [
    stringAsOctalInt "040",
    stringAsOctalInt "020",
    stringAsOctalInt "010"
  ]
  othersPerms <- sequence [
    stringAsOctalInt "004",
    stringAsOctalInt "002",
    stringAsOctalInt "001"
  ]

  let userArr = fromFoldable (map (\p -> boolFromPermission (permissions .&. p)) userPerms)
      groupArr = fromFoldable (map (\p -> boolFromPermission (permissions .&. p)) groupPerms)
      othersArr = fromFoldable (map (\p -> boolFromPermission (permissions .&. p)) othersPerms)

  pure [userArr, groupArr, othersArr]
