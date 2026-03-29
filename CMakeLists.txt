cmake_minimum_required(VERSION 3.24)

project(MegaGremlin-Grade)

# Manual Target Setup
add_library(MegaGremlin-Grade MODULE)

target_sources(MegaGremlin-Grade PRIVATE
    src/plugin-main.c
    src/grading.hlsl
)

# --- THE FIX ---
# Tell Windows NOT to try and compile the shader as a standalone program
set_source_files_properties(src/grading.hlsl PROPERTIES VS_TOOL_SET "None")
set_source_files_properties(src/grading.hlsl PROPERTIES HEADER_FILE_ONLY TRUE)
# ---------------

target_include_directories(MegaGremlin-Grade PRIVATE
    ${OBS_INCLUDE_DIR}
)

target_link_libraries(MegaGremlin-Grade PRIVATE
    obs
)

set_target_properties(MegaGremlin-Grade PROPERTIES
    PREFIX ""
    OUTPUT_NAME "MegaGremlin-Grade"
)