import codexvalidator/blocks
import ./hashing
import ./signatures
import ./transaction

proc example*(_: type CommitteeMember): CommitteeMember =
  CommitteeMember(uint32.example.int)

proc example*(_: type BlockId): BlockId =
  BlockId.init(CommitteeMember.example, uint64.example, Hash.example)

proc example*(_: type Block): Block =
  Block(
    author: CommitteeMember.example,
    round: uint64.example,
    parents: seq[BlockId].example,
    transactions: seq[Signed[Transaction]].example
  )
