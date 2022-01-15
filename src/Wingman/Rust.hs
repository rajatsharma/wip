{-# LANGUAGE OverloadedStrings #-}

module Wingman.Rust where

import Data.String (IsString (fromString))
import System.Process (createProcess, proc)

run :: String -> IO ()
run name = do
  let process = proc "cargo" ["init", fromString name]
  _ <- createProcess process
  pure ()
