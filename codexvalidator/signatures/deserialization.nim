import pkg/blscurve
import ../basics
import ./identity
import ./signing

func fromBytes*(_: type Identifier, bytes: openArray[byte]): ?!Identifier =
  var identifier: Identifier
  if blscurve.fromBytes(identifier, bytes):
    success identifier
  else:
    failure "invalid identifier"

func fromBytes*(_: type Signature, bytes: openArray[byte]): ?!Signature =
  var signature: Signature
  if blscurve.fromBytes(signature, bytes):
    success signature
  else:
    failure "invalid signature"
