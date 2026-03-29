cmake_minimum_required(VERSION 3.24)
project(MegaGremlin-Grade)

add_library(MegaGremlin-Grade MODULE)

target_sources(MegaGremlin-Grade PRIVATE
    src/plugin-main.c
    src/grading.hlsl
)

# Keep the shader from being pre-compiled by the Windows SDK
set_source_files_properties(src/grading.hlsl PROPERTIES VS_TOOL_SET "None")
set_source_files_properties(src/grading.hlsl PROPERTIES HEADER_FILE_ONLY TRUE)

# THE FIX: Direct mapping to the OBS Source Tree
# Based on how the Build-Windows.ps1 downloads dependencies, 
# we point to the 'libobs' directory inside the 'obs-studio' folder.
target_include_directories(MegaGremlin-Grade PRIVATE
    src
    ${CMAKE_BINARY_DIR}/obs-studio/libobs
    ${CMAKE_SOURCE_DIR}/obs-studio/libobs
    ${OBS_INCLUDE_DIR}
)

# Link against the core OBS library
target_link_libraries(MegaGremlin-Grade PRIVATE obs)

set_target_properties(MegaGremlin-Grade PROPERTIES
    PREFIX ""
    OUTPUT_NAME "MegaGremlin-Grade"
)