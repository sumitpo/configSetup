package labs

func FakeModify(in [5]int) {
	in[0] += 1
}

func Sum(numbers []int) int {
	sum := 0
	for _, number := range numbers {
		sum += number
	}
	return sum
}

func SumAll(numSlices ...[]int) []int {
	lengthOfSlices := len(numSlices)
	sumOfAll := make([]int, lengthOfSlices)
	for i, numbers := range numSlices {
		sumOfAll[i] = Sum(numbers)
	}
	return sumOfAll
}

func SumAllTails(numSlices ...[]int) []int {
	lengthOfSlices := len(numSlices)
	sumOfAll := make([]int, lengthOfSlices)
	for i, numbers := range numSlices {
		sumOfAll[i] = Sum(numbers[1:])
	}
	return sumOfAll
}
