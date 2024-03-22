module Clash.Playground.MAC 
  ( topEntity
  , testBench
  ) where

import Clash.Prelude.Mealy
import Clash.Prelude
import Clash.Explicit.Testbench
import Control.Monad.State.Strict 

ma :: Num a => a -> (a, a) -> a
ma acc (x, y) = acc + x * y

{-
  Mealy machine: is a *sequential* circuit 
  determined by a combinatorial function

  f :: s -> i -> (s, o)

  where 
    - s is a state type (representing the internal state)
    - i is the input type.
    - o is the output type.

  Clash can turn f into an actual synchronous sequential logical 
  circuit with the function `mealy`.

  mealy
  :: (HiddenClockResetEnable dom, NFDataX s)
  => (s -> i -> (s,o))
  -> s
  -> (Signal dom i -> Signal dom o)
-}

{-
  All (synchronous) sequential circuits work on values of type Signal dom a
  where a is the type and dom is a domain type (which determines,
  among other things, the powerup values of registers and other stateful circuits).
-}

-- | define mac with a mealy function
macT :: Num a => a -> (a,a) -> (a,a)
macT acc (x, y) = (acc', o)
  where
    acc' = ma acc (x, y)
    o    = acc

mac 
  :: Num a
  => (HiddenClockResetEnable dom, NFDataX a)
  => (Signal dom (a,a) -> Signal dom a)

mac inp = mealy macT 0 inp


-- | define mac by mapping * over signal.
--   we can do this since Signal a is a Num instance if a
--   is a Num instance.
macN 
  :: Num a
  => (HiddenClockResetEnable dom, NFDataX a)
  => (Signal dom (a,a) -> Signal dom a)
macN xy = acc
    where
        (x, y) = unbundle xy
        acc = register 0 (acc + x * y)


-- | define mac in applicative style,
--  by mapping the combinatorial ma function 
--  over the register acc
macA 
  :: Num a
  => (HiddenClockResetEnable dom, NFDataX a)
  => (Signal dom (a,a) -> Signal dom a)
macA xy = acc
    where
        acc = register 0 acc'
        acc' = ma <$> acc <*> xy

macTS 
  :: (MonadState b m, Num b) 
  => (b, b) -> m b
macTS (x,y) = do
    acc <- get
    put (acc + x * y)
    return acc

macS xy = mealyS macTS 0 xy


{-
  The topEntity function is the starting point for the Clash compiler to transform your circuit description into a VHDL netlist. It must meet the following restrictions in order for the Clash compiler to work:

    It must be completely monomorphic
    It must be completely first-order
    Although not strictly necessary, it is recommended to expose Hidden clock and reset arguments, as it makes user-controlled name assignment in the generated HDL easier to do.

-}

topEntity
  :: Clock System
  -> Reset System
  -> Enable System
  -> Signal System (Signed 9, Signed 9)
  -> Signal System (Signed 9)
topEntity = exposeClockResetEnable mac

testBench :: Signal System Bool
testBench = done
  where
    testInput = stimuliGenerator clk rst $((listToVecTH [(1,1) :: (Signed 9,Signed 9),(2,2), (3,3), (4,4)]))
    expectOutput = outputVerifier' clk rst $(listToVecTH [0 :: Signed 9,1,5,14,14,14,14 ])
    done = expectOutput (topEntity clk rst en testInput)
    en = enableGen
    clk = tbSystemClockGen (not <$> done)
    rst = systemResetGen

