import ../basics
import codexvalidator/signatures
import codexvalidator/transaction
import codexvalidator/hashing

suite "Transaction signing":

  test "transactions can be signed":
    let identity = Identity.example
    let transaction = Transaction.example
    let signed = identity.sign(transaction)
    check signed.transaction == transaction
    check signed.signer == identity.identifier
    check signed.signature == identity.sign(transaction.hash.toBytes())

  test "transaction signature can be verified":
    let identity = Identity.example
    let transaction = Transaction.example
    let signed = identity.sign(transaction)
    check signed.verifySignature()
    let forger = Identity.example.identifier
    let forged = SignedTransaction.init(transaction, forger, signed.signature)
    check not forged.verifySignature()
