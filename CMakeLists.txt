cmake_minimum_required(VERSION 3.24)
project(MegaGremlin-Grade)

# 1. Manual Target
add_library(MegaGremlin-Grade MODULE)

# 2. Add Sources
target_sources(MegaGremlin-Grade PRIVATE
    src/plugin-main.c
    src/grading.hlsl
)

# 3. Shader Fix (Keep this from the last run)
set_source_files_properties(src/grading.hlsl PROPERTIES VS_TOOL_SET "None")
set_source_files_properties(src/grading.hlsl PROPERTIES HEADER_FILE_ONLY TRUE)

# 4. THE FIX: Explicitly point to the OBS headers
# This maps the folders the GitHub Runner just downloaded
target_include_directories(MegaGremlin-Grade PRIVATE
    src
    ${OBS_INCLUDE_DIR}
    ${OBS_INCLUDE_DIR}/libobs
)

# 5. Link the OBS Library
target_link_libraries(MegaGremlin-Grade PRIVATE
    libobs
)

# 6. Final Properties
set_target_properties(MegaGremlin-Grade PROPERTIES
    PREFIX ""
    OUTPUT_NAME "MegaGremlin-Grade"
)