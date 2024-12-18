import pkg/nimcrypto/sha2
import pkg/nimcrypto/hash
import ./basics

export hash.`$`

type Hash* = MDigest[256]

func hash*(_: type Hash, bytes: openArray[byte]): Hash =
  var context: sha256
  context.init()
  context.update(bytes)
  result = context.finish()
  context.clear()

func toBytes*(hash: Hash): seq[byte] =
  @(hash.data)

func fromBytes*(_: type Hash, bytes: openArray[byte]): ?!Hash =
  if bytes.len != 32:
    return failure "expected hash of 32 bytes, but got: " & $bytes.len
  var data: array[32, byte]
  data[0..<32] = bytes[0..<32]
  success Hash(data: data)
