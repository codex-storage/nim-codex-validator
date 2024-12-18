import ../basics

type NetworkAddress* = distinct TransportAddress

func init*(_: type NetworkAddress, address: string): ?!NetworkAddress =
  NetworkAddress(initTAddress(address)).catch()

func `==`*(a, b: NetworkAddress): bool {.borrow.}
func `$`*(address: NetworkAddress): string {.borrow.}
