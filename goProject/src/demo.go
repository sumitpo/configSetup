package labs

func Add(a, b int) int {
	return a + b
}

func Fibonacci(n int) int {
	if n == 0 || n == 1 {
		return n
	}
	return Fibonacci(n-1) + Fibonacci(n-2)
}
