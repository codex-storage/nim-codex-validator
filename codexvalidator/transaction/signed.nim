import ../signatures
import ./transaction
import ./hashing

type SignedTransaction* = object
  transaction: Transaction
  signer: Identifier
  signature: Signature

func init*(
  _: type SignedTransaction,
  transaction: Transaction,
  signer: Identifier,
  signature: Signature
): SignedTransaction =
  SignedTransaction(
    transaction: transaction,
    signer: signer,
    signature: signature
  )

func sign*(identity: Identity, transaction: Transaction): SignedTransaction =
  let hash = hashing.hash(transaction)
  let signature = identity.sign(hash.toBytes())
  SignedTransaction.init(transaction, identity.identifier, signature)

func transaction*(signed: SignedTransaction): Transaction =
  signed.transaction

func signer*(signed: SignedTransaction): Identifier =
  signed.signer

func signature*(signed: SignedTransaction): Signature =
  signed.signature

func verifySignature*(signed: SignedTransaction): bool =
  let hash = hashing.hash(signed.transaction)
  signed.signer.verify(hash.toBytes(), signed.signature)
