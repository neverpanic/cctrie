project(CTrie LANGUAGES C)
cmake_minimum_required(VERSION 3.1)

set(CMAKE_C_STANDARD 99)

add_library(ctrie SHARED ctrie.c ctrie.h)
target_compile_options(ctrie PUBLIC -pedantic -Wall -Werror)

add_executable(ctrie_test ctrie_test.c)
target_link_libraries(ctrie_test PUBLIC ctrie)
