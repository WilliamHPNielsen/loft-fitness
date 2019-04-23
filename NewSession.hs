module NewSession
  (
    startNewSession
  ) where

import SessionTypes
import System.IO
import Data.Time
import Text.Read

data QueryAction = Stop | Continue deriving (Show, Eq)

makeSession :: String -> IO Session
makeSession kind = do
  time <- getZonedTime
  let ses = Session {time=time, kind=kind, sets=[]}
  return ses

writeSession :: Session -> IO ()
writeSession ses = do
  appendFile "sessions.log" (show ses ++ "\n")

startNewSession :: IO ()
startNewSession = do
  putStrLn "New session, no depression"
  putStrLn "Enter session type"
  kind <- getLine
  ses <- makeSession kind
  writeSession ses
  print ses
  return ()

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
  userinput <- getLine
  let maybeint = (readMaybe userinput :: Maybe Int)
  case maybeint of
    Just a -> return $ Left a
    Nothing -> return $ Right (makeQueryAction userinput)
  
getSet :: IO ()
getSet = do
  putStrLn "Enter reps (press q to finish)"
  val <- getIntOrQueryAction
  case val of
    Left _ -> do
      putStrLn "An Integer!"
      getSet
    Right Stop -> putStrLn "Okay, we stop"
    Right Continue -> getSet
