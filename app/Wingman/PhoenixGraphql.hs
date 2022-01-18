{-# LANGUAGE OverloadedStrings #-}

module Wingman.PhoenixGraphql where

import qualified Data.Text as T
import qualified Data.Text.IO as T
import System.Directory (getCurrentDirectory, setCurrentDirectory)
import System.Process (callCommand, callProcess)
import Text.Casing (fromWords, toQuietSnake)
import Prelude hiding ((<>))

replaceStrInFile :: FilePath -> T.Text -> T.Text -> IO ()
replaceStrInFile fileName needle replacement = T.readFile fileName >>= \txt -> T.writeFile fileName (T.replace needle replacement txt)

replaceMarker :: T.Text
replaceMarker = "  defp deps do\n    ["

(<>) :: T.Text -> T.Text -> T.Text
(<>) = T.append

run :: String -> IO ()
run name = do
  print "Welcome to Wingman, I'll transfer this task to mix because it knows better"
  _ <- callCommand $ "echo 'y' | mix phx.new " ++ name ++ " --no-html --no-assets --no-gettext --no-mailer"
  print "Welcome again, mix is done, I'll take it from here"
  cwd <- getCurrentDirectory
  setCurrentDirectory $ cwd ++ "/" ++ name
  callCommand "rm -rf test"
  callCommand $ "rm -rf lib/" ++ name ++ "_web/controllers/"
  replaceStrInFile "mix.exs" replaceMarker $ replaceMarker <> T.pack "{:absinthe, \"~> 1.6\"},{:absinthe_plug, \"~> 1.5\"},{:absinthe_gen, \"~> 0.2\"},{:credo, \"~> 1.6\", only: [:dev, :test], runtime: false},"
  callCommand "mix deps.get"
  callCommand "mix format"
  callCommand "mix credo gen.config"
  pure ()
