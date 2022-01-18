{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Semigroup ((<>))
import Options.Applicative
import System.Environment
import qualified Wingman.Go as Go
import qualified Wingman.PhoenixGraphql as PhoenixGraphql
import qualified Wingman.Rust as Rust

data Wingman = Go String | Rust String | PhoenixGraphql String

createGo :: Parser Wingman
createGo = Go <$> argument str idm

createRust :: Parser Wingman
createRust = Rust <$> argument str idm

createPhoenixGraphql :: Parser Wingman
createPhoenixGraphql = PhoenixGraphql <$> argument str idm

wingmanParser :: Parser Wingman
wingmanParser =
  subparser $
    command "go" (info createGo $ progDesc "Generate Go project")
      <> command "rust" (info createRust $ progDesc "Generate Rust project")
      <> command "phoenix-graphql" (info createPhoenixGraphql $ progDesc "Generate Phoenix Graphql project")

runner :: Wingman -> IO ()
runner (Go name) = Go.run name
runner (Rust name) = Rust.run name
runner (PhoenixGraphql name) = PhoenixGraphql.run name

shell :: IO ()
shell = runner =<< execParser opts
  where
    opts =
      info (wingmanParser <**> helper) $
        fullDesc
          <> progDesc "Enter Command to run, see available commands for command descriptions."
          <> header "Wingman - Initialise projects"

main :: IO ()
main = shell
