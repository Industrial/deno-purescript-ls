module Deno.WebAPI where

import Data.Maybe (Maybe)

-- TODO: How do I use Deno's Object Oriented API and extend EventEmitter here?
type AbortSignal = {
  aborted :: Maybe Boolean,
  reason :: Maybe String
}