import std/random
import codexvalidator/basics

export basics.UInt256

proc example*[T: SomeInteger](_: type T): T =
  rand(T)

proc example*(_: type UInt256): UInt256 =
  UInt256.fromBytesBE(array[32, byte].example)

proc example*[T, length](_: type array[length, T]): array[length, T] =
  for i in result.low..result.high:
    result[i] = T.example

proc example*[T](_: type seq[T], length = 0..10): seq[T] =
  let len = rand(length)
  newSeqWith(len, T.example)

