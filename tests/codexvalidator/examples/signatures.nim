import codexvalidator/signatures

export signatures.Identity
export signatures.Identifier
export signatures.Signature
export signatures.Signed

proc example*(_: type Identity): Identity =
  Identity.random(result)

proc example*(_: type Identifier): Identifier =
  Identity.example.identifier

proc example*(_: type Signature): Signature =
  Identity.example.sign(seq[byte].example)

proc example*[T](_: type Signed[T]): Signed[T] =
  Signed.sign(Identity.example, T.example)
