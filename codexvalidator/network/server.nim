import ../basics
import ./address
import ./connection
import ./error

type ConnectionQueue = AsyncQueue[NetworkConnection]

func new(_: type ConnectionQueue, maxSize: int): ConnectionQueue =
  newAsyncQueue[NetworkConnection](maxSize)

func createStreamCallback(queue: ConnectionQueue): auto =
  proc(_: StreamServer, stream: StreamTransport) {.async:(raises:[]).} =
    try:
      await queue.addLast(NetworkConnection(stream))
    except CancelledError:
      discard

type NetworkServer* = ref object
  implementation: StreamServer
  incoming: ConnectionQueue

proc open*(_: type NetworkServer): Future[NetworkServer] {.
  async:(raises:[NetworkError])
.} =
  convertNetworkErrors:
    let incoming = ConnectionQueue.new(1)
    let callback = incoming.createStreamCallback()
    let server = createStreamServer(callback, Port(0))
    server.start()
    NetworkServer(
      implementation: server,
      incoming: incoming
    )

proc address*(server: NetworkServer): ?!NetworkAddress =
  catch NetworkAddress(server.implementation.localAddress())

proc accept*(server: NetworkServer): Future[NetworkConnection] {.
  async:(raises:[CancelledError])
.} =
  await server.incoming.popFirst()

proc close*(server: NetworkServer) {.async:(raises:[NetworkError]).} =
  convertNetworkErrors:
    server.implementation.stop()
    await server.implementation.closeWait()
