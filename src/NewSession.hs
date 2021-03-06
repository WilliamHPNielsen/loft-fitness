module NewSession
  (
    startNewSession
  , getSession
  , writeSession
  ) where

import Display
import SessionTypes
import System.IO
import Data.Time
import Data.Either
import Data.Maybe
import Text.Read

data QueryAction = Stop | Continue deriving (Show, Eq)
{-

idea: wouldn't smth like
data QueryBob a = Stop | Continue | Value a
be better? We'd save one Either
EDIT: yes, it seems like we have Either a QueryACtion everywhere,
better give that a name


-}


getIntMaybe :: IO (Maybe Int)
getIntMaybe = do
  userinput <- getLine
  return (readMaybe userinput :: Maybe Int)

makeQueryAction :: String -> QueryAction
makeQueryAction x
  | x == "Q"  = Stop
  | x == "q"  = Stop
  | otherwise = Continue

getIntOrQueryAction :: IO (Either Int QueryAction)
getIntOrQueryAction = do
  fmap parseInputInt getLine

readMaybeInt :: String -> Maybe Int
readMaybeInt = readMaybe 

readMaybeFloat :: String -> Maybe Float
readMaybeFloat = readMaybe

parseInput :: Read a => (String -> Maybe a) -> String ->  Either a QueryAction
parseInput reader inp =
  case (reader inp) of
    Nothing -> Right (makeQueryAction inp)
    Just a -> Left a

parseInputInt = parseInput readMaybeInt

parseInputFloat = parseInput readMaybeFloat

getSomeNum :: Num a => (String -> Either a QueryAction) -> String -> IO (Either a QueryAction)
getSomeNum parser msg = do
  putStrLn msg
  reps <- fmap parser getLine
  case reps of
    Right Continue -> getSomeNum parser msg
    Right Stop -> return (Right Stop)
    _ -> return reps

getWeight :: IO (Either Float QueryAction)
getWeight = getSomeNum parseInputFloat "Enter weight"

getReps :: IO (Either Int QueryAction)
getReps = getSomeNum parseInputInt "Enter reps"

getTrainingWeightSet :: IO (Maybe TrainingSet)
getTrainingWeightSet = do
  w <- getWeight
  case w of
    Right Stop -> return Nothing
    _ -> do
      r <- getReps
      case r of
        Right Stop -> return Nothing
        _ -> return $ Just (TrainingSet { weight = TrainingWeight $ fromLeft 0 w,
                                          reps = fromLeft 0 r })

getBodyWeightSet :: IO (Maybe TrainingSet)
getBodyWeightSet = do
  r <- getReps
  case r of
    Right Stop -> return Nothing
    _ -> return $ Just (TrainingSet { weight = BodyWeight,
                                      reps = fromLeft 0 r})

getSet :: Weight -> IO (Maybe TrainingSet)
getSet w = do
  case w of
    BodyWeight -> getBodyWeightSet
    TrainingWeight _ -> getTrainingWeightSet

getSessionSets :: Session -> Weight -> IO Session
getSessionSets ses w = do
  putStrLn $ prettifySession ses
  set <- getSet w
  case set of
    Nothing -> return ses
    _ -> do
      getSessionSets (addSet ses (fromJust set)) w

makeSession :: String -> IO Session
makeSession kind = do
  time <- getZonedTime
  let ses = Session {time=time, kind=kind, sets=[]}
  return ses

getWeightType :: IO (Weight)
getWeightType = do
  putStrLn "Enter weight type (b/B for bodyweight)"
  wt <- getLine
  case wt of
    "b" -> return BodyWeight
    "B" -> return BodyWeight
    _ -> return (TrainingWeight 0)

writeSession :: Session -> IO ()
writeSession ses = do
  appendFile "sessions.log" (show ses ++ "\n")

startNewSession :: IO Session
startNewSession = do
  putStrLn "New session, no depression"
  putStrLn "Enter session type"
  kind <- getLine
  ses <- makeSession kind
  writeSession ses
  print ses
  return ses

getSession :: IO Session
getSession = do
  putStrLn "Enter session type"
  kind <- getLine
  wt <- getWeightType
  ses <- makeSession kind
  getSessionSets ses wt

{-

Maybe: we can map something over a list of IO actions?

StackOverflow: monads, sequence, example with [IO String] -> IO [String]
-}
