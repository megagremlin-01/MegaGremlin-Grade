cmake_minimum_required(VERSION 3.28...3.30)

# 1. Start the core infrastructure
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common/bootstrap.cmake" NO_POLICY_SCOPE)

project(MegaGremlin-Grade VERSION 0.1.0)

# 2. Add search paths for the other dependencies
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/common")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/windows")

include(compiler_common)
include(compilerconfig)
include(defaults)

# 3. Create the plugin library
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

# 6. Set Properties
set_target_properties(
  ${CMAKE_PROJECT_NAME}
  PROPERTIES OUTPUT_NAME ${CMAKE_PROJECT_NAME}
             PUBLIC_HEADER "src/grading.hlsl"
)

# 7. MANUALLY LOAD THE COMMAND
# If the include fails, we define a fallback to keep the build moving
include(helpers_common OPTIONAL)
include(helpers OPTIONAL)

if(NOT COMMAND setup_plugin_target)
    message(STATUS "Note: Manually configuring plugin target settings...")
    set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES FOLDER "plugins")
endif()

setup_plugin_target(${CMAKE_PROJECT_NAME})