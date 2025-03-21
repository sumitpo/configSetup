download_res() {
  test -d ./resources && rm -rf resources
  mkdir resources
  (
    cd resources
    wget https://casual-effects.com/g3d/data10/research/model/bunny/bunny.zip
    unzip bunny.zip
    rm bunny.zip
  )
}
format_cmake() {
  set -x
  find . -name "CMakeLists.txt" -exec cmake-format -i {} \;
}
format_cmake() {
  set -x
  find . -name "*.cpp" -not -path "./build/*" -exec clang-format -i {} \;
}
full_clean() {
  test -d ./build && rm -rf build
}
download_res
format_cmake
test ! -d ./build && mkdir build
(
  cd build
  cmake ..
  make install
)
