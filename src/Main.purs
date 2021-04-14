module Main where

import Prelude
import Data.List ((!!))
import Data.Maybe (fromMaybe, Maybe(..))
import Effect (Effect)
import Effect.Console (log)
import Node.Args (args)
import Node.Encoding as Encoding
import Node.FS.Sync as S
import Node.Globals (__dirname)
import Node.Path as Path
import Node.Process (exit)
import Text.Handlebars (compile)

-- Constants
templateDir :: String
templateDir = "templates"

-- Types
data Option
  = License
  | Readme
  | Gitignore
  | None

option :: String -> Option
option "license" = License

option "gitignore" = Gitignore

option "readme" = Readme

option _ = None

data Language
  = Purescript
  | Scala

language :: String -> Effect Language
language "purs" = pure Purescript

language "purescript" = pure Purescript

language "scala" = pure Scala

language _ = do
  log "Illegal language passed, accepts one of purescript, purs or scala"
  exit 1

getLanguageStr :: Language -> String
getLanguageStr Purescript = "purescript"

getLanguageStr Scala = "scala"

-- Helpers
path :: Array Path.FilePath -> Path.FilePath
path = Path.concat

writeFile :: String -> String -> Effect Unit
writeFile = S.writeTextFile Encoding.UTF8

readFile :: String -> Effect String
readFile = S.readTextFile Encoding.UTF8

makeCompilerWithVariables :: forall a. a -> String -> String
makeCompilerWithVariables variables template = compile template variables

-- Commands
generateReadme :: Language -> Maybe String -> Maybe String -> Effect Unit
generateReadme lang Nothing Nothing = do
  log "Project name and description cannot be empty."
  exit 1

generateReadme lang _ Nothing = do
  log "Project description cannot be empty."
  exit 1

generateReadme lang Nothing _ = do
  log "Project name cannot be empty."
  exit 1

generateReadme lang (Just name) (Just desc) = do
  readmeTemplate <- readFile (path [ __dirname, templateDir, "readme." <> getLanguageStr lang <> ".hbs" ])
  let
    compiler = makeCompilerWithVariables { name: name, desc: desc }
  let
    readmeContents = compiler readmeTemplate
  writeFile (path [ "README.md" ]) readmeContents

generateLicense :: Effect Unit
generateLicense = do
  bin <- readFile (path [ __dirname, "COPYING" ])
  writeFile (path [ "COPYING" ]) bin

generateGitignore :: Language -> Effect Unit
generateGitignore lang = do
  gitignore <- readFile (path [ __dirname, templateDir, "gitignore." <> getLanguageStr lang <> ".hbs" ])
  writeFile (path [ ".gitignore" ]) gitignore

wingman :: Effect Unit
wingman =
  log
    """Wingman
Open Source management utility
"""

-- Main
main :: Effect Unit
main = do
  let
    command = fromMaybe "" $ args !! 0
  let
    languageArg = fromMaybe "" $ args !! 1
  lang <- language languageArg
  case option command of
    Readme -> generateReadme lang (args !! 2) (args !! 3)
    License -> generateLicense
    Gitignore -> generateGitignore lang
    _ -> wingman
