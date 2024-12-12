import ../hashing
import ./identity
import ./signing

type Signed*[T] = object
  value: T
  signer: Identifier
  signature: Signature

func init*[T](
  _: type Signed[T],
  value: T,
  signer: Identifier,
  signature: Signature
): Signed[T] =
  Signed[T](
    value: value,
    signer: signer,
    signature: signature
  )

func sign*[T](_: type Signed, identity: Identity, value: T): Signed[T] =
  mixin hash
  let hash: Hash = value.hash
  let signature = identity.sign(hash.toBytes())
  Signed[T].init(value, identity.identifier, signature)

func value*[T](signed: Signed[T]): T =
  signed.value

func signer*(signed: Signed): Identifier =
  signed.signer

func signature*(signed: Signed): Signature =
  signed.signature

func verifySignature*(signed: Signed): bool =
  mixin hash
  let hash: Hash = signed.value.hash
  signed.signer.verify(hash.toBytes(), signed.signature)
