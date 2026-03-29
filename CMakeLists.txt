cmake_minimum_required(VERSION 3.28...3.30)

# 1. Load the core template infrastructure from the 'common' folder
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common/bootstrap.cmake" NO_POLICY_SCOPE)

project(MegaGremlin-Grade VERSION 0.1.0)

# 2. THE FIX: Point directly to the 'windows' folder found in your tree
# This allows 'include(helpers)' to find the file at cmake/windows/helpers.cmake
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows")

include(compilerconfig)
include(defaults)
include(helpers)

# 3. Define the plugin library
add_library(${CMAKE_PROJECT_NAME} MODULE)

# 4. Link OBS Core
find_package(libobs REQUIRED)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE OBS::libobs)

# 5. Project Files (Matching your 'src' folder layout)
target_sources(
  ${CMAKE_PROJECT_NAME}
  PRIVATE src/plugin-main.c
          src/grading.hlsl
)

# 6. Set naming and package the shader
set_target_properties(
  ${CMAKE_PROJECT_NAME}
  PROPERTIES OUTPUT_NAME ${CMAKE_PROJECT_NAME}
             PUBLIC_HEADER "src/grading.hlsl"
)

# 7. Finalize the plugin (Now recognized via cmake/windows/helpers.cmake)
setup_plugin_target(${CMAKE_PROJECT_NAME})