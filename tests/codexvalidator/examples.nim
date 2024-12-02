import std/random
import codexvalidator/basics
import codexvalidator/transaction

proc example*[T: SomeInteger](_: type T): T =
  rand(T)

proc example*(_: type UInt256): UInt256 =
  UInt256.fromBytesBE(array[32, byte].example)

proc example*[T, length](_: type array[length, T]): array[length, T] =
  for i in result.low..result.high:
    result[i] = T.example

proc example*[T](_: type seq[T], length = 0..10): seq[T] =
  let len = rand(length)
  newSeqWith(len, T.example)

proc example*(_: type SlotId): SlotId =
  SlotId(array[32, byte].example)

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

proc example*(_: type Transaction): Transaction =
  let kind = [TransactionKind.storageProof, TransactionKind.missingProof].sample
  let slotId = SlotId.example
  let period = Period.example
  let inputs = seq[UInt256].example
  case kind
  of TransactionKind.missingProof:
    Transaction.missingProof(slotId, period, inputs)
  of TransactionKind.storageProof:
    let proof = Groth16Proof.example
    Transaction.storageProof(slotId, period, inputs, proof)
