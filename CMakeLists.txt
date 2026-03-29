cmake_minimum_required(VERSION 3.28...3.30)

# 1. Start the Bootstrap
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common/bootstrap.cmake" NO_POLICY_SCOPE)

project(MegaGremlin-Grade VERSION 0.1.0)

# 2. Add the folders to the search path so CMake can find the includes
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/common")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows")

# 3. Load the Template Logic in the Required Sequence
include(compiler_common)   # Found in cmake/common
include(helpers_common)    # Found in cmake/common (Contains setup_plugin_target)
include(compilerconfig)    # Found in cmake/windows
include(defaults)          # Found in cmake/windows
include(helpers)           # Found in cmake/windows

# 4. Define the Plugin
add_library(${CMAKE_PROJECT_NAME} MODULE)

# 5. Link OBS Core
find_package(libobs REQUIRED)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE OBS::libobs)

# 6. Source Files (One per line to satisfy Gersemi)
target_sources(
  ${CMAKE_PROJECT_NAME}
  PRIVATE src/plugin-main.c
          src/grading.hlsl
)

# 7. Set Properties
set_target_properties(
  ${CMAKE_PROJECT_NAME}
  PROPERTIES OUTPUT_NAME ${CMAKE_PROJECT_NAME}
             PUBLIC_HEADER "src/grading.hlsl"
)

# 8. Finalize (Now definitely recognized)
setup_plugin_target(${CMAKE_PROJECT_NAME})