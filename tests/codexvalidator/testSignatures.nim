import ./basics
import pkg/blscurve
import codexvalidator/hashing
import codexvalidator/signatures

suite "Signature scheme":

  test "uses BLS private key as validator identity":
    check signatures.Identity is blscurve.SecretKey

  test "uses BLS public key as validator identifier":
    check signatures.Identifier is blscurve.PublicKey

  test "uses BLS signatures":
    check signatures.Signature is blscurve.Signature

  test "can create a new random identity":
    var identity1, identity2: Identity
    Identity.random(identity1)
    Identity.random(identity2)
    check identity1.identifier != identity2.identifier

  test "derives identifier (public key) from the identity (private key)":
    var identity: Identity
    Identity.random(identity)
    var publicKey: PublicKey
    check publicFromSecret(publicKey, identity)
    check identity.identifier == publicKey

  test "identity can sign messages":
    var identity: Identity
    Identity.random(identity)
    let message = seq[byte].example
    let signature1, signature2 = identity.sign(message)
    check signature1 == signature2

  test "signatures can be verified":
    var identity1, identity2: Identity
    Identity.random(identity1)
    Identity.random(identity2)
    let message = seq[byte].example
    let signature = identity1.sign(message)
    check identity1.identifier.verify(message, signature)
    check not identity2.identifier.verify(message, signature)

  test "identity can sign and verify hashes":
    var identity: Identity
    Identity.random(identity)
    let hash = Hash.example
    let signature = identity.sign(hash)
    check signature.verify(identity.identifier, hash)

  test "identifier can be serialized and deserialized":
    let identifier = Identifier.example
    let serialized = identifier.toBytes()
    check Identifier.fromBytes(serialized) == success identifier

  test "identifier deserialization fails when wrong number of bytes":
    let identifier = Identifier.example
    let serialized = identifier.toBytes()
    let invalid = serialized & 42'u8
    check isFailure Identifier.fromBytes(invalid)

  test "signature can be serialized and deserialized":
    let signature = Signature.example
    let serialized = signature.toBytes()
    check Signature.fromBytes(serialized) == success signature

  test "signature deserialization fails when wrong number of bytes":
    let signature = Signature.example
    let serialized = signature.toBytes()
    let invalid = serialized & 42'u8
    check isFailure Signature.fromBytes(invalid)
