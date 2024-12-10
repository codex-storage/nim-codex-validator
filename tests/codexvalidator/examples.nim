import std/random
import codexvalidator/hashing
import codexvalidator/transaction
import codexvalidator/signatures
import codexvalidator/blocks
import ./basics

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

proc example*(_: type Transaction): Transaction =
  let kind = [TransactionKind.storageProof, TransactionKind.missingProof].sample
  let requestId = StorageRequestId.example
  let slotIndex = uint32.example
  let period = Period.example
  let merkleRoot = array[32, byte].example
  let challenge = array[32, byte].example
  case kind
  of TransactionKind.missingProof:
    Transaction.missingProof(
      requestId,
      slotIndex,
      period,
      merkleRoot,
      challenge
    )
  of TransactionKind.storageProof:
    let proof = Groth16Proof.example
    Transaction.storageProof(
      requestId,
      slotIndex,
      period,
      merkleRoot,
      challenge,
      proof
    )

proc example*(_: type Identity): Identity =
  Identity.random(result)

proc example*(_: type CommitteeMember): CommitteeMember =
  CommitteeMember(uint32.example.int)

proc example*(_: type Hash): Hash =
  Hash.hash(seq[byte].example)

proc example*(_: type BlockId): BlockId =
  BlockId.init(CommitteeMember.example, uint64.example, Hash.example)

proc example*(_: type Block): Block =
  Block(
    author: CommitteeMember.example,
    round: uint64.example,
    parents: seq[BlockId].example,
    transactions: seq[Transaction].example
  )
