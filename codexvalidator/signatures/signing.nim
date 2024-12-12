import pkg/blscurve
import ../hashing
import ./identity

export blscurve.Signature
export blscurve.sign
export blscurve.verify

func sign*(identity: Identity, hash: Hash): Signature =
  blscurve.sign(identity, hash.toBytes())

func verify*(signature: Signature, identifier: Identifier, hash: Hash): bool =
  blscurve.verify(identifier, hash.toBytes(), signature)
