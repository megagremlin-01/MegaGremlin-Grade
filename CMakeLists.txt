cmake_minimum_required(VERSION 3.24)
project(MegaGremlin-Grade)

include(FetchContent)

# 1. THE BRIDGE: If the runner didn't extract OBS, we do it here.
FetchContent_Declare(
  obs-studio
  URL https://github.com/obsproject/obs-studio/archive/refs/tags/31.1.1.zip
)
FetchContent_MakeAvailable(obs-studio)

# 2. Manual Target
add_library(MegaGremlin-Grade MODULE)

target_sources(MegaGremlin-Grade PRIVATE
    src/plugin-main.c
    src/grading.hlsl
)

# 3. Shader Protection
set_source_files_properties(src/grading.hlsl PROPERTIES VS_TOOL_SET "None")
set_source_files_properties(src/grading.hlsl PROPERTIES HEADER_FILE_ONLY TRUE)

# 4. PATHING: Now we point to the content WE just fetched
target_include_directories(MegaGremlin-Grade PRIVATE
    src
    ${obs-studio_SOURCE_DIR}/libobs
)

# 5. Link & Output
target_link_libraries(MegaGremlin-Grade PRIVATE obs)

set_target_properties(MegaGremlin-Grade PROPERTIES
    PREFIX ""
    OUTPUT_NAME "MegaGremlin-Grade"
)