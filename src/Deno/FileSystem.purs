module Deno.FileSystem where

import Prelude

import Control.Promise (Promise, toAff)
import Data.Date (Date)
import Data.Function.Uncurried (Fn2, Fn3, runFn2, runFn3)
import Data.Maybe (Maybe)
import Deno.WebAPI (AbortSignal)
import Effect.Aff (Aff)
import Foreign (Foreign, unsafeToForeign)
import Web.URL (URL)

type DirEntry = {
  name :: String,
  isFile :: Boolean,
  isDirectory :: Boolean,
  isSymlink :: Boolean
}

type FileInfo = {
  isFile :: Boolean,
  isDirectory :: Boolean,
  isSymlink :: Boolean,
  size :: Int,
  mtime :: Date,
  atime :: Date,
  birthtime :: Date,
  dev :: Int,
  ino :: Int,
  mode :: Int,
  nlink :: Int,
  uid :: Int,
  gid :: Int,
  rdev :: Int,
  blcksize :: Int,
  blocks :: Int,
  isBlockDevice :: Boolean,
  isCharDevice :: Boolean,
  isFifo :: Boolean,
  isSocket :: Boolean
}

type FsEvent = {
  -- "any" | "access" | "create" | "modify" | "remove" | "other"
  kind :: String,
  paths :: Array String,
  flag :: Maybe FsEventsFlag
}

-- TODO: Can I type literal strings?
-- "rescan"
type FsEventsFlag = String

-- TODO: FsWatcher: An AsyncIterator object

type MakeTempOptions = {
  dir :: Maybe String,
  prefix :: Maybe String,
  suffix :: Maybe String
}

type MkDirOptions = {
  recursive :: Boolean,
  mode :: Number
}

type OpenOptions = {
  read :: Maybe Boolean,
  write :: Maybe Boolean,
  append :: Maybe Boolean,
  truncate :: Maybe Boolean,
  create :: Maybe Boolean,
  createNew :: Maybe Boolean,
  mode :: Maybe Number
}

type ReadFileOptions = {
  signal :: Maybe AbortSignal
}

type RemoveOptions = {
  recursive :: Maybe Boolean
}

type SymlinkOptions = {
  -- "file" | "dir"
  type :: String
}

type WriteFileOptions = {
  append :: Maybe Boolean,
  create :: Maybe Boolean,
  createNew :: Maybe Boolean,
  mode :: Maybe Number,
  signal :: Maybe AbortSignal
}

class URLOrString :: forall k. k -> Constraint
class URLOrString a
instance URLOrString URL
instance URLOrString String

foreign import chmod' :: Fn2 Foreign Number (Promise Unit)
chmod :: forall a. URLOrString a => a -> Number -> Aff Unit
chmod path = toAff <<< runFn2 chmod' (unsafeToForeign path)

foreign import chmodSync' :: Fn2 String Number Unit
chmodSync :: String -> Number -> Unit
chmodSync path mode = runFn2 chmodSync' path mode

foreign import chown' :: Fn3 String Number Number (Promise Unit)
chown :: String -> Number -> Number -> Aff Unit
chown path uid = toAff <<< runFn3 chown' path uid

foreign import chownSync' :: Fn3 String Number Number Unit
chownSync :: String -> Number -> Number -> Unit
chownSync path uid gid = runFn3 chownSync' path uid gid

foreign import readDirInt :: String -> Promise (Array DirEntry)
readDir :: String -> Aff (Array DirEntry)
readDir = toAff <<< readDirInt

foreign import statString :: String -> Promise (FileInfo)
stat :: String -> Aff (FileInfo)
stat = toAff <<< statString
