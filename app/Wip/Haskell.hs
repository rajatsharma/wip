{-# LANGUAGE OverloadedStrings #-}

module Wip.Haskell where

import Data.String (IsString (fromString))
import Soothsayer ((***))
import System.Process (callCommand)

run :: String -> IO ()
run name = do
  callCommand $ "stack new {0} -p \"author-email:rajat@github.com\" -p \"author-name:Rajat Sharma\" -p \"github-username:rajatsharma\"" *** [name]
