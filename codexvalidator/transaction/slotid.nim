type SlotId* = distinct array[32, byte]

func `$`*(slotId: SlotId): string {.borrow.}
func `==`*(a, b: SlotId): bool {.borrow.}
