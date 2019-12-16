CC=clang

CFLAGS= -D DEBUG_SHM=0 -I shm_alloc -Wall -D USE_SHARED_MEMORY  -D DEBUG_DIR=\"debug\" -fsanitize=address

ctrie_multiprocess_test.out: ctrie_multiprocess_test.c libctrie.so Makefile libshm_alloc.so
	$(CC) $(CFLAGS) -o $@ ctrie_multiprocess_test.c -L. -lctrie -lshm_alloc

libctrie.so: ctrie.c ctrie.h libshm_alloc.so
	$(CC) $(CFLAGS) -fPIC -shared -o $@ ctrie.c -L. -Lshm_alloc -lc -lshm_alloc

libshm_alloc.so: shm_alloc/shm_alloc.c shm_alloc/shm_alloc.h  shm_alloc/shm_err.h libshm_util_funcs.so libshm_debug.so libshm_constants.so Makefile
	$(CC) $(CFLAGS) -fPIC -shared -o $@ shm_alloc/shm_alloc.c -lc -L. -lshm_util_funcs -lshm_constants -lshm_debug

libshm_debug.so: shm_alloc/shm_debug.h shm_alloc/shm_debug.c Makefile
	$(CC) $(CFLAGS) -fPIC -shared -o $@ shm_alloc/shm_debug.c -lc

libshm_util_funcs.so: shm_alloc/shm_util_funcs.h shm_alloc/shm_util_funcs.c libshm_constants.so libshm_debug.so shm_alloc/shm_types.h Makefile
	$(CC) $(CFLAGS) -fPIC -shared -o $@ shm_alloc/shm_util_funcs.c -lc -L. -lshm_constants -lshm_debug

libshm_constants.so: shm_alloc/shm_constants.h shm_alloc/shm_constants.c Makefile
	$(CC) $(CFLAGS) -fPIC -shared -o $@ shm_alloc/shm_constants.c -lc

clean:
	rm *.so shm_file *.out .*.swp *.dbgfl
