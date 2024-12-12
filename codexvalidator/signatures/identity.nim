import pkg/blscurve
import pkg/nimcrypto

type
  Identity* = SecretKey
  Identifier* = PublicKey

proc random*(_: type Identity, identity: var Identity) =
  var randomness: array[32, byte]
  var done = false
  while not done:
    doAssert randomBytes(randomness) == randomness.len
    done = fromBytes(identity, randomness)
  burnMem(randomness)

func identifier*(identity: Identity): Identifier =
  doAssert publicFromSecret(result, identity)
