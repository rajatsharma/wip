let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.14.0-20210409/packages.dhall sha256:e81c2f2ce790c0e0d79869d22f7a37d16caeb5bd81cfda71d46c58f6199fd33f

in upstream with common-utils = {
  dependencies = [ "easy-ffi", "effect", "node-fs", "prelude", "node-process" ],
  repo = "https://github.com/rajatsharma/purescript-common-utils.git",
  version = "f9f3c5ee07a055602225fee99d0c4522e5c74cf7"
}
