package labs

func Max[T int | float32 | float64](a, b T) T {
	if a > b {
		return a
	} else {
		return b
	}
}
