cmake_minimum_required(VERSION 3.5.1)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_FLAGS "-Wall")

#Compiler vectorisation and optimisation
set(CMAKE_CXX_FLAGS_RELEASE "-march=native")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

project(neural-net)
include_directories(
  "${CMAKE_SOURCE_DIR}/include/"	
  "${CMAKE_SOURCE_DIR}/Eigen/"	     
)

file(GLOB NN_PERCEPTRON_SRC

    "src/Neural*",
    "src/Perceptron.cpp"
)

file(GLOB EXAMPLE_SRC

    "src/Neural*",
    "src/Perceptron.cpp",
    "src/Example.cpp"
)

message( ${EXAMPLE_SRC} )

add_library(NN_Perceptron SHARED ${NN_PERCEPTRON_SRC})

add_executable(NeuralNetExample ${EXAMPLE_SRC})

find_program(GTEST_INSTALLED gtest)



# UNIT TESTS
IF(CMAKE_BUILD_TYPE MATCHES Debug)
  # Don't Install Google Test if its already installed.
  IF(NOT GTEST_INSTALLED MATCHES TRUE)

    find_package(Threads REQUIRED)
    
    # Enable ExternalProject CMake module
    include(ExternalProject)
    
    # Download and install GoogleTest
    ExternalProject_Add(
      gtest
      URL https://github.com/google/googletest/archive/release-1.8.1.zip
      PREFIX ${CMAKE_CURRENT_BINARY_DIR}/gtest
      # Disable install step
      INSTALL_COMMAND ""
    )
    
    # Get GTest source and binary directories from CMake project
    ExternalProject_Get_Property(gtest source_dir binary_dir)

    # Create a libgtest target to be used as a dependency by test programs
    add_library(libgtest IMPORTED STATIC GLOBAL)
    add_dependencies(libgtest gtest)
    
    # Set libgtest properties
    set_target_properties(libgtest PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/googlemock/gtest/libgtest.a"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
    )
    
    # Create a libgmock target to be used as a dependency by test programs
    add_library(libgmock IMPORTED STATIC GLOBAL)
    add_dependencies(libgmock gtest)
    
    # Set libgmock properties
    set_target_properties(libgmock PROPERTIES
      "IMPORTED_LOCATION" "${binary_dir}/googlemock/libgmock.a"
      "IMPORTED_LINK_INTERFACE_LIBRARIES" "${CMAKE_THREAD_LIBS_INIT}"
    )
  ENDIF(NOT GTEST_INSTALLED MATCHES TRUE)
  enable_testing()
  add_subdirectory(test)
ENDIF(CMAKE_BUILD_TYPE MATCHES Debug)


