{-# LANGUAGE OverloadedStrings #-}

module Wip.Rust where

import Data.String (IsString (fromString))
import System.Process (callProcess)

run :: String -> IO ()
run name = do
  callProcess "cargo" ["init", fromString name]
