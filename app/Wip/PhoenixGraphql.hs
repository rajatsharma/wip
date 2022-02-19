{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Wip.PhoenixGraphql where

import Data.FileEmbed (embedStringFile)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import System.Directory (getCurrentDirectory, setCurrentDirectory)
import System.Process (callCommand)
import Text.Casing (fromWords, toQuietSnake)
import Prelude hiding ((<>), (>))

(~>) :: String -> String -> T.Text -> T.Text
(~>) a b = T.replace (T.pack a) (T.pack b)

replaceStrInFile :: FilePath -> String -> String -> IO ()
replaceStrInFile fileName needle replacement = T.readFile fileName >>= \txt -> T.writeFile fileName (needle ~> replacement $ txt)

replaceMarker :: String
replaceMarker = "  defp deps do\n    ["

(<>) :: T.Text -> T.Text -> T.Text
(<>) = T.append

run :: String -> IO ()
run name = do
  let setName = "$name$" ~> name
  print "Welcome to Wingman, I'll transfer this task to mix because it knows better"
  callCommand $ "echo 'y' | mix phx.new " ++ name ++ " --no-html --no-assets --no-gettext --no-mailer"
  print "Welcome again, mix is done, I'll take it from here"
  let dbNix = setName $ T.pack ($(embedStringFile "res/postgres.nix.template") :: String)
  cwd <- getCurrentDirectory
  setCurrentDirectory $ cwd ++ "/" ++ name
  T.writeFile "shell.nix" dbNix
  T.writeFile ".envrc" "use nix"
  callCommand "rm -rf test"
  callCommand $ "rm -rf lib/" ++ name ++ "_web/controllers/"
  replaceStrInFile "mix.exs" replaceMarker $ replaceMarker ++ "{:absinthe, \"~> 1.6\"},{:absinthe_plug, \"~> 1.5\"},{:absinthe_gen, \"~> 0.2\"},{:credo, \"~> 1.6\", only: [:dev, :test], runtime: false},"
  callCommand "mix deps.get"
  callCommand "mix format"
  callCommand "mix credo gen.config"
  callCommand "direnv allow"
  callCommand "git init"
