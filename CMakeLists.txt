cmake_minimum_required(VERSION 3.28...3.30)

# 1. Load the core infrastructure
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common/bootstrap.cmake" NO_POLICY_SCOPE)

project(MegaGremlin-Grade VERSION 0.1.0)

# 2. Add search paths for dependencies
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/common")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows")

include(compiler_common)
include(compilerconfig)
include(defaults)

# 3. Define the plugin library
add_library(${CMAKE_PROJECT_NAME} MODULE)

# 4. Link OBS Core
find_package(libobs REQUIRED)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE OBS::libobs)

# 5. Project Files
target_sources(
  ${CMAKE_PROJECT_NAME}
  PRIVATE src/plugin-main.c
          src/grading.hlsl
)

# 6. Manual Plugin Setup (Replacing the broken command)
set_target_properties(
  ${CMAKE_PROJECT_NAME}
  PROPERTIES PREFIX ""
             OUTPUT_NAME ${CMAKE_PROJECT_NAME}
             PUBLIC_HEADER "src/grading.hlsl"
             FOLDER "plugins"
)

# Define the build-time export for OBS
target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE BUILD_PLUGIN)

# 7. Finalize (No more 'Unknown Command' error possible here)
message(STATUS "Build configuration finalized for ${CMAKE_PROJECT_NAME}")