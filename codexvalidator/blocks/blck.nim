from pkg/mysticeti import CommitteeMember, `==`, `$`
import ../basics
import ../transaction
import ../hashing
import ../signatures
import ./blockid

export mysticeti.CommitteeMember
export mysticeti.`==`
export mysticeti.`$`

type Block* = ref object
  author*: CommitteeMember
  round*: uint64
  parents*: seq[BlockId]
  transactions*: seq[Signed[Transaction]]
  hash: ?Hash

func `hash=`*(blck: Block, hash: Hash) =
  blck.hash = some hash

func hash*(blck: Block): ?Hash =
  blck.hash
