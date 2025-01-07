package labs

import (
	"reflect"
	"testing"
)

func TestAdd(t *testing.T) {
	type test struct {
		input1 int
		input2 int
		output int
	}
	tests := map[string]test{
		"test1": {input1: 1, input2: 2, output: 3},
		"test2": {input1: 12, input2: 232, output: 244},
		"test3": {input1: 0, input2: 0, output: 0},
		"test4": {input1: -11, input2: -2, output: -13},
	}
	for k, v := range tests {
		t.Run(k, func(t *testing.T) {
			got := Add(v.input1, v.input2)
			if !reflect.DeepEqual(got, v.output) {
				t.Errorf("case: %#v, got: %#v", v, got)
			}
		})
	}
}

func TestFibonacci(t *testing.T) {
	type test struct {
		input  int
		output int
	}
	tests := map[string]test{
		"test1": {input: 0, output: 0},
		"test2": {input: 1, output: 1},
		"test3": {input: 2, output: 1},
		"test4": {input: 8, output: 21},
		"test5": {input: 45, output: 1134903170},
	}
	for k, v := range tests {
		t.Run(k, func(t *testing.T) {
			got := Fibonacci(v.input)
			if !reflect.DeepEqual(got, v.output) {
				t.Errorf("case: %#v, got: %#v", v, got)
			}
		})
	}
}

func BenchmarkFibonacci(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Fibonacci(20)
	}
}
