cmake_minimum_required(VERSION 3.28...3.30)

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/common/bootstrap.cmake" NO_POLICY_SCOPE)

project(MegaGremlin-Grade VERSION 0.1.0)

option(ENABLE_FRONTEND_API "Use obs-frontend-api for UI functionality" OFF)
option(ENABLE_QT "Use Qt functionality" OFF)

include(compilerconfig)
include(defaults)
include(helpers)

add_library(${CMAKE_PROJECT_NAME} MODULE)

find_package(libobs REQUIRED)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE OBS::libobs)

if(ENABLE_FRONTEND_API)
  find_package(obs-frontend-api REQUIRED)
  target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE OBS::obs-frontend-api)
endif()

if(ENABLE_QT)
  find_package(Qt6 COMPONENTS Widgets Core)
  target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE Qt6::Core Qt6::Widgets)
  target_compile_options(
    ${CMAKE_PROJECT_NAME}
    PRIVATE $<$<C_COMPILER_ID:Clang,AppleClang>:-Wno-quoted-include-in-framework-header -Wno-comma>
  )
  set_target_properties(
    ${CMAKE_PROJECT_NAME}
    PROPERTIES AUTOMOC ON AUTOUIC ON AUTORCC ON
  )
endif()

target_sources(${CMAKE_PROJECT_NAME} PRIVATE 
	src/plugin-main.c
	src/grading.hlsl)

# This ensures the .hlsl file is packaged with the .dll
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    OUTPUT_NAME ${CMAKE_PROJECT_NAME}
    PUBLIC_HEADER "src/grading.hlsl"
    )

# Helper function from the template to handle the final export logic
setup_plugin_target(${CMAKE_PROJECT_NAME})