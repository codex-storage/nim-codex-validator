import pkg/protobuf_serialization
import ../basics
import ../signatures
import ./transaction

export protobuf_serialization

type
  TransactionMessage* {.proto3.} = object
    version* {.fieldNumber: 1, pint.}: uint32
    kind* {.fieldNumber: 2, pint.}: uint32
    proofInput* {.fieldNumber: 3.}: StorageProofInputMessage
    proof* {.fieldNumber: 4.}: Groth16ProofMessage
  StorageProofInputMessage* {.proto3.} = object
    requestId* {.fieldNumber: 1.}: seq[byte]
    slotIndex* {.fieldNumber: 2, pint.}: uint32
    period* {.fieldNumber: 3, pint.}: uint64
    merkleRoot* {.fieldNumber: 4.}: seq[byte]
    challenge* {.fieldNumber: 5.}: seq[byte]
  Groth16ProofMessage* {.proto3.} = object
    a* {.fieldNumber: 1.}: G1PointMessage
    b* {.fieldNumber: 2.}: G2PointMessage
    c* {.fieldNumber: 3.}: G1PointMessage
  G1PointMessage* {.proto3.} = object
    x* {.fieldNumber: 1.}: seq[byte]
    y* {.fieldNumber: 2.}: seq[byte]
  G2PointMessage* {.proto3.} = object
    x* {.fieldNumber: 1.}: Fp2ElementMessage
    y* {.fieldNumber: 2.}: Fp2ElementMessage
  Fp2ElementMessage* {.proto3.} = object
    real* {.fieldNumber: 1.}: seq[byte]
    imag* {.fieldNumber: 2.}: seq[byte]

func init(
  _: type StorageProofInputMessage,
  input: StorageProofInput
): StorageProofInputMessage =
  StorageProofInputMessage(
    requestId: @(array[32, byte](input.requestId)),
    slotIndex: input.slotIndex,
    period: input.period.uint64,
    merkleRoot: @(input.merkleRoot),
    challenge: @(input.challenge)
  )

func init*(_: type TransactionMessage, transaction: Transaction): TransactionMessage =
  var message = TransactionMessage(
    version: transaction.version.uint32,
    kind: transaction.kind.uint32,
    proofInput: StorageProofInputMessage.init(transaction.proofInput)
  )
  if transaction.kind == TransactionKind.storageProof:
    message.proof = Groth16ProofMessage(
      a: G1PointMessage(
        x: @(transaction.proof.a.x.toBytesBE()),
        y: @(transaction.proof.a.y.toBytesBE())
      ),
      b: G2PointMessage(
        x: Fp2ElementMessage(
          imag: @(transaction.proof.b.x.imag.toBytesBE()),
          real: @(transaction.proof.b.x.real.toBytesBE())
        ),
        y: Fp2ElementMessage(
          imag: @(transaction.proof.b.y.imag.toBytesBE()),
          real: @(transaction.proof.b.y.real.toBytesBE())
        )
      ),
      c: G1PointMessage(
        x: @(transaction.proof.c.x.toBytesBE()),
        y: @(transaction.proof.c.y.toBytesBE())
      )
    )
  message

func toBytes*(transaction: Transaction): seq[byte] =
  ProtoBuf.encode(TransactionMessage.init(transaction))

type SignedTransactionMessage* {.proto3.} = object
  transaction* {.fieldNumber: 1.}: TransactionMessage
  signer* {.fieldNumber: 2.}: seq[byte]
  signature* {.fieldNumber: 3.}: seq[byte]

func init*(
  _: type SignedTransactionMessage,
  signed: Signed[Transaction]
): SignedTransactionMessage =
  SignedTransactionMessage(
    transaction: TransactionMessage.init(signed.value),
    signer: signed.signer.toBytes(),
    signature: signed.signature.toBytes()
  )

func toBytes*(signed: Signed[Transaction]): seq[byte] =
  Protobuf.encode(SignedTransactionMessage.init(signed))
