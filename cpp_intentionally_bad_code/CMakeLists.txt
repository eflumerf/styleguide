
project(cpp_intentionally_bad_code)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -pedantic -Wno-unused-variable -Weffc++")
#set(CMAKE_CXX_FLAGS "-Wall -Wextra -pedantic -Wno-unused-variable")

add_executable(bad_casts bad_casts.cc)
add_executable(trailing_return_types trailing_return_types.cc)
add_executable(disallowed_types_galore disallowed_types_galore.cc)
add_executable(namespace_usage namespace_usage.cc)
add_executable(rtti_usage rtti_usage.cc)
add_executable(default_params default_params.cc)
add_executable(increments_decrements increments_decrements.cc)
add_executable(worlds_worst_class worlds_worst_class.cc)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL "Set to ON to produce a compile_commands.json file which clang-tidy can use" FORCE) 
