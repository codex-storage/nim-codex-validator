import ./basics
import codexvalidator/hashing

suite "Hashing":

  test "serializes a hash to bytes":
    let hash = Hash.example
    let serialized = hash.toBytes()
    check serialized == hash.data

  test "deserializes a hash from bytes":
    let hash = Hash.example
    let serialized = hash.toBytes()
    let deserialized = Hash.fromBytes(serialized)
    check deserialized == success hash

  test "deserialization fails when number of bytes is not 32":
    let hash = Hash.example
    let serialized = hash.toBytes()
    let invalid = serialized & 42'u8
    let deserialized = Hash.fromBytes(invalid)
    check deserialized.isFailure
    check deserialized.errorOption.?msg == some "expected hash of 32 bytes, but got: 33"
