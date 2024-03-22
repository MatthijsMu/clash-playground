module Clash.Playground.TopEntity (topEntity) where

import Clash.Explicit.Prelude
import Clash.Annotations.TH

import qualified Data.List as L

-- A resettable counter. The initial count is undefined and requires a reset
-- System is a built-in Domain type
topEntity
  :: "clk25" ::: Clock System
  -> "resetCounter" ::: Signal System Bool
  -> "counter" ::: Signal System (Signed 4)
topEntity sysClk resetCounter = count
  where
    count = delay sysClk enableGen 0 (mux resetCounter 0 countNext)
    countNext = liftA2 (+) count $ pure 1

makeTopEntity 'topEntity


-- We can specify inputs as a list and then use the `fromList` function to turn
-- it into a signal
inputs :: [Bool]
inputs = [False, False, False, False, True, False, False, False, False, False, True, False]

-- clockGen generates an arbitrary clock for us. This can only be used during test
counter :: Signal System (Signed 4)
counter = topEntity clockGen (fromList inputs)

-- Turn the output signal into a list so you can more easily inspect it.
-- Note that if we sample more than the inputs we get an error
counterList :: [Signed 4]
counterList = sampleN (L.length inputs + 1) counter
