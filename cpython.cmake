# set BUILD_FOLDER and maybe CMAKE_COMMAND before calling
# check if the LICENSE exists before doing anything here

if (NOT EXISTS ${BUILD_FOLDER}/cpython-3.10.2/LICENSE)
    message(STATUS "Downloading Cpython if necessary")
    file(
            DOWNLOAD
            https://github.com/python/cpython/archive/refs/tags/v3.10.2.tar.gz
            ${BUILD_FOLDER}/cpython.tar.gz
            EXPECTED_HASH SHA256=1818464b0285e8eb90e2495f9a4c506f6a01774879e6737af517adb524fffe4e
    )
    message(STATUS "Unzipping CPython tarball")
    execute_process(
            WORKING_DIRECTORY ${BUILD_FOLDER}
            COMMAND ${CMAKE_COMMAND} -E tar xzf cpython.tar.gz
    )
    if (WIN32)
        message(STATUS "Setting CPython build architecture")
        set(CPYTHON_PLATFORM x86)
        if (CMAKE_CL_64)
            set(CPYTHON_PLATFORM x64)
        endif ()
        message(STATUS "Building CPython")
        execute_process(
                WORKING_DIRECTORY ${BUILD_FOLDER}/cpython-3.10.2
                COMMAND ${BUILD_FOLDER}/cpython-3.10.2/PCbuild/build.bat -p ${CPYTHON_PLATFORM}
        )
    else ()
        message(STATUS "Configuring CPython")
        execute_process(
                WORKING_DIRECTORY ${BUILD_FOLDER}/cpython-3.10.2
                COMMAND ./configure --enable-shared --prefix=${Python_ROOT}
        )
        message(STATUS "Building CPython")
        execute_process(
                WORKING_DIRECTORY ${BUILD_FOLDER}/cpython-3.10.2
                COMMAND make -j 19
        )
        message(STATUS "Installing CPython")
        execute_process(
                WORKING_DIRECTORY ${BUILD_FOLDER}/cpython-3.10.2
                COMMAND make -j 19 install
        )
    endif ()
endif ()
