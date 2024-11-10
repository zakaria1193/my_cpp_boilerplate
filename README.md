[ Describe your project here ]

### Dependencies

#### Build system
- CMake 3.19 or later (to be able to use CMakePresets)
- C++ compiler with C++23 support (Recommended clang-17+, The CI uses clang-20)
- ninja-build

#### Static analyzes
- libsanitizer
- clang-tidy
- cppcheck

#### Formatter
- clang-format

### CI Test

[![Build & Check](https://github.com/zakaria1193/my_cpp_boilerplate/actions/workflows/build.yml/badge.svg)](https://github.com/zakaria1193/my_cpp_boilerplate/actions/workflows/build.yml)

### Documentation

[ Add your documentation here ]


### CMake usage of Presets

- This boilerplate uses the presets feature (CMake 3.19), but we still keep the presets to minimal (KISS principle), How?
    - Only one config preset
    - Multiple build presets (release, debug...)

This means we require a *multi-configuration* build system to support both Debug and Release builds in a *single* configuration step. It is designed to work with generators like _Ninja Multi-Config_ (Available on all Linux systems) or _Visual Studio_, _XCode_... Which allow specifying build configurations (Debug, Release, etc.) at build time.
*Single-configuration* generators, such as *Makefiles*, are not supported, as they require separate build directories for each configuration. If you really need that, edit the configurePresets section of the CMakePresets.json file. Copy paste this to Chatgpt if it's not clear.

