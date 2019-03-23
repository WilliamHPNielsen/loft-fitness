module NewSession
  ( Session
  , startNewSession
  ) where

import Data.Time
import System.IO

data Session = Session { time :: ZonedTime
                       , kind :: String }
               deriving Show

makeSession :: String -> IO Session
makeSession kind = do
  time <- getZonedTime
  let ses = Session {time=time, kind=kind}
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
  
