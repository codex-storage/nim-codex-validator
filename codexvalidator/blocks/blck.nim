import pkg/mysticeti
import ../transaction
import ./blockid

export mysticeti.CommitteeMember

type Block* = ref object
  author*: CommitteeMember
  round*: uint64
  parents*: seq[blockid.BlockId]
  transactions*: seq[Transaction]
  id*: blockid.BlockId
