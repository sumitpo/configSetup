package labs

import (
	"reflect"
	"testing"
)

func TestFakeModify(t *testing.T) {
	type test struct {
		in  [5]int
		out [5]int
	}
	tests := map[string]test{
		"test1": {[5]int{1, 2, 3, 4, 5}, [5]int{1, 2, 3, 4, 5}},
		"test2": {[5]int{1, 2, 3, 4, 5}, [5]int{1, 2, 3, 4, 5}},
	}
	for k, v := range tests {
		t.Run(k, func(t *testing.T) {
			FakeModify(v.in)
			if !reflect.DeepEqual(v.in, v.out) {
				t.Errorf("case: %#v, got: %#v", v, v.in)
			}
		})
	}
}
func TestSum(t *testing.T) {

	t.Run("collection of 5 numbers", func(t *testing.T) {
		numbers := []int{1, 2, 3, 4, 5}

		got := Sum(numbers)
		want := 15

		if got != want {
			t.Errorf("got %d want %d given, %v", got, want, numbers)
		}
	})

	t.Run("collection of any size", func(t *testing.T) {
		numbers := []int{1, 2, 3}

		got := Sum(numbers)
		want := 6

		if got != want {
			t.Errorf("got %d want %d given, %v", got, want, numbers)
		}
	})

}

func TestSumAll(t *testing.T) {

	got := SumAll([]int{1, 2}, []int{0, 9})
	want := []int{3, 9}

	if !reflect.DeepEqual(got, want) {
		t.Errorf("got %v want %v", got, want)
	}
}

func TestSumAllTails(t *testing.T) {
	got := SumAllTails([]int{1, 2}, []int{0, 9})
	want := []int{2, 9}

	if !reflect.DeepEqual(got, want) {
		t.Errorf("got %v want %v", got, want)
	}
}
