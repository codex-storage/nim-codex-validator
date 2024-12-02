type StorageRequestId* = distinct array[32, byte]

func `$`*(slotId: StorageRequestId): string {.borrow.}
func `==`*(a, b: StorageRequestId): bool {.borrow.}
