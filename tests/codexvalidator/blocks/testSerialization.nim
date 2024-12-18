import ../basics
import codexvalidator/blocks
import codexvalidator/blocks/serialization
import codexvalidator/transaction
import codexvalidator/transaction/serialization
import codexvalidator/hashing
import codexvalidator/signatures

suite "Block serialization":

  test "serializes a block id with protobuf":
    let id = BlockId.example
    let serialized = id.toBytes()
    let protobuf = ProtoBuf.decode(serialized, BlockIdMessage)
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

  test "serializes a signed block with protobuf":
    let blck = Block.example
    let identity = Identity.example
    let signed = Signed.sign(identity, blck)
    let serialized = signed.toBytes()
    let protobuf = Protobuf.decode(serialized, SignedBlockMessage)
    check protobuf.blck == BlockMessage.init(blck)
    check protobuf.signer == signed.signer.toBytes()
    check protobuf.signature == signed.signature.toBytes()

  test "deserializes a signed block":
    let signed = Signed[Block].example
    let serialized = signed.toBytes()
    let deserialized = Signed[Block].fromBytes(serialized)
    check deserialized == success signed

  test "deserialization fails when protobuf encoding is invalid":
    let invalid = seq[byte].example
    let deserialized = Signed[Block].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "Invalid wire type"

  test "deserialization fails when signer is invalid":
    let signed = Signed[Block].example
    var message = SignedBlockMessage.init(signed)
    message.signer &= 42'u8
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Block].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "invalid identifier"

  test "deserialization fails when signature is invalid":
    let signed = Signed[Block].example
    var message = SignedBlockMessage.init(signed)
    message.signature &= 42'u8
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Block].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "invalid signature"

  test "deserialization fails when parent block id is invalid":
    let signed = Signed[Block].example
    var message = SignedBlockMessage.init(signed)
    let hash = array[32, byte].example
    message.blck.parents &= BlockIdMessage(hash: @hash & 42'u8)
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Block].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "expected hash of 32 bytes, but got: 33"

  test "deserialization fails when transaction is invalid":
    let signed = Signed[Block].example
    var message = SignedBlockMessage.init(signed)
    var transaction = TransactionMessage.init(Transaction.example)
    transaction.version = 42'u8
    message.blck.transactions &= transaction
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Block].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "unsupported transaction version: 42"
