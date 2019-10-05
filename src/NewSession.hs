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

getSet :: IO (Maybe TrainingSet)
getSet = do
  w <- getWeight
  case w of
    Right Stop -> return Nothing
    _ -> do
      r <- getReps
      case r of
        Right Stop -> return Nothing
        _ -> return $ Just (TrainingSet { weight = fromLeft 0 w, reps = fromLeft 0 r })

getSessionSets :: Session -> IO Session
getSessionSets ses = do
  putStrLn $ prettifySession ses
  set <- getSet
  case set of
    Nothing -> return ses
    _ -> do
      getSessionSets $ addSet ses (fromJust set)

makeSession :: String -> IO Session
makeSession kind = do
  time <- getZonedTime
  let ses = Session {time=time, kind=kind, sets=[]}
  return ses

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
  ses <- makeSession kind
  getSessionSets ses

{-

Maybe: we can map something over a list of IO actions?

StackOverflow: monads, sequence, example with [IO String] -> IO [String]
-}
