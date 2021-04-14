{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "wingman"
, dependencies =
  [ "console"
  , "effect"
  , "handlebars"
  , "node-args"
  , "node-fs"
  , "node-path"
  , "node-process"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
