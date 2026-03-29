cmake_minimum_required(VERSION 3.24)
project(MegaGremlin-Grade)

# Create the module
add_library(MegaGremlin-Grade MODULE src/plugin-main.c)

# Shader protection for Visual Studio
set_source_files_properties(src/grading.hlsl PROPERTIES VS_TOOL_SET "None")
set_source_files_properties(src/grading.hlsl PROPERTIES HEADER_FILE_ONLY TRUE)

# This tells the compiler to look in /deps 
# This allows it to resolve "util/c99defs.h" because it sees the 'util' folder inside 'deps'
target_include_directories(MegaGremlin-Grade PRIVATE deps src)

# Link against the core OBS library provided by the runner
target_link_libraries(MegaGremlin-Grade PRIVATE obs)

set_target_properties(MegaGremlin-Grade PROPERTIES
    PREFIX ""
    OUTPUT_NAME "MegaGremlin-Grade"
)