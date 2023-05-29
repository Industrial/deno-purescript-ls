module Deno
  (
    args
  ) where

import Effect (Effect)

foreign import args :: Effect (Array String)
