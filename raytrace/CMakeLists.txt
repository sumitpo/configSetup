cmake_minimum_required(VERSION 3.14)
project(raytrace)

# Set the C++ standard to C++11
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON) # Require the specified standard
set(CMAKE_CXX_EXTENSIONS OFF) # Disable compiler-specific extensions
set(CMAKE_CXX_FLAGS "-Wno-deprecated-non-prototype")

# Enable verbose output for FetchContent
set(FETCHCONTENT_QUIET OFF) # Disable quiet mode to show more output
set(FETCHCONTENT_FULLY_DISCONNECTED OFF) # Ensure FetchContent performs network
                                         # operations

# Define a function to find or fetch a library
function(find_or_fetch_library library_name repository tag target_name)
  # Try to find the library using find_package
  find_package(${library_name} QUIET)

  if(${library_name}_FOUND)
    message(STATUS "${library_name} found on the system.")
  else()
    # If the library is not found, use FetchContent to download and build it
    message(
      STATUS "${library_name} not found. Fetching and building from source...")

    include(FetchContent)
    FetchContent_Declare(
      ${library_name}
      GIT_REPOSITORY ${repository}
      GIT_TAG ${tag})
    FetchContent_MakeAvailable(${library_name})

    # Set a flag to indicate that we're using the fetched version
    set(${library_name}_FETCHED
        TRUE
        PARENT_SCOPE)
  endif()

  # Link the library to the target
  if(${library_name}_FETCHED)
    # If the library was found via find_package, link against the imported
    # target
    target_link_libraries(${target_name}
                          PRIVATE ${library_name}::${library_name})
  else()
    # If the library was fetched, link against the fetched target
    target_link_libraries(${target_name} PRIVATE ${library_name})
  endif()
endfunction()

set(EXEC demo)

file(GLOB_RECURSE SOURCES "src/*.cpp")

# Add your executable
add_executable(${EXEC} ${SOURCES})

find_or_fetch_library(spng https://github.com/randy408/libspng.git v0.7.4
                      ${EXEC})
find_or_fetch_library(assimp https://github.com/assimp/assimp.git v5.3.1
                      ${EXEC})
find_or_fetch_library(argparse https://github.com/p-ranav/argparse.git v3.2
                      ${EXEC})

# Link Assimp to your executable
target_link_libraries(${EXEC} PRIVATE assimp spng)

# Install the executable to ./install/bin
install(TARGETS ${EXEC} RUNTIME DESTINATION bin)

# Optionally, install headers or other files install(FILES src/header.h
# DESTINATION include)

# Set the install prefix to ./install
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/install")
