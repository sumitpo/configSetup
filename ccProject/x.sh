full_clean() {
  test -d ./build && rm -rf build
}
test ! -d ./build && mkdir build
(cd build; cmake ..; make install)
