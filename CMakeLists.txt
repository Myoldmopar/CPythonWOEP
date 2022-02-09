cmake_minimum_required(VERSION 3.21)
project(CPythonWithoutExternalProjectAdd)

set(CMAKE_CXX_STANDARD 17)

option(LINK_WITH_PYTHON "Link with Python Library for Python Plugin Builds" OFF)
if (LINK_WITH_PYTHON)
    set(Python_ROOT "${PROJECT_BINARY_DIR}/CPython-prefix/CPython-install")
    set(Python_EXECUTABLE "${Python_ROOT}/bin/python3")

    message(STATUS "About to execute Cpython operations")
    execute_process(
            WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
            COMMAND
            ${CMAKE_COMMAND}
            -D BUILD_FOLDER=${PROJECT_BINARY_DIR}
            -D Python_ROOT=${Python_ROOT}
            -D Python_EXECUTABLE=${Python_EXECUTABLE}
            -D CMAKE_CL_64=${CMAKE_CL_64}
            -P ${PROJECT_SOURCE_DIR}/cpython.cmake)
    message(STATUS "Finished executing CPython operations")

    # this won't work because the CMake Python3 finder can't run the python3 binary -- it can't find the .so file
#    set(Python3_EXECUTABLE ${Python_EXECUTABLE})
#    find_package(Python3 COMPONENTS Interpreter Development)
#    execute_process(COMMAND "${Python3_EXECUTABLE}" -c "import sys; sys.stdout.write('.'.join([str(x) for x in sys.version_info[:3]]))"
#            RESULT_VARIABLE _Python_RESULT
#            OUTPUT_VARIABLE Python_VERSION
#            ERROR_QUIET
#            OUTPUT_STRIP_TRAILING_WHITESPACE)
    # message(FATAL_ERROR "Python_VERSION=${Python_VERSION}")
else ()
    message(STATUS "Skipping CPython operations because LINK_WITH_PYTHON flag is OFF")
endif ()

if (LINK_WITH_PYTHON)
    add_definitions("-DLINK_WITH_PYTHON=1")
else ()
    add_definitions("-DLINK_WITH_PYTHON=0")
endif ()

add_executable(CPythonWithoutExternalProjectAdd main.cpp)

if (LINK_WITH_PYTHON)
    target_include_directories(CPythonWithoutExternalProjectAdd PUBLIC ${Python_ROOT}/include/python3.10)
    target_link_libraries(CPythonWithoutExternalProjectAdd ${Python_ROOT}/lib/libpython3.10.so)
endif ()