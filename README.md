[ Describe your project here ]

### Prerequisites

- CMake 3.10 or later
- C++ compiler with C++23 support (Recommended clang-17)

### Code quality checks

- libsanitizer
- clang-tidy
- cppcheck
- clang-format

### CI Test

[![CMake](https://github.com/zakaria1193/my_cpp_boilerplate/actions/workflows/cmake.yml/badge.svg)](https://github.com/zakaria1193/my_cpp_boilerplatmy_cpp_boilerplate/actions/workflows/cmake.yml)

### Documentation

[ Add your documentation here ]

### Building with CMake Presets

This project uses CMake Presets to manage build configurations. The presets are defined in the `CMakePresets.json` file.

To configure and build the project using the Debug preset:

```sh
cmake --preset debug
cmake --build --preset debug
```

To configure and build the project using the Release preset:

```sh
cmake --preset release
cmake --build --preset release
```
