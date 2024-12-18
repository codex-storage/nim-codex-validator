import ../basics
import ./address

type NetworkServer* = distinct StreamServer

proc open*(_: type NetworkServer): Future[?!NetworkServer] {.async:(raises:[]).} =
  NetworkServer(createStreamServer(Port(0))).catch()

proc address*(server: NetworkServer): ?!NetworkAddress =
  NetworkAddress(StreamServer(server).localAddress()).catch()

proc close*(server: NetworkServer) {.async:(raises:[]).} =
  StreamServer(server).close()
  await noCancel StreamServer(server).join()
