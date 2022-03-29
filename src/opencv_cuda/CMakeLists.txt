# cmake needs this line
cmake_minimum_required(VERSION 3.1)

message(STATUS "CMAKE_MODULE_PATH:"${CMAKE_MODULE_PATH})
message(STATUS "CMAKE_ROOT:"${CMAKE_ROOT})

project(opencv_example_project)

find_package(OpenCV REQUIRED)

message(STATUS "OpenCV library status:")
message(STATUS "    config: ${OpenCV_DIR}")
message(STATUS "    version: ${OpenCV_VERSION}")
message(STATUS "    libraries: ${OpenCV_LIBS}")
message(STATUS "    include path: ${OpenCV_INCLUDE_DIRS}")

add_executable(main main.cpp)

target_link_libraries(main PRIVATE ${OpenCV_LIBS})
