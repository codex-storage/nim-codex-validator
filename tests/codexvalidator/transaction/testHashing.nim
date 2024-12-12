import ../basics
import codexvalidator/transaction
import codexvalidator/hashing

suite "Transaction hashing":

  test "transactions have a hash derived from the serialized bytes":
    let transaction = Transaction.example
    check transaction.hash == Hash.hash(transaction.toBytes())
