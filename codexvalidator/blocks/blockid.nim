import pkg/mysticeti
import ../hashing

export mysticeti.init
export mysticeti.author
export mysticeti.round
export mysticeti.hash

type BlockId* = mysticeti.BlockId[hashing.Hash]
