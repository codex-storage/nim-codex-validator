import ../basics
import ../hashing
import ./storagerequest
import ./period
import ./proofinput
import ./groth16

export storagerequest
export period
export proofinput
export groth16

type
  TransactionVersion* {.pure.} = enum
    version0
  TransactionKind* {.pure.} = enum
    storageProof
    missingProof
  Transaction* = ref object
    proofInput: StorageProofInput
    case kind: TransactionKind
    of storageProof:
      proof: Groth16Proof
    of missingProof:
      discard
    hash: ?Hash

func storageProof*(
  _: type Transaction,
  proofInput: StorageProofInput,
  proof: Groth16Proof
): Transaction =
  Transaction(
    kind: TransactionKind.storageProof,
    proofInput: proofInput,
    proof: proof
  )

func missingProof*(
  _: type Transaction,
  proofInput: StorageProofInput
): Transaction =
  Transaction(
    kind: TransactionKind.missingProof,
    proofInput: proofInput
  )

func version*(transaction: Transaction): TransactionVersion =
  TransactionVersion.version0

func kind*(transaction: Transaction): TransactionKind =
  transaction.kind

func proofInput*(transaction: Transaction): StorageProofInput =
  transaction.proofInput

func proof*(transaction: Transaction): Groth16Proof =
  transaction.proof

func `hash=`*(transaction: Transaction, hash: Hash) =
  transaction.hash = some hash

func hash*(transaction: Transaction): ?Hash =
  transaction.hash

func `==`*(a, b: Transaction): bool =
  if a.kind != b.kind:
    return false
  if a.proofInput != b.proofInput:
    return false
  case a.kind
  of TransactionKind.storageProof:
    a.proof == b.proof
  of TransactionKind.missingProof:
    true
