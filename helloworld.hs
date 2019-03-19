import Data.Char

hardcorefy x = map toUpper x

main = do
  putStrLn "Input training type (press q to quit)"
  trainingtype <- getLine
  if trainingtype == "q"
    then return ()
    else do
        let hctt = hardcorefy trainingtype
        putStrLn ("Registered training type: " ++ hctt)
        main
