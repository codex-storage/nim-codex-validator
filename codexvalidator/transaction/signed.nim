import ../signatures
import ./transaction
import ./serialization

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
  let signature = identity.sign(transaction.toBytes())
  SignedTransaction.init(transaction, identity.identifier, signature)

func transaction*(signed: SignedTransaction): Transaction =
  signed.transaction

func signer*(signed: SignedTransaction): Identifier =
  signed.signer

func signature*(signed: SignedTransaction): Signature =
  signed.signature

func verifySignature*(signed: SignedTransaction): bool =
  signed.signer.verify(signed.transaction.toBytes(), signed.signature)
