{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Semigroup ((<>))
import Options.Applicative
import System.Environment
import qualified Wip.Go as Go
import qualified Wip.Haskell as Haskell
import qualified Wip.PhoenixGraphql as PhoenixGraphql
import qualified Wip.Rust as Rust

data Wip = Go String | Rust String | PhoenixGraphql String | Haskell String

createGo :: Parser Wip
createGo = Go <$> argument str idm

createRust :: Parser Wip
createRust = Rust <$> argument str idm

createPhoenixGraphql :: Parser Wip
createPhoenixGraphql = PhoenixGraphql <$> argument str idm

createHaskell :: Parser Wip
createHaskell = Haskell <$> argument str idm

wipParser :: Parser Wip
wipParser =
  subparser $
    command "go" (info createGo $ progDesc "Generate Go project")
      <> command "rust" (info createRust $ progDesc "Generate Rust project")
      <> command "haskell" (info createHaskell $ progDesc "Generate Haskell project")
      <> command "phoenix-graphql" (info createPhoenixGraphql $ progDesc "Generate Phoenix Graphql project")

runner :: Wip -> IO ()
runner (Go name) = Go.run name
runner (Rust name) = Rust.run name
runner (PhoenixGraphql name) = PhoenixGraphql.run name
runner (Haskell name) = Haskell.run name

shell :: IO ()
shell = runner =<< execParser opts
  where
    opts =
      info (wipParser <**> helper) $
        fullDesc
          <> progDesc "Enter Command to run, see available commands for command descriptions."
          <> header "WIP: Initialises Projects"

main :: IO ()
main = shell
