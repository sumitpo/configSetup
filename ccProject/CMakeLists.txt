cmake_minimum_required(VERSION 3.10)

# Project name
project(MyProject)

# Enable testing
enable_testing()

# Use FetchContent to download and configure Google Test
include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG        main  # You can specify a specific commit or tag here
)

# Fetch and make Google Test available
FetchContent_MakeAvailable(googletest)

# Add your test source files
add_executable(MyTests test.cpp)

# Link Google Test to your tests
target_link_libraries(MyTests gtest gtest_main)

# Optionally, add a test to CTest
add_test(NAME MyTest COMMAND MyTests)
