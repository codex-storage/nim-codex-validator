import ./basics
import codexvalidator/network

suite "Network connections":

  test "connections to a server can be made":
    let server = await NetworkServer.open()
    let outgoing = await NetworkConnection.connect(!server.address)
    let incoming = await server.accept()
    await outgoing.close()
    await incoming.close()
    await server.close()

  test "outgoing connections can fail":
    let address = !NetworkAddress.init("127.0.0.1:1011") # port reserved by IANA
    expect NetworkError:
      discard await NetworkConnection.connect(address)

suite "Network packets":

  var server: NetworkServer

  setup:
    server = await NetworkServer.open()

  teardown:
    await server.close()

  test "packets of bytes can be exchanged over a network connection":
    let packet = seq[byte].example
    var received: seq[byte]

    proc send {.async.} =
      let outgoing = await NetworkConnection.connect(!server.address)
      await outgoing.sendPacket(packet)
      await outgoing.close()

    proc receive {.async.} =
      let incoming = await server.accept()
      received = !await incoming.receivePacket()
      await incoming.close()

    await allFutures(send(), receive())

    check received == packet

  test "connection handles multiple packets of different size":
    let packets = newSeqWith(100, seq[byte].example)
    var received: seq[seq[byte]]

    proc send {.async.} =
      let outgoing = await NetworkConnection.connect(!server.address)
      for packet in packets:
        await outgoing.sendPacket(packet)
      await outgoing.close()

    proc receive {.async.} =
      let incoming = await server.accept()
      while packet =? await incoming.receivePacket():
        received.add(packet)
      await incoming.close()

    await allFutures(send(), receive())

    check received == packets
