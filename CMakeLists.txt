cmake_minimum_required(VERSION 3.24)
project(MegaGremlin-Grade)

add_library(MegaGremlin-Grade MODULE)

# Using the exact filenames from your mytree.txt 
target_sources(MegaGremlin-Grade PRIVATE
    src/plugin-main.c
    src/grading.hlsl
)

# Protect the shader from the standalone FXC compiler
set_source_files_properties(src/grading.hlsl PROPERTIES VS_TOOL_SET "None")
set_source_files_properties(src/grading.hlsl PROPERTIES HEADER_FILE_ONLY TRUE)

# THE RESOLUTION:
# Since Build-Windows.ps1 runs from .github/scripts, 
# and it uses Resolve-Path -Path "$PSScriptRoot/../..", 
# we point to the absolute standard locations for the OBS source tree.
target_include_directories(MegaGremlin-Grade PRIVATE
    src
    ${CMAKE_SOURCE_DIR}/obs-studio/libobs
    ${CMAKE_BINARY_DIR}/_deps/obs-studio-src/libobs
    ${OBS_INCLUDE_DIR}
)

# Link against the core library
target_link_libraries(MegaGremlin-Grade PRIVATE obs)

set_target_properties(MegaGremlin-Grade PROPERTIES
    PREFIX ""
    OUTPUT_NAME "MegaGremlin-Grade"
)