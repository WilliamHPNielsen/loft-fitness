module LoadSessions (
  readLogFile
  ) where

import System.IO
import SessionTypes


-- should there be some read maybe stuff here?
readSession :: String -> Session
readSession sesstr = read sesstr :: Session

readLogFile :: FilePath -> IO [Session]
readLogFile filename = do
  contents <- readFile filename
  return $ fmap readSession $ lines contents
  
