module Wingman.PhoenixGraphql where

import System.Directory (getCurrentDirectory)
import System.Process (callProcess)
import Text.Casing (fromWords, toQuietSnake)

run :: String -> IO ()
run name = do
  _ <- callProcess "mix" ["phx.new", name, "--no-html", "--no-assets", "--no-gettext", "--no-mailer"]
  cwd <- getCurrentDirectory
  let projectDir = cwd ++ "/" ++ name
  _ <- callProcess "rm" ["-rf", "test"]
  _ <- callProcess "rm" ["-rf", "lib/" ++ toQuietSnake (fromWords name) ++ "/controllers/"]
  pure ()
