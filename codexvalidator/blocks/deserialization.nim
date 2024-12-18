import ../basics
import ../signatures
import ../hashing
import ../transaction
import ../transaction/deserialization
import ./blck
import ./blockid
import ./serialization

func init*(
  _: type BlockId,
  message: BlockIdMessage
): ?!BlockId =
  success BlockId.init(
    CommitteeMember(message.author),
    message.round,
    ? Hash.fromBytes(message.hash)
  )

func init*(
  _: type Block,
  message: BlockMessage
): ?!Block =
  success Block(
    author: CommitteeMember(message.author),
    round: message.round,
    parents: message.parents.mapIt(? BlockId.init(it)),
    transactions: message.transactions.mapIt(? Signed[Transaction].init(it))
  )

func init*(
  _: type Signed[Block],
  message: SignedBlockMessage
): ?!Signed[Block] =
  success Signed[Block].init(
    ? Block.init(message.blck),
    ? Identifier.fromBytes(message.signer),
    ? Signature.fromBytes(message.signature)
  )

func fromBytes*(
  _: type Signed[Block],
  bytes: openArray[byte]
): ?!Signed[Block] =
  let message = ? Protobuf.decode(bytes, SignedBlockMessage).catch()
  Signed[Block].init(message)
