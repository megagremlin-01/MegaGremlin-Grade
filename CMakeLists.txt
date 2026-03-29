cmake_minimum_required(VERSION 3.24)
project(MegaGremlin-Grade)

# 1. Manual Target
add_library(MegaGremlin-Grade MODULE)

target_sources(MegaGremlin-Grade PRIVATE
    src/plugin-main.c
    src/grading.hlsl
)

# 2. Shader Protection (Keep this—it solved the FXC errors!)
set_source_files_properties(src/grading.hlsl PROPERTIES VS_TOOL_SET "None")
set_source_files_properties(src/grading.hlsl PROPERTIES HEADER_FILE_ONLY TRUE)

# 3. THE "BRUTE FORCE" FIND: 
# This looks for the OBS headers wherever the script downloaded them
find_path(OBS_HEADER_PATH 
    NAMES obs-module.h
    PATHS 
        "${CMAKE_BINARY_DIR}/_deps"
        "${CMAKE_SOURCE_DIR}/obs-studio"
        "D:/a/MegaGremlin-Grade/MegaGremlin-Grade/obs-studio" # Hard-coded CI Path
    PATH_SUFFIXES libobs
    RECURSIVE
)

target_include_directories(MegaGremlin-Grade PRIVATE
    src
    ${OBS_HEADER_PATH}
)

# 4. Link & Properties
target_link_libraries(MegaGremlin-Grade PRIVATE obs)

set_target_properties(MegaGremlin-Grade PROPERTIES
    PREFIX ""
    OUTPUT_NAME "MegaGremlin-Grade"
)