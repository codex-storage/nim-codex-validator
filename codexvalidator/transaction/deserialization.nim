import ../basics
import ../signatures
import ./transaction
import ./groth16
import ./serialization

func fromBytes(
  _: type array[32, byte],
  bytes: openArray[byte]
): ?!array[32, byte] =
  if bytes.len != 32:
    failure "expected 32 bytes but got: " & $bytes.len
  else:
    var bytes32: array[32, byte]
    bytes32[0..<32] = bytes[0..<32]
    success bytes32

func fromBytes(
  _: type StorageRequestId,
  bytes: openArray[byte]
): ?!StorageRequestId =
  success StorageRequestId(? array[32, byte].fromBytes(bytes))

func init(_: type Groth16Proof, message: Groth16ProofMessage): Groth16Proof =
  Groth16Proof.init(
    G1Point.init(
      UInt256.fromBytesBE(message.a.x),
      UInt256.fromBytesBE(message.a.y)
    ),
    G2Point.init(
      Fp2Element.init(
        UInt256.fromBytesBE(message.b.x.real),
        UInt256.fromBytesBE(message.b.x.imag)
      ),
      Fp2Element.init(
        UInt256.fromBytesBE(message.b.y.real),
        UInt256.fromBytesBE(message.b.y.imag)
      )
    ),
    G1Point.init(
      UInt256.fromBytesBE(message.c.x),
      UInt256.fromBytesBE(message.c.y)
    )
  )

func init(_: type Transaction, message: TransactionMessage): ?!Transaction =
  if message.version != TransactionVersion.version0.uint32:
    return failure "unsupported transaction version: " & $message.version
  let requestId = ? StorageRequestId.fromBytes(message.requestId)
  let slotIndex = message.slotIndex
  let period = Period(message.period)
  let merkleRoot = ? array[32, byte].fromBytes(message.merkleRoot)
  let challenge = ? array[32, byte].fromBytes(message.challenge)
  case message.kind
  of TransactionKind.storageProof.uint32:
    success Transaction.storageProof(
      requestId,
      slotIndex,
      period,
      merkleRoot,
      challenge,
      Groth16Proof.init(message.proof)
    )
  of TransactionKind.missingProof.uint32:
    success Transaction.missingProof(
      requestId,
      message.slotIndex,
      period,
      merkleRoot,
      challenge,
    )
  else:
    failure "invalid transaction kind: " & $message.kind

func init(
  _: type Signed[Transaction],
  message: SignedTransactionMessage
): ?!Signed[Transaction] =
  success Signed[Transaction].init(
    ? Transaction.init(message.transaction),
    ? Identifier.fromBytes(message.signer),
    ? Signature.fromBytes(message.signature)
  )

func fromBytes*(
  _: type Signed[Transaction],
  bytes: openArray[byte]
): ?!Signed[Transaction] =
  let message = ? Protobuf.decode(bytes, SignedTransactionMessage).catch()
  Signed[Transaction].init(message)
