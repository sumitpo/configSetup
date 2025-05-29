cmake_minimum_required(VERSION 3.10)

# Project name
project(MyProject)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/install")
# CACHE PATH "${CMAKE_SOURCE_DIR}/targets")

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

include_directories(${PROJECT_SOURCE_DIR}/include)

file(GLOB SRC_FILES "src/*.cc")
list(REMOVE_ITEM SRC_FILES "src/test.cc")

add_library(cLearn STATIC ${SRC_FILES})

target_include_directories(cLearn PUBLIC ${PROJECT_SOURCE_DIR}/include)

# Add your test source files
add_executable(MyTests ${PROJECT_SOURCE_DIR}/src/test.cc)
target_include_directories(cLearn PRIVATE ${gtest_SOURCE_DIR}/include)

# Link Google Test to your tests
target_link_libraries(MyTests cLearn GTest::gtest GTest::gtest_main)

# Optionally, add a test to CTest
add_test(NAME MyTest COMMAND MyTests)

# Install the executable
install(TARGETS MyTests DESTINATION bin)

# Install the headers (if applicable)
# install(DIRECTORY include/ DESTINATION include)
