cmake_minimum_required(VERSION 3.24)
project(MegaGremlin-Grade)

include(FetchContent)

# 1. Fetch the headers
FetchContent_Declare(
  obs-studio
  URL https://github.com/obsproject/obs-studio/archive/refs/tags/31.1.1.zip
)
FetchContent_MakeAvailable(obs-studio)

# 2. THE FIX: Create the missing header on the fly
# This creates a blank file named obsconfig.h so the compiler is satisfied.
file(WRITE ${CMAKE_BINARY_DIR}/obsconfig.h "")

add_library(MegaGremlin-Grade MODULE)

target_sources(MegaGremlin-Grade PRIVATE
    src/plugin-main.c
    src/grading.hlsl
)

set_source_files_properties(src/grading.hlsl PROPERTIES VS_TOOL_SET "None")
set_source_files_properties(src/grading.hlsl PROPERTIES HEADER_FILE_ONLY TRUE)

# 3. Add the paths (including the directory where we just made the fake file)
target_include_directories(MegaGremlin-Grade PRIVATE
    src
    ${obs-studio_SOURCE_DIR}/libobs
    ${CMAKE_BINARY_DIR}
)

target_link_libraries(MegaGremlin-Grade PRIVATE obs)

set_target_properties(MegaGremlin-Grade PROPERTIES
    PREFIX ""
    OUTPUT_NAME "MegaGremlin-Grade"
)