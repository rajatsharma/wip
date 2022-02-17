{-# LANGUAGE OverloadedStrings #-}

module Wip.Go where

import Data.String (IsString (fromString))
import System.Directory (getCurrentDirectory)
import System.Process (CreateProcess (cwd), createProcess, proc)

run :: String -> IO ()
run name = do
  let process = proc "mkdir" [fromString name]
  _ <- createProcess process
  cwd <- getCurrentDirectory
  let projectDir = cwd ++ "/" ++ name
  _ <- createProcess (proc "go" ["mod", "init", "github.com/rajatsharma/" ++ name]) {cwd = Just projectDir}
  pure ()
