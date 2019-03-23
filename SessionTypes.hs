module SessionTypes
  (
    Session
  ) where

import Data.Time

data Session = Session { time :: ZonedTime
                       , kind :: String }
               deriving Show
