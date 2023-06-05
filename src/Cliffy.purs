module Cliffy where

import Data.Function.Uncurried (Fn4, runFn4)

foreign import cliffyTable :: Fn4 Int Int Boolean (Array (Array String)) String
table :: Int -> Int -> Boolean -> Array (Array String) -> String
table padding indent border input = runFn4 cliffyTable padding indent border input
