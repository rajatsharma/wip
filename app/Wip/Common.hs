module Wip.Common where

import qualified Data.Text as T
import qualified Data.Text.IO as T

(~>) :: String -> String -> T.Text -> T.Text
(~>) a b = T.replace (T.pack a) (T.pack b)

replaceStrInFile :: FilePath -> String -> String -> IO ()
replaceStrInFile fileName needle replacement = T.readFile fileName >>= \txt -> T.writeFile fileName (needle ~> replacement $ txt)
