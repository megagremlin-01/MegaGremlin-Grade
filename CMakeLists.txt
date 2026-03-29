cmake_minimum_required(VERSION 3.28...3.30)

# 1. Load the core infrastructure
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common/bootstrap.cmake" NO_POLICY_SCOPE)

project(MegaGremlin-Grade VERSION 0.1.0)

# 2. Tell CMake where both Common and Windows helpers are
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/common")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows")

# 3. Load the components in the exact order the template requires
include(compiler_common)
include(helpers_common)
include(compilerconfig)
include(defaults)
include(helpers)

# 4. Define the plugin library
add_library(${CMAKE_PROJECT_NAME} MODULE)

# 5. Link OBS Core
find_package(libobs REQUIRED)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE OBS::libobs)

# 6. Project Files
target_sources(
  ${CMAKE_PROJECT_NAME}
  PRIVATE src/plugin-main.c
          src/grading.hlsl
)

# 7. Set naming and package the shader
set_target_properties(
  ${CMAKE_PROJECT_NAME}
  PROPERTIES OUTPUT_NAME ${CMAKE_PROJECT_NAME}
             PUBLIC_HEADER "src/grading.hlsl"
)

# 8. Finalize the plugin
setup_plugin_target(${CMAKE_PROJECT_NAME})