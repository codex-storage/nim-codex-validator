import codexvalidator/hashing
import ./basics

export hashing.Hash

proc example*(_: type Hash): Hash =
  Hash.hash(seq[byte].example)
