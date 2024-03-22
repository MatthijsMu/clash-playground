module Clash.Playground.FIR 
    ( topEntity 
    ) where


dotp as bs = sum $ zipWith (*) as bs

fir coeffs x_t = y_t
  where 
    y_t = dotp coeffs xs
    xs = window x_t


topEntity
  :: Clock System
  -> Reset System
  -> Enable System
  -> Signal System (Signed 16)
  -> Signal System (Signed 16)
topEntity = exposeClockResetEnable (fir (0 :> 1 :> 2 :> 3 :> Nil))