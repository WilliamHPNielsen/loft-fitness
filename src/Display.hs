module Display
  ( displaySession  
  , prettifySession
  ) where

import SessionTypes
import LoadSessions
import System.IO
import Data.List
import Data.Time


displaySession :: Session -> IO ()
displaySession ses =
  do
    putStrLn "Yup, that's a session"

numberOfSets :: Session -> Int
numberOfSets ses = length $ sets ses

cellBuilder :: String -> Int -> String -> String
cellBuilder separator max_size mssg =
  separator ++ padding ++ mssg ++ " "
  where padding = concat (take (1 + max_size - length mssg) $ repeat " ")

lineBuilder :: [String] -> Int -> String -> String
lineBuilder mssgs max_size separator =
  concat $ map (cellBuilder "|" max_size) $ mssgs

showWeight :: Weight -> String
showWeight BodyWeight = "bw"
showWeight (TrainingWeight a) = show a

prettifySession :: Session -> String
prettifySession ses = concat $ intersperse "\n" [a, b, c, d]
  where a = kind ses
        b = concat $ replicate (length a) "-"
        ws = map showWeight $ extractFromSets weight ses
        rs = map show $ extractFromSets reps ses
        ms = maximum [maximum . map length $ ws, maximum. map length $ rs]
        c = lineBuilder ws ms "|"
        d = lineBuilder rs ms "|"
