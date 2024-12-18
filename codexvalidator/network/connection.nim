import ../basics
import ./address

type NetworkConnection* = distinct StreamTransport

proc connect*(
  _: type NetworkConnection,
  address: NetworkAddress
): Future[?!NetworkConnection] {.async:(raises:[]).} =
  NetworkConnection(await TransportAddress(address).connect()).catch()

proc close*(connection: NetworkConnection) {.async:(raises:[]).} =
  StreamTransport(connection).close()
  await noCancel StreamTransport(connection).join()
