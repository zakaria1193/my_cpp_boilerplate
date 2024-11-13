############################################################
# Set compiler, language and flags
# Keep before project() call
############################################################
# Set the C++ standard to use
set(CMAKE_CXX_STANDARD 23)

set(CMAKE_SIZE "/usr/bin/size")

# Colorize output
set(CMAKE_COLOR_DIAGNOSTICS ON)

############################################################
# CMake options
############################################################
cmake_minimum_required(VERSION 3.9)

project(my_template VERSION 1.0.0)

# Compile_commands.json generation
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)

# Set to ON to enable verbose output when building
set(CMAKE_VERBOSE_MAKEFILE OFF)

set(PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR})


############################################################
# Create a library
############################################################
set(LIBRARY_SOURCES
  src/lib/lib.cpp
)

#Generate the static library from the library sources
add_library(custom_library STATIC 
    ${LIBRARY_SOURCES}
)

target_include_directories(custom_library
    PUBLIC 
        ${PROJECT_SOURCE_DIR}/include
)

# Compiler flags
target_compile_options(custom_library PRIVATE
    -Wall
    -Wextra
    -Wno-unused-parameter
    -Wno-unused-private-field
    $<$<CONFIG:Debug>:
        -ggdb3
        -fno-omit-frame-pointer
        -fno-optimize-sibling-calls
        -fsanitize=address,undefined
    >
    $<$<CONFIG:Release>:
        -O2
    >
)

############################################################
# Create an executable
############################################################
set(EXECUTABLE_SOURCES
    src/main.cpp
)

# Add an executable with the above sources
add_executable(my_template_binary
    ${EXECUTABLE_SOURCES}
)

# link the new hello_library target with the hello_binary target
target_link_libraries(my_template_binary
    PRIVATE 
    custom_library
)

# Linker flags
target_link_options(my_template_binary PRIVATE
    -Wl,-Map=output.map
    $<$<CONFIG:Debug>:
        -fsanitize=address,undefined
    >
    $<$<CONFIG:Release>:
        -flto
    >
)

target_compile_options(my_template_binary PRIVATE $<TARGET_PROPERTY:custom_library,COMPILE_OPTIONS>)

############################################################
# Post build commands
############################################################

# Generate the .bin
add_custom_command(TARGET my_template_binary POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:my_template_binary> $<TARGET_FILE:my_template_binary>.bin
    COMMENT "Generating .bin"
)

# Print the size
add_custom_command(TARGET my_template_binary POST_BUILD
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:my_template_binary>
    COMMENT "Size of the executable"
)

############################################################
# Gen vars for include files
############################################################

file(GLOB_RECURSE
  PRIVATE_INCLUDE_FILES
  "${CMAKE_SOURCE_DIR}/src/include/*"
)

file(GLOB_RECURSE
  PUBLIC_INCLUDE_FILES
  "${CMAKE_SOURCE_DIR}/include/*"
)

############################################################
# Add clang tidy
############################################################

# Add clang-tidy to the project
find_program(CLANG_TIDY_EXE NAMES "clang-tidy-17")

if(CLANG_TIDY_EXE)
    message(STATUS "clang-tidy found: ${CLANG_TIDY_EXE}")
    set(DO_CLANG_TIDY
      "${CLANG_TIDY_EXE}"
      --use-color # Colorize output
      -p ${CMAKE_BINARY_DIR}/compile_commands.json
      )
    add_custom_target(
        clang-tidy
        COMMAND ${DO_CLANG_TIDY} ${EXECUTABLE_SOURCES} ${LIBRARY_SOURCES}
        WORKING_DIRECTORY ${PROJECT_DIR}
        COMMENT "Running clang-tidy"
        VERBATIM
    )
    add_custom_target(
        clang-tidy-fix
        COMMAND ${DO_CLANG_TIDY} -fix ${EXECUTABLE_SOURCES} ${LIBRARY_SOURCES}
        WORKING_DIRECTORY ${PROJECT_DIR}
        COMMENT "Running clang-tidy fix"
        VERBATIM
    )
else()
    message(STATUS "clang-tidy not found.")
endif()

############################################################
# Add clang format
############################################################

# Add clang-format to the project only if version >= 17
# using --version
find_program(CLANG_FORMAT "clang-format-17")

if(CLANG_FORMAT)
  message(STATUS "clang-format found: ${CLANG_FORMAT}")
  # Add a custom target to run Clang-Format on all relevant files
  file(GLOB_RECURSE FORMAT_FILES
    ${PUBLIC_INCLUDE_FILES}
    ${PRIVATE_INCLUDE_FILES}
    ${EXECUTABLE_SOURCES}
    ${LIBRARY_SOURCES})

  set(CLANG_FORMAT_CONFIG_FILE "${CMAKE_SOURCE_DIR}/.clang-format")
  add_custom_target(clang-format
    COMMAND ${CLANG_FORMAT}
    -style=file # Look for the .clang-format file in the WORKING_DIRECTORY
    -i # In-place editing of the files
    ${FORMAT_FILES} # Files to format
    COMMENT "Running Clang-Format"
    WORKING_DIRECTORY ${PROJECT_DIR}
    VERBATIM
  )
else()
  message(STATUS "clang-format not found.")
endif()

############################################################
# Add cppcheck
############################################################

find_program(CPPCHECK "cppcheck")

if(CPPCHECK)
  message(STATUS "cppcheck found: ${CPPCHECK}")
  # Add a custom target to run Clang-Format on all relevant files
  file(GLOB_RECURSE CPPCHECK_FILES
    ${PUBLIC_INCLUDE_FILES}
    ${PRIVATE_INCLUDE_FILES}
    ${EXECUTABLE_SOURCES}
    ${LIBRARY_SOURCES})

  add_custom_target(cppcheck
    COMMAND ${CPPCHECK}
    --enable=all
    ${CPPCHECK_FILES} # Files to format
    COMMENT "Running cppcheck"
    WORKING_DIRECTORY ${PROJECT_DIR}
  )
else()
  message(STATUS "cppcheck not found.")
endif()
