import ./basics
import ./transaction
import ./serialization/protobuf

func toBytes*(transaction: Transaction): seq[byte] =
  var message = TransactionMessage(
    version: transaction.version.uint32,
    kind: transaction.kind.uint32,
    requestId: @(array[32, byte](transaction.requestId)),
    slotIndex: transaction.slotIndex,
    period: transaction.period.uint64,
    merkleRoot: @(transaction.merkleRoot.toBytesBE()), # TODO: should this not be array[32, byte]?
    challenge: @(transaction.challenge.toBytesBE()) # TODO ^^^
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
  ProtoBuf.encode(message)
