module LogAggregators
  ( groupSessionsByDate
  ) where

import SessionTypes
import Data.Time
import Data.Map.Strict as Map


-- use a Strict Map (a Dict) as a grouping for sessions!
-- the groupSessionsByDate will just fill that Dict
-- by folding

-- Our fixed time string
zonedTimeToString :: ZonedTime -> String
zonedTimeToString zt = formatTime defaultTimeLocale "%Y-%m-%d" zt

-- surely there's an out-of-the-box function for this?
sessionInserter :: Session -> Map.Map String [Session] -> Map.Map String [Session]
sessionInserter s m = 
  let sdate = zonedTimeToString $ time s
      slist = Map.lookup sdate m
  in
    case slist of
      Nothing -> Map.insert sdate [s] m
      Just _ -> Map.update (\l -> Just (l ++ [s])) sdate m

groupSessionsByDate :: [Session] -> Map.Map String [Session]
groupSessionsByDate lses = Prelude.foldr sessionInserter Map.empty lses











