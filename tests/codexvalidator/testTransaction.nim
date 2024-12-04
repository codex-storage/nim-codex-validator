import std/unittest
import codexvalidator/basics
import codexvalidator/signatures
import codexvalidator/transaction
import ./examples

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

  test "transactions can be signed":
    let identity = Identity.example
    let transaction = Transaction.example
    let signed = identity.sign(transaction)
    check signed.transaction == transaction
    check signed.signer == identity.identifier
    check signed.signature == identity.sign(transaction.toBytes())

  test "transaction signature can be verified":
    let identity = Identity.example
    let transaction = Transaction.example
    let signed = identity.sign(transaction)
    check signed.verifySignature()
    let forger = Identity.example.identifier
    let forged = SignedTransaction.init(transaction, forger, signed.signature)
    check not forged.verifySignature()
