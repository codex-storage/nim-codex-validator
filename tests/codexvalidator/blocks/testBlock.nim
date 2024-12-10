import ../basics
import codexvalidator/blocks
import codexvalidator/hashing

suite "Blocks":

  test "have a correct block id":
    let blck = Block.example
    check blck.id.author == blck.author
    check blck.id.round == blck.round
    check blck.id.hash == Hash.hash(blck.toBytes())

