import Data.Char
import Control.Monad
import SessionTypes
import NewSession

main :: IO ()
main = do
  ses <- getSession
  writeSession ses
  return ()
