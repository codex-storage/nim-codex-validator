import std/unittest
import codexvalidator/basics
import codexvalidator/transaction
import ../examples

suite "Transaction":

  test "a transaction can contain a storage proof":
    let requestId = StorageRequestId.example
    let slotIndex = uint32.example
    let period = Period.example
    let merkleRoot = UInt256.example
    let challenge = UInt256.example
    let proof = Groth16Proof.example
    let transaction = Transaction.storageProof(
      requestId, slotIndex, period, merkleRoot, challenge, proof
    )
    check transaction.requestId == requestId
    check transaction.slotIndex == slotIndex
    check transaction.period == period
    check transaction.merkleRoot == merkleRoot
    check transaction.challenge == challenge
    check transaction.proof == proof

  test "a transaction can indicate a missing storage proof":
    let requestId = StorageRequestId.example
    let slotIndex = uint32.example
    let period = Period.example
    let merkleRoot = UInt256.example
    let challenge = UInt256.example
    let transaction = Transaction.missingProof(
      requestId, slotIndex, period, merkleRoot, challenge
    )
    check transaction.requestId == requestId
    check transaction.slotIndex == slotIndex
    check transaction.period == period
    check transaction.merkleRoot == merkleRoot
    check transaction.challenge == challenge

  test "transactions have a fixed version":
    let transaction = Transaction.example
    check transaction.version == TransactionVersion.version0
