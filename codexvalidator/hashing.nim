import pkg/nimcrypto/sha2
import pkg/nimcrypto/hash

type Hash* = MDigest[256]

func hash*(_: type Hash, bytes: openArray[byte]): Hash =
  var context: sha256
  context.init()
  context.update(bytes)
  result = context.finish()
  context.clear()

func toBytes*(hash: Hash): auto =
  hash.data
