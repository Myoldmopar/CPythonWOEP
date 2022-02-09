#include <iostream>

#if LINK_WITH_PYTHON
#ifdef _DEBUG
// We don't want to try to import a debug build of Python here
// so if we are building a Debug build of the C++ code, we need
// to undefine _DEBUG during the #include command for Python.h.
// Otherwise it will fail
#undef _DEBUG
#include <Python.h>
#define _DEBUG
#else
#include <Python.h>
#endif
#endif

int main() {
    std::cout << "Hello, World!" << std::endl;
#if LINK_WITH_PYTHON
    std::string sVersion = Py_GetVersion();
    std::cout << "Linked to Python Version: \"" << sVersion << "\"" << std::endl;
#else
    std::cout << "This version _not_ linked to Python" << std::endl;
#endif
    return 0;
}
