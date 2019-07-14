module LoadSessions (
  readLogFile,
  readSession,
  extractFromSets
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

extractFromSets :: ( TrainingSet -> a) -> Session -> [a]
extractFromSets property ses = map property $ sets ses

