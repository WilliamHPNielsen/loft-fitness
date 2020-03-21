module Display
  ( displaySession  
  , prettifySession
  , displayLogFile
  , displayOneKindFromLogfile
  ) where

import SessionTypes
import LoadSessions
import LogAggregators
import System.IO
import Data.List as List
import Data.Time
import Data.Map.Strict as Map


displaySession :: Session -> IO ()
displaySession ses =
  do
    putStrLn "Yup, that's a session"

numberOfSets :: Session -> Int
numberOfSets ses = length $ sets ses

cellBuilder :: String -> Int -> String -> String
cellBuilder separator max_size mssg =
  separator ++ padding ++ mssg ++ " "
  where padding = concat (List.take (1 + max_size - length mssg) $ repeat " ")

lineBuilder :: [String] -> Int -> String -> String
lineBuilder mssgs max_size separator =
  concat $ List.map (cellBuilder "|" max_size) $ mssgs

showWeight :: Weight -> String
showWeight BodyWeight = "bw"
showWeight (TrainingWeight a) = show a

prettifySession :: Session -> String
prettifySession ses = concat $ intersperse "\n" [a, b, c, d]
  where a = "\n" ++ kind ses
        b = concat $ replicate (length a) "-"
        ws = List.map showWeight $ extractFromSets weight ses
        rs = List.map show $ extractFromSets reps ses
        ms = maximum [maximum . List.map length $ ws, maximum . List.map length $ rs]
        c = lineBuilder ws ms "|"
        d = lineBuilder rs ms "|"

prettifySessionGroup' :: String -> [Session] -> [String]
prettifySessionGroup' date lses =
  [datehdr] ++ (List.map prettifySession lses)
  where datehdr = ">>>>>>>>" ++ date ++ "<<<<<<<<\n"

accum :: [String] -> String -> [Session] -> ([String], Maybe c)
accum a key lses =
  (a ++ [datehdr] ++ (List.map prettifySession $ reverse lses), Nothing)
  where datehdr = "\n>>>>>>>>" ++ key ++ "<<<<<<<<\n"

prettifySessionGroup :: Map.Map String [Session] -> [String]
prettifySessionGroup mses =
  fst $ Map.mapAccumWithKey accum [] mses

printStrings :: [String] -> IO ()
printStrings [] = return ()
printStrings (x:xs) = do
  putStrLn x
  printStrings xs

displayLogFile2 :: FilePath -> IO ()
displayLogFile2 path = do
  sessions <- readLogFile path
  let sessionstrings = List.map prettifySession sessions
  printStrings sessionstrings

-- WIP
displayLogFile :: FilePath -> IO ()
displayLogFile path = do
  groupedSessions <- fmap groupSessionsByDate $ readLogFile path
  let sessionStrings = prettifySessionGroup groupedSessions
  printStrings sessionStrings

displayOneKindFromLogfile :: FilePath -> String -> IO ()
displayOneKindFromLogfile path k = do
  sessions <- readLogFile path
  let groupedSessions = groupSessionsByDate . (getSessionsOfKind k) $ sessions
  let sessionStrings = prettifySessionGroup groupedSessions
  printStrings sessionStrings
  
