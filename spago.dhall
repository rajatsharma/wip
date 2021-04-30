{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "wingman"
, dependencies =
  [ "common-utils"
  , "prelude"
  , "lists"
  , "node-buffer"
  , "console"
  , "effect"
  , "node-fs"
  , "node-path"
  , "node-process"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
