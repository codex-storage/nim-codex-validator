import ../basics
import ../hashing
import ./transaction
import ./serialization

export hashing.toBytes

func hash*(tx: Transaction): Hash =
  without var hash =? transaction.hash(tx):
    hash = Hash.hash(tx.toBytes())
    tx.hash = hash
  hash
