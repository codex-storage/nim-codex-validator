import ../basics
import codexvalidator/transaction

suite "Transaction":

  test "a transaction can contain a storage proof":
    let proofInput = StorageProofInput.example
    let proof = Groth16Proof.example
    let transaction = Transaction.storageProof(proofInput, proof)
    check transaction.proofInput == proofInput
    check transaction.proof == proof

  test "a transaction can indicate a missing storage proof":
    let proofInput = StorageProofInput.example
    let transaction = Transaction.missingProof(proofInput)
    check transaction.proofInput == proofInput

  test "transactions have a fixed version":
    let transaction = Transaction.example
    check transaction.version == TransactionVersion.version0
