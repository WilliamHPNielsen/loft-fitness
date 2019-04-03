module SessionTypes
  ( Session(..)
  , TrainingSet
  ) where

import Data.Time

data TrainingSet = TrainingSet { weight :: Float,
                                 reps :: Integer}
                   deriving (Show, Read)

data Session = Session { time :: ZonedTime
                       , kind :: String
                       , sets :: [TrainingSet]}
               deriving (Show, Read)
