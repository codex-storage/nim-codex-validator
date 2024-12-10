import ../basics
import codexvalidator/blocks
import codexvalidator/blocks/serialization
import codexvalidator/transaction/serialization
import codexvalidator/hashing

suite "Block serialization":

  test "serializes a block id with protobuf":
    let id = BlockId.example
    let serialized = id.toBytes()
    {.warning[Deprecated]: off.} # ignore warning in protobuf_serialization
    let protobuf = ProtoBuf.decode(serialized, BlockIdMessage)
    {.warning[Deprecated]: on.}
    check protobuf.author == id.author.uint32
    check protobuf.round == id.round
    check protobuf.hash == id.hash.toBytes()

  test "serializes a block with protobuf":
    let blck = Block.example
    let serialized = blck.toBytes()
    {.warning[Deprecated]: off.} # ignore warning in protobuf_serialization
    let protobuf = ProtoBuf.decode(serialized, BlockMessage)
    {.warning[Deprecated]: on.}
    check protobuf.author == blck.author.uint32
    check protobuf.round == blck.round
    check protobuf.parents == blck.parents.mapIt(BlockIdMessage.init(it))
    check protobuf.transactions == blck.transactions.mapIt(TransactionMessage.init(it))
