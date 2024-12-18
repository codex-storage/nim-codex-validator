import ./basics
import codexvalidator/network

suite "Network communication":

  test "a connection can be made to a server":
    let server = !await NetworkServer.open()
    let address = !server.address
    let connection = !await NetworkConnection.connect(address)
    await connection.close()
    await server.close()

  test "connect can fail":
    let address = !NetworkAddress.init("127.0.0.1:1011") # port reserved by IANA
    let connection = await NetworkConnection.connect(address)
    check connection.isFailure
    check connection.error.msg.contains("Connection refused")
