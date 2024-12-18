import std/random
import codexvalidator/transaction
import ./basics

export transaction.Transaction

proc example*(_: type StorageRequestId): StorageRequestId =
  StorageRequestId(array[32, byte].example)

proc example*(_: type Period): Period =
  Period(uint64.example)

proc example*(_: type G1Point): G1Point =
  G1Point.init(UInt256.example, UInt256.example)

proc example*(_: type Fp2Element): Fp2Element =
  Fp2Element.init(UInt256.example, UInt256.example)

proc example*(_: type G2Point): G2Point =
  G2Point.init(
    Fp2Element.example,
    Fp2Element.example
  )

proc example*(_: type Groth16Proof): Groth16Proof =
  Groth16Proof.init(
    G1Point.example,
    G2Point.example,
    G1Point.example
  )

proc example*(_: type StorageProofInput): StorageProofInput =
  let requestId = StorageRequestId.example
  let slotIndex = uint32.example
  let period = Period.example
  let merkleRoot = array[32, byte].example
  let challenge = array[32, byte].example
  StorageProofInput.init(
    requestId,
    slotIndex,
    period,
    merkleRoot,
    challenge
  )

proc example*(_: type Transaction): Transaction =
  let kind = [TransactionKind.storageProof, TransactionKind.missingProof].sample
  let proofInput = StorageProofInput.example
  case kind
  of TransactionKind.missingProof:
    Transaction.missingProof(proofInput)
  of TransactionKind.storageProof:
    let proof = Groth16Proof.example
    Transaction.storageProof(proofInput, proof)
