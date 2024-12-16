import pkg/protobuf_serialization
import ../basics
import ../hashing
import ../transaction
import ../transaction/serialization
import ../signatures
import ./blockid
import ./blck

export protobuf_serialization

type BlockIdMessage* {.proto3.} = object
  author* {.fieldNumber: 1, pint.}: uint32
  round* {.fieldNumber: 2, pint.}: uint64
  hash* {.fieldNumber: 3.}: seq[byte]

func init*(_: type BlockIdMessage, id: BlockId): BlockIdMessage =
  BlockIdMessage(
    author: id.author.uint32,
    round: id.round,
    hash: @(id.hash.toBytes())
  )

func toBytes*(id: BlockId): seq[byte] =
  Protobuf.encode(BlockIdMessage.init(id))

type BlockMessage* {.proto3.} = object
  author* {.fieldNumber: 1, pint.}: uint32
  round* {.fieldNumber: 2, pint.}: uint64
  parents* {.fieldNumber: 3.}: seq[BlockIdMessage]
  transactions* {.fieldNumber: 4.}: seq[TransactionMessage]

func init*(_: type BlockMessage, blck: Block): BlockMessage =
  BlockMessage(
    author: blck.author.uint32,
    round: blck.round,
    parents: blck.parents.mapIt(BlockIdMessage.init(it)),
    transactions: blck.transactions.mapIt(TransactionMessage.init(it))
  )

func toBytes*(blck: Block): seq[byte] =
  Protobuf.encode(BlockMessage.init(blck))

type SignedBlockMessage* {.proto3.} = object
  blck* {.fieldNumber: 1.}: BlockMessage
  signer* {.fieldNumber: 2.}: seq[byte]
  signature* {.fieldNumber: 3.}: seq[byte]

func init*(
  _: type SignedBlockMessage,
  signed: Signed[Block]
): SignedBlockMessage =
  SignedBlockMessage(
    blck: BlockMessage.init(signed.value),
    signer: signed.signer.toBytes(),
    signature: signed.signature.toBytes()
  )

func toBytes*(signed: Signed[Block]): seq[byte] =
  Protobuf.encode(SignedBlockMessage.init(signed))
