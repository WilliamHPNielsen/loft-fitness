import Data.Char
import Control.Monad
import NewSession

hardcorefy :: [Char] -> [Char]
hardcorefy x = map toUpper x

getLine' :: IO String
getLine' = do
  tt <- getLine
  return tt

main = do
  startNewSession
  putStrLn "Input training type (press Q to quit)"
  trainingtype <- getLine'
  when (not $ elem trainingtype ["q", "Q"]) $ do
    let hctt = hardcorefy trainingtype
    putStrLn ("Registered training type: " ++ hctt)
    main

