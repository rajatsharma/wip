module Wingman.PhoenixGraphql where

import System.Directory (getCurrentDirectory)
import System.Process (callCommand, callProcess)
import Text.Casing (fromWords, toQuietSnake)

run :: String -> IO ()
run name = do
  print "Welcome to Wingman, I'll transfer this task to mix because it knows better"
  _ <- callCommand $ "echo 'y' | mix phx.new " ++ name ++ " --no-html --no-assets --no-gettext --no-mailer"
  print "Welcome again, mix is done, I'll take it from here"
  cwd <- getCurrentDirectory
  let projectDir = cwd ++ "/" ++ name ++ "/"
  _ <- callProcess "rm" ["-rf", projectDir ++ "test"]
  _ <- callProcess "rm" ["-rf", projectDir ++ "lib/" ++ toQuietSnake (fromWords name) ++ "/controllers/"]
  pure ()
