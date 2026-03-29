cmake_minimum_required(VERSION 3.24)
project(MegaGremlin-Grade)

add_library(MegaGremlin-Grade MODULE src/plugin-main.c)

# Point directly to your 'deps' folder where we downloaded the headers
target_include_directories(MegaGremlin-Grade PRIVATE deps)

# Link against the core OBS library (which the GitHub runner already has in its path)
target_link_libraries(MegaGremlin-Grade PRIVATE obs)