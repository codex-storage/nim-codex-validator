import ../basics
import ../hashing
import ./blck
import ./blockid
import ./serialization

func hash*(b: Block): Hash =
  without var hash =? blck.hash(b):
    hash = Hash.hash(b.toBytes())
    b.hash = hash
  hash

func id*(b: Block): BlockId =
  BlockId.init(
    b.author,
    b.round,
    hash(b)
  )
