import ./storagerequest
import ./period

type
  StorageProofInput* = object
    requestId: StorageRequestId
    slotIndex: uint32
    period: Period
    merkleRoot: array[32, byte]
    challenge: array[32, byte]

func init*(
  _: type StorageProofInput,
  requestId: StorageRequestId,
  slotIndex: uint32,
  period: Period,
  merkleRoot: array[32, byte],
  challenge: array[32, byte]
): StorageProofInput =
  StorageProofInput(
    requestId: requestId,
    slotIndex: slotIndex,
    period: period,
    merkleRoot: merkleRoot,
    challenge: challenge
  )

func requestId*(input: StorageProofInput): StorageRequestId =
  input.requestId

func slotIndex*(input: StorageProofInput): uint32 =
  input.slotIndex

func period*(input: StorageProofInput): Period =
  input.period

func merkleRoot*(input: StorageProofInput): array[32, byte] =
  input.merkleRoot

func challenge*(input: StorageProofInput): array[32, byte] =
  input.challenge

