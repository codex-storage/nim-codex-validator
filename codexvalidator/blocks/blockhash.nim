import ../basics
import ./blck
import ./blockid
import ./serialization
import ../hashing

func id*(blck: Block): BlockId =
  without var hash =? blck.hash:
    hash = Hash.hash(blck.toBytes())
    blck.hash = some hash
  BlockId.init(
    blck.author,
    blck.round,
    hash
  )
