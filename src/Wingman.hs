{-# LANGUAGE OverloadedStrings #-}

module Wingman (shell) where

import Data.Semigroup ((<>))
import qualified Wingman.Rust as Rust
import qualified Wingman.Go as Go
import Options.Applicative
import System.Environment

data Wingman = Go String | Rust String

createGo :: Parser Wingman
createGo = Go <$> argument str idm

createRust :: Parser Wingman
createRust = Rust <$> argument str idm

wingmanParser :: Parser Wingman
wingmanParser =
  subparser $
    command "go" (info createGo (progDesc "Generate Go project"))
      <> command "rust" (info createRust (progDesc "Generate Rust project"))

runner :: Wingman -> IO ()
runner (Go name) = Go.run name
runner (Rust name) = Rust.run name

shell :: IO ()
shell = runner =<< execParser opts
  where
    opts =
      info (wingmanParser <**> helper) $
        fullDesc
          <> progDesc "Enter Command to run, see available commands for command descriptions."
          <> header "Wingman - Initialise projects"
