let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0-20210409/packages.dhall sha256:e81c2f2ce790c0e0d79869d22f7a37d16caeb5bd81cfda71d46c58f6199fd33f

in upstream with node-args = {
  dependencies = [ "lists" ],
  repo = "https://github.com/rajatsharma/purescript-node-args.git",
  version = "9cbe6b96595134b5971928975a63f3d2d746aae0"
}

with handlebars = {
  dependencies = [] : List Text,
  repo = "https://github.com/rajatsharma/purescript-handlebars",
  version = "4a723ec91f761610463f79c446570bdab03977af"
}
