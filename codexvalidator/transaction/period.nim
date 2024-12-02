type Period* = distinct uint64

func `$`*(period: Period): string {.borrow.}
func `==`*(a, b: Period): bool {.borrow.}
