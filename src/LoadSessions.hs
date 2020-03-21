module LoadSessions
  ( readLogFile
  , readSession
  , extractFromSets
  , tryToReadLogFile
  , sessionStringValidator
  , SessionStringValidity (..)
  , validateLogFile
  ) where

import System.IO
import SessionTypes
import Text.Read
import Data.List

data SessionStringValidity = Valid | Invalid deriving (Show, Eq)

-- should there be some read maybe stuff here?
readSession :: String -> Session
readSession sesstr = read sesstr :: Session

readSessionMaybe :: String -> Maybe Session
readSessionMaybe sesstr = readMaybe sesstr :: Maybe Session

sessionStringValidator :: String -> SessionStringValidity
sessionStringValidator sesstring =
  let readses = readSessionMaybe sesstring in
    case readses of
      Nothing -> Invalid
      Just _ -> Valid

tryToReadLogFile :: FilePath -> IO [SessionStringValidity]
tryToReadLogFile filename = do
  contents <- readFile filename
  return $ fmap sessionStringValidator $ lines contents

validateLogFile :: FilePath -> IO ()
validateLogFile filename = do
  contents <- readFile filename
  let invalidlines = elemIndices Invalid $ (map sessionStringValidator $ lines contents)
  case invalidlines of
    [] -> putStrLn "Valid log file"
    _ -> putStrLn ("Invalid log file; problems on line(s) " ++ intercalate ", " (map (\i -> show (i + 1)) invalidlines))

readLogFile :: FilePath -> IO [Session]
readLogFile filename = do
  contents <- readFile filename
  return $ fmap readSession $ lines contents

extractFromSets :: ( TrainingSet -> a) -> Session -> [a]
extractFromSets property ses = map property $ sets ses

