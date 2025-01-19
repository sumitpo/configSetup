package labs

import (
	"reflect"
	"testing"
)

func TestMax(t *testing.T) {
	t.Run("test1", func(t *testing.T) {
		got := Max(1, 2)
		if !reflect.DeepEqual(got, 2) {
			t.Errorf("case: %#v, got: %#v", 1, got)
		}
	})
	t.Run("test2", func(t *testing.T) {
		got := Max(1.2, 2.2)
		if !reflect.DeepEqual(got, 2.2) {
			t.Errorf("case: %#v, got: %#v", 1, got)
		}
	})
}
