import pkg/protobuf_serialization

export protobuf_serialization

type
  TransactionMessage* {.proto3.} = object
    version* {.fieldNumber: 1, pint.}: uint32
    kind* {.fieldNumber: 2, pint.}: uint32
    requestId* {.fieldNumber: 3.}: seq[byte]
    slotIndex* {.fieldNumber: 4, pint.}: uint32
    period* {.fieldNumber: 5, pint.}: uint64
    merkleRoot* {.fieldNumber: 6.}: seq[byte]
    challenge* {.fieldNumber: 7.}: seq[byte]
    proof* {.fieldNumber: 8.}: Groth16ProofMessage
  Groth16ProofMessage* {.proto3.} = object
    a* {.fieldNumber: 1.}: G1PointMessage
    b* {.fieldNumber: 2.}: G2PointMessage
    c* {.fieldNumber: 3.}: G1PointMessage
  G1PointMessage* {.proto3.} = object
    x* {.fieldNumber: 1.}: seq[byte]
    y* {.fieldNumber: 2.}: seq[byte]
  G2PointMessage* {.proto3.} = object
    x* {.fieldNumber: 1.}: Fp2ElementMessage
    y* {.fieldNumber: 2.}: Fp2ElementMessage
  Fp2ElementMessage* {.proto3.} = object
    real* {.fieldNumber: 1.}: seq[byte]
    imag* {.fieldNumber: 2.}: seq[byte]

