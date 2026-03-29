cmake_minimum_required(VERSION 3.24)
project(MegaGremlin-Grade)

add_library(MegaGremlin-Grade MODULE)

target_sources(MegaGremlin-Grade PRIVATE
    src/plugin-main.c
    src/grading.hlsl
)

# Keep the shader from being compiled as a standalone EXE
set_source_files_properties(src/grading.hlsl PROPERTIES VS_TOOL_SET "None")
set_source_files_properties(src/grading.hlsl PROPERTIES HEADER_FILE_ONLY TRUE)

# THE FIX: We tell CMake to look in the 'deps' and 'obs-studio' folders 
# that the GitHub Action creates during the build.
target_include_directories(MegaGremlin-Grade PRIVATE
    src
    ${CMAKE_BINARY_DIR}/_deps/obs-studio-src/libobs
    ${CMAKE_SOURCE_DIR}/obs-studio/libobs
    ${OBS_INCLUDE_DIR}
)

target_link_libraries(MegaGremlin-Grade PRIVATE obs)

set_target_properties(MegaGremlin-Grade PROPERTIES
    PREFIX ""
    OUTPUT_NAME "MegaGremlin-Grade"
)