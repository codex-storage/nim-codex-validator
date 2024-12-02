import std/unittest
import codexvalidator/basics
import codexvalidator/transaction
import ./examples

suite "Transaction":

  test "a transaction can contain a storage proof":
    let slotId = SlotId.example
    let period = Period.example
    let inputs = seq[UInt256].example
    let proof = Groth16Proof.example
    let transaction = Transaction.storageProof(slotId, period, inputs, proof)
    check transaction.proof == proof

  test "a transaction can indicate a missing storage proof":
    let slotId = SlotId.example
    let period = Period.example
    let inputs = seq[UInt256].example
    let transaction = Transaction.missingProof(slotId, period, inputs)
    check transaction.slotId == slotId
    check transaction.period == period
    check transaction.inputs == inputs

  test "transactions have a fixed version":
    let transaction = Transaction.example
    check transaction.version == TransactionVersion.version0
