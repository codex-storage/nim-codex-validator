import ../basics

type NetworkError* = object of IOError

template convertNetworkErrors*(body): untyped =
  try:
    body
  except TransportError as error:
    raise newException(NetworkError, error.msg, error)
