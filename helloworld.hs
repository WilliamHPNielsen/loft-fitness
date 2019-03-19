import Data.Char

hardcorefy :: [Char] -> [Char]
hardcorefy x = map toUpper x

getLine' :: IO String
getLine' = do
  tt <- getLine
  return tt

main = do
  putStrLn "Input training type (press q to quit)"
  trainingtype <- getLine'
  if trainingtype == "q"
    then return ()
    else do
        let hctt = hardcorefy trainingtype
        putStrLn ("Registered training type: " ++ hctt)
        main
