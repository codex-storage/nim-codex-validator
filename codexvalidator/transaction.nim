import ./basics
import ./transaction/slotid
import ./transaction/period
import ./transaction/groth16

export slotid
export period
export groth16

type
  TransactionVersion* {.pure.} = enum
    version0
  TransactionKind* {.pure.} = enum
    storageProof
    missingProof
  Transaction* = object
    slotId: SlotId
    period: Period
    inputs: seq[UInt256]
    case kind: TransactionKind
    of storageProof:
      proof: Groth16Proof
    of missingProof:
      discard

proc storageProof*(
  _: type Transaction,
  slotId: SlotId,
  period: Period,
  inputs: seq[UInt256],
  proof: Groth16Proof
): Transaction =
  Transaction(
    kind: TransactionKind.storageProof,
    slotId: slotId,
    period: period,
    inputs: inputs,
    proof: proof
  )

proc missingProof*(
  _: type Transaction,
  slotId: SlotId,
  period: Period,
  inputs: seq[UInt256],
): Transaction =
  Transaction(
    kind: TransactionKind.missingProof,
    slotId: slotId,
    period: period,
    inputs: inputs
  )

func version*(transaction: Transaction): TransactionVersion =
  TransactionVersion.version0

func slotId*(transaction: Transaction): SlotId =
  transaction.slotId

func period*(transaction: Transaction): Period =
  transaction.period

func inputs*(transaction: Transaction): seq[UInt256] =
  transaction.inputs

func proof*(transaction: Transaction): Groth16Proof =
  transaction.proof
