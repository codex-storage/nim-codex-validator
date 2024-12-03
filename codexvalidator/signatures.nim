import pkg/constantine/ethereum_bls_signatures
import pkg/constantine/csprngs/sysrand

export Signature

type
  Identity* = SecretKey
  Identifier* = PublicKey

proc random*(_: type Identity, identity: var Identity) =
  var randomness: array[32, byte]
  var done = false
  while not done:
    doAssert sysrand(randomness)
    done = deserialize_seckey(identity, randomness) == cttCodecScalar_Success
  setZero(randomness)

func identifier*(identity: Identity): Identifier =
  derive_pubkey(result, identity)

func sign*(identity: Identity, message: openArray[byte]): Signature =
  sign(result, identity, message)

func verify*(signature: Signature, identifier: Identifier, message: openArray[byte]): bool =
  verify(identifier, message, signature) == cttEthBls_Success

func `==`*(a, b: Identifier): bool =
  pubkeys_are_equal(a, b)

func `==`*(a, b: Signature): bool =
  signatures_are_equal(a, b)
