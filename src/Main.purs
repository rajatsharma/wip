module Main where

import Prelude

import CommonUtils.Handlebars (compile)
import CommonUtils.Node.Process (argsList)
import Data.List (List(..), (:))
import Effect (Effect)
import Effect.Console (log)
import Node.Encoding as Encoding
import Node.FS.Sync as S
import Node.Globals (__dirname)
import Node.Path as Path
import Node.Process (exit)

-- Constants
templateDir :: String
templateDir = "templates"

logExit :: forall a. String -> Effect a
logExit logStr = do
  log logStr
  exit 1


type Args = { option:: Option, language:: Language, tertiary:: String, quaternary:: String  }

-- Types
data Option
  = License
  | Readme
  | Gitignore

data Language
  = Purescript
  | Scala
  | None

getLanguage :: String -> Effect Language
getLanguage "purs" = pure Purescript
getLanguage "purescript" = pure Purescript
getLanguage "scala" = pure Scala
getLanguage _ = do
  log "Illegal language passed, accepts one of purescript, purs or scala"
  exit 1

instance showOption :: Show Language where
  show Purescript = "purescript"
  show Scala = "scala"
  show None = ""

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
generateReadme :: Args -> Effect Unit
generateReadme args = do
  readmeTemplate <- readFile (path [ __dirname, templateDir, "readme." <> show args.language <> ".hbs" ])
  let
    compiler = makeCompilerWithVariables { name: args.tertiary, desc: args.quaternary }
  let
    readmeContents = compiler readmeTemplate
  writeFile (path [ "README.md" ]) readmeContents

generateLicense :: Args -> Effect Unit
generateLicense _ = do
  bin <- readFile (path [ __dirname, "COPYING" ])
  writeFile (path [ "COPYING" ]) bin

generateGitignore :: Args -> Effect Unit
generateGitignore args = do
  gitignore <- readFile (path [ __dirname, templateDir, "gitignore." <> show args.language <> ".hbs" ])
  writeFile (path [ ".gitignore" ]) gitignore

wingman :: forall a. Effect a
wingman = do
  log "Wingman\nOpen Source management utility"
  exit 0

argsInspector :: List String -> Effect Args
argsInspector ("gitignore" : Nil) = do
  logExit "Command gitignore requires one more argument language"

argsInspector ("gitignore" : lang : Nil) = do
  verifiedLanguage <- getLanguage lang
  pure { option: Gitignore, language: verifiedLanguage, tertiary: "", quaternary: "" }

argsInspector ("license" : Nil) = pure { option: License, language: None, tertiary: "", quaternary: "" }

argsInspector ("readme" : lang : name : desc : Nil) = do
  verifiedLanguage <- getLanguage lang
  pure { option: Readme, language: verifiedLanguage, tertiary: name, quaternary: desc }

argsInspector ("readme" : lang : name : Nil) = logExit "Project description cannot be empty"
argsInspector ("readme" : lang : Nil) = logExit "Project name and description cannot be empty"
argsInspector ("readme" : Nil) = logExit "readme requires three more args, language, name and description"
argsInspector null = wingman

-- Main
main :: Effect Unit
main = do
  args <- argsList
  verifiedArgs <- argsInspector args
  case verifiedArgs.option of
    Readme -> generateReadme verifiedArgs
    License -> generateLicense verifiedArgs
    Gitignore -> generateGitignore verifiedArgs
