cmake_minimum_required(VERSION 3.28...3.30)

# 1. Load the core template infrastructure
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common/bootstrap.cmake" NO_POLICY_SCOPE)

project(MegaGremlin-Grade VERSION 0.1.0)

# 2. CRITICAL FIX: Tell CMake where the 'helpers.cmake' file lives
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/helpers")

include(compilerconfig)
include(defaults)
include(helpers) # This file contains the 'setup_plugin_target' command

# 3. Create the plugin library
add_library(${CMAKE_PROJECT_NAME} MODULE)

# 4. Link OBS Core
find_package(libobs REQUIRED)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE OBS::libobs)

# 5. Project Files (Ensure these exist in your F:\MegaGremlin-Grade\src folder)
target_sources(${CMAKE_PROJECT_NAME} PRIVATE 
    src/plugin-main.c
    src/grading.hlsl
)

# 6. Set naming and package the shader file
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    OUTPUT_NAME ${CMAKE_PROJECT_NAME}
    PUBLIC_HEADER "src/grading.hlsl"
)

# 7. Finalize the plugin target using the template's helper
setup_plugin_target(${CMAKE_PROJECT_NAME})