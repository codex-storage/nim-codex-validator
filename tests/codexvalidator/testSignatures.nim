import std/unittest
import pkg/constantine/ethereum_bls_signatures
import codexvalidator/signatures
import ./examples

suite "Signature scheme":

  test "uses BLS private key as validator identity":
    check signatures.Identity is ethereum_bls_signatures.SecretKey

  test "uses BLS public key as validator identifier":
    check signatures.Identifier is ethereum_bls_signatures.PublicKey

  test "uses BLS signatures":
    check signatures.Signature is ethereum_bls_signatures.Signature

  test "can create a new random identity":
    var identity1, identity2: Identity
    Identity.random(identity1)
    Identity.random(identity2)
    check identity1.identifier != identity2.identifier

  test "derives identifier (public key) from the identity (private key)":
    var identity: Identity
    Identity.random(identity)
    var publicKey: PublicKey
    derive_pubkey(publicKey, identity)
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
    check signature.verify(identity1.identifier, message)
    check not signature.verify(identity2.identifier, message)
