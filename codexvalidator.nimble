version = "0.1.0"
author = "Codex Validator contributors"
description = "Validation network for Codex"
license = "MIT"

# pinning non-versioned dependencies of dependencies
requires "stew#a6e198132097fb544d04959aeb3b839e1408f942"
requires "faststreams#cf8d4d22636b8e514caf17e49f9c786ac56b0e85"
requires "serialization#2086c99608b4bf472e1ef5fe063710f280243396"

# pinning non-versioned dependencies
requires "stint#ae665d6546c57b4acaf194e9a8e33ebb6aab5213"
requires "protobuf_serialization#5a31137a82c2b6a989c9ed979bb636c7a49f570e"
requires "blscurve#de2d3c79264bba18dbea469c8c5c4b3bb3c8bc55"

# versioned dependencies
requires "https://github.com/codex-storage/nim-mysticeti >= 0.1.0 & < 0.2.0"
requires "nimcrypto >= 0.6.2 & < 0.7.0"
