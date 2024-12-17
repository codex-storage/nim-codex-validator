import ../basics
import codexvalidator/transaction
import codexvalidator/transaction/serialization
import codexvalidator/signatures

suite "Transaction serialization":

  test "serializes a transaction with protobuf":
    let transaction = Transaction.example
    let serialized = transaction.toBytes()
    {.warning[Deprecated]: off.} # ignore warning in protobuf_serialization
    let protobuf = ProtoBuf.decode(serialized, TransactionMessage)
    {.warning[Deprecated]: on.}
    check protobuf.version == transaction.version.uint32
    check protobuf.kind == transaction.kind.uint32
    check protobuf.requestId == array[32, byte](transaction.requestId)
    check protobuf.slotIndex == transaction.slotIndex
    check protobuf.period == transaction.period.uint64
    check protobuf.merkleRoot == array[32, byte](transaction.merkleRoot)
    check protobuf.challenge == array[32, byte](transaction.challenge)

  test "serializes a storage proof with protobuf":
    let proof = Groth16Proof.example
    let transaction = Transaction.storageProof(
      StorageRequestId.example,
      uint32.example,
      Period.example,
      array[32, byte].example,
      array[32, byte].example,
      proof
    )
    let serialized = transaction.toBytes()
    let protobuf = ProtoBuf.decode(serialized, TransactionMessage)
    check protobuf.proof.a.x == transaction.proof.a.x.toBytesBE()
    check protobuf.proof.a.y == transaction.proof.a.y.toBytesBE()
    check protobuf.proof.b.x.real == transaction.proof.b.x.real.toBytesBE()
    check protobuf.proof.b.x.imag == transaction.proof.b.x.imag.toBytesBE()
    check protobuf.proof.b.y.real == transaction.proof.b.y.real.toBytesBE()
    check protobuf.proof.b.y.imag == transaction.proof.b.y.imag.toBytesBE()
    check protobuf.proof.c.x == transaction.proof.c.x.toBytesBE()
    check protobuf.proof.c.y == transaction.proof.c.y.toBytesBE()

  test "serializes a signed transaction with protobuf":
    let signed = Signed[Transaction].example
    let serialized = signed.toBytes()
    let protobuf = Protobuf.decode(serialized, SignedTransactionMessage)
    check protobuf.transaction == TransactionMessage.init(signed.value)
    check protobuf.signer == signed.signer.toBytes()
    check protobuf.signature == signed.signature.toBytes()

  test "deserializes a signed transaction":
    let signed = Signed[Transaction].example
    let serialized = signed.toBytes()
    let deserialized = Signed[Transaction].fromBytes(serialized)
    check deserialized == success signed

  test "deserialization fails when protobuf encoding is invalid":
    let invalid = seq[byte].example
    let deserialized = Signed[Transaction].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "Invalid wire type"

  test "deserialization fails when signer is invalid":
    let signed = Signed[Transaction].example
    var message = SignedTransactionMessage.init(signed)
    message.signer &= 42'u8
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Transaction].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "invalid identifier"

  test "deserialization fails when signature is invalid":
    let signed = Signed[Transaction].example
    var message = SignedTransactionMessage.init(signed)
    message.signature &= 42'u8
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Transaction].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "invalid signature"

  test "deserialization fails when transaction version is unsupported":
    let signed = Signed[Transaction].example
    var message = SignedTransactionMessage.init(signed)
    message.transaction.version = 42
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Transaction].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "unsupported transaction version: 42"

  test "deserialization fails when transaction kind is invalid":
    let signed = Signed[Transaction].example
    var message = SignedTransactionMessage.init(signed)
    message.transaction.kind = 42
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Transaction].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "invalid transaction kind: 42"

  test "deserialization fails when storage request id is invalid":
    let signed = Signed[Transaction].example
    var message = SignedTransactionMessage.init(signed)
    message.transaction.requestid &= 42'u8
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Transaction].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "expected 32 bytes but got: 33"

  test "deserialization fails when merkle root is invalid":
    let signed = Signed[Transaction].example
    var message = SignedTransactionMessage.init(signed)
    message.transaction.merkleRoot &= 42'u8
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Transaction].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "expected 32 bytes but got: 33"

  test "deserialization fails when challenge is invalid":
    let signed = Signed[Transaction].example
    var message = SignedTransactionMessage.init(signed)
    message.transaction.challenge &= 42'u8
    let invalid = Protobuf.encode(message)
    let deserialized = Signed[Transaction].fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "expected 32 bytes but got: 33"
