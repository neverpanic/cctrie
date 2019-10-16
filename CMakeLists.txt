project(CTrie LANGUAGES C)
cmake_minimum_required(VERSION 3.1)

set(CMAKE_C_STANDARD 99)

add_library(shmalloc SHARED shmalloc/shmalloc.c shmalloc/shmalloc.h)
target_compile_definitions(shmalloc PRIVATE
	HAVE_STDATOMIC_H
	HAVE_DECL_ATOMIC_COMPARE_EXCHANGE_STRONG_EXPLICIT=1)
target_include_directories(shmalloc PUBLIC shmalloc)

add_library(ctrie SHARED ctrie.c ctrie.h)
target_compile_options(ctrie PUBLIC -pedantic -Wall -Werror)

add_library(sharedctrie SHARED ctrie.c ctrie.h)
target_compile_definitions(sharedctrie PUBLIC USE_SHARED_MEMORY)
target_compile_options(sharedctrie  PUBLIC -pedantic -Wall -Werror)
target_link_libraries(sharedctrie PUBLIC shmalloc)

add_executable(ctrie_test ctrie_test.c)
target_link_libraries(ctrie_test PUBLIC ctrie)

add_executable(ctrie_shm_test ctrie_test.c)
target_link_libraries(ctrie_shm_test PUBLIC sharedctrie)

add_executable(ctrie_multiprocess_test ctrie_multiprocess_test.c)
target_link_libraries(ctrie_multiprocess_test PUBLIC sharedctrie)
