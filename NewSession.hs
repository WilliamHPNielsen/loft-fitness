module NewSession
  (
    startNewSession
  ) where

import SessionTypes
import System.IO
import Data.Time
import Text.Read

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
  
getSet :: IO ()
getSet = do
  putStrLn "Gimme"
  val <- getIntMaybe
  case val of
    Just _ -> putStrLn "Thanks"
    Nothing -> getSet
