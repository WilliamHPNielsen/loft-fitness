module SessionTypes
  ( Session(..)
  , TrainingSet(..)
  , addSet
  ) where

import Data.Time

data TrainingSet = TrainingSet { weight :: Float,
                                 reps :: Int}
                   deriving (Show, Read)

data Session = Session { time :: ZonedTime
                       , kind :: String
                       , sets :: [TrainingSet]}
               deriving (Show, Read)

addSet :: Session -> TrainingSet -> Session
addSet ses set =
  Session { time = t
          , kind = k
          , sets = s
          }
  where
    t = time ses
    k = kind ses
    s = (sets ses ) ++ [set]
    
