import ../basics
import ./address
import ./error

type NetworkConnection* = distinct StreamTransport

proc connect*(
  _: type NetworkConnection,
  address: NetworkAddress
): Future[NetworkConnection] {.async:(raises:[NetworkError, CancelledError]).} =
  convertNetworkErrors:
    NetworkConnection(await TransportAddress(address).connect())

proc sendPacket*(connection: NetworkConnection, packet: seq[byte]) {.
  async:(raises:[NetworkError, CancelledError])
.} =
  convertNetworkErrors:
    let transport = StreamTransport(connection)
    let header = @[packet.len.uint32]
    discard await transport.write(header)
    if packet.len > 0:
      discard await transport.write(packet)

proc receivePacket*(connection: NetworkConnection): Future[?seq[byte]] {.
  async:(raises:[NetworkError, CancelledError])
.} =
  convertNetworkErrors:
    let transport = StreamTransport(connection)
    let header = await transport.read(sizeof(uint32))
    if header.len != sizeof(uint32):
      return none seq[byte]
    let length = (cast[ptr uint32](addr header[0]))[]
    if length == 0:
      return some seq[byte].default
    some await transport.read(length.int)

proc close*(connection: NetworkConnection) {.async:(raises:[]).} =
  await StreamTransport(connection).closeWait()
