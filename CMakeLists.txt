cmake_minimum_required(VERSION 3.5.1)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "-Wall")

project(neural-net)
include_directories(
	"${CMAKE_SOURCE_DIR}/include/"	 		     
)

set(SRC_FILES "${CMAKE_SOURCE_DIR}/src/")

message(${SRC_FILES})

add_executable(NeuralNet ${SRC_FILES})


