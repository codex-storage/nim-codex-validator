import ../basics

type
  Groth16Proof* = object
    a: G1Point
    b: G2Point
    c: G1Point
  G1Point* = object
    x: UInt256
    y: UInt256
  Fp2Element* = object
    ## A field element F_{p^2} encoded as `real + i * imag`
    real: UInt256
    imag: UInt256
  G2Point* = object
    x: Fp2Element
    y: Fp2Element

func init*(_: type Groth16Proof, a: G1Point, b: G2Point, c: G1Point): Groth16Proof =
  Groth16Proof(a: a, b: b, c: c)

func a*(proof: Groth16Proof): G1Point =
  proof.a

func b*(proof: Groth16Proof): G2Point =
  proof.b

func c*(proof: Groth16Proof): G1Point =
  proof.c

func init*(_: type G1Point, x, y: UInt256): G1Point =
  G1Point(x: x, y: y)

func x*(point: G1Point): UInt256 =
  point.x

func y*(point: G1Point): UInt256 =
  point.y

func init*(_: type G2Point, x, y: Fp2Element): G2Point =
  G2Point(x: x, y: y)

func x*(point: G2Point): Fp2Element =
  point.x

func y*(point: G2Point): Fp2Element =
  point.y

func init*(_: type Fp2Element, real, imag: UInt256): Fp2Element =
  Fp2Element(real: real, imag: imag)

func real*(element: Fp2Element): UInt256 =
  element.real

func imag*(element: Fp2Element): UInt256 =
  element.imag
