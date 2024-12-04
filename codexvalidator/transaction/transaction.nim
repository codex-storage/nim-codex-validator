import ../basics
import ./storagerequest
import ./period
import ./groth16

export storagerequest
export period
export groth16

type
  TransactionVersion* {.pure.} = enum
    version0
  TransactionKind* {.pure.} = enum
    storageProof
    missingProof
  Transaction* = object
    requestId: StorageRequestId
    slotIndex: uint32
    period: Period
    merkleRoot: UInt256
    challenge: UInt256
    case kind: TransactionKind
    of storageProof:
      proof: Groth16Proof
    of missingProof:
      discard

func storageProof*(
  _: type Transaction,
  requestId: StorageRequestId,
  slotIndex: uint32,
  period: Period,
  merkleRoot: UInt256,
  challenge: UInt256,
  proof: Groth16Proof
): Transaction =
  Transaction(
    kind: TransactionKind.storageProof,
    requestId: requestId,
    period: period,
    slotIndex: slotIndex,
    merkleRoot: merkleRoot,
    challenge: challenge,
    proof: proof
  )

func missingProof*(
  _: type Transaction,
  requestId: StorageRequestId,
  slotIndex: uint32,
  period: Period,
  merkleRoot: UInt256,
  challenge: UInt256,
): Transaction =
  Transaction(
    kind: TransactionKind.missingProof,
    requestId: requestId,
    slotIndex: slotIndex,
    period: period,
    merkleRoot: merkleRoot,
    challenge: challenge
  )

func version*(transaction: Transaction): TransactionVersion =
  TransactionVersion.version0

func kind*(transaction: Transaction): TransactionKind =
  transaction.kind

func requestId*(transaction: Transaction): StorageRequestId =
  transaction.requestId

func slotIndex*(transaction: Transaction): uint32 =
  transaction.slotIndex

func period*(transaction: Transaction): Period =
  transaction.period

func merkleRoot*(transaction: Transaction): UInt256 =
  transaction.merkleRoot

func challenge*(transaction: Transaction): UInt256 =
  transaction.challenge

func proof*(transaction: Transaction): Groth16Proof =
  transaction.proof

func `==`*(a, b: Transaction): bool =
  if a.kind != b.kind:
    return false
  if a.requestId != b.requestId:
    return false
  if a.slotIndex != b.slotIndex:
    return false
  if a.period != b.period:
    return false
  if a.merkleRoot != b.merkleRoot:
    return false
  if a.challenge != b.challenge:
    return false
  case a.kind
  of TransactionKind.storageProof:
    a.proof == b.proof
  of TransactionKind.missingProof:
    true
