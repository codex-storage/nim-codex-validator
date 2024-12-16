import pkg/blscurve
import ./identity
import ./signing

func toBytes*(identifier: Identifier): seq[byte] =
  var bytes: array[48, byte]
  doAssert blscurve.serialize(bytes, identifier)
  @bytes

func toBytes*(signature: Signature): seq[byte] =
  var bytes: array[96, byte]
  doAssert blscurve.serialize(bytes, signature)
  @bytes
