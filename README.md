# A CTrie Implementation in C

This repository contains a CTrie implementation as described in [Cache-Aware Lock-Free Concurrent Hash Tries](https://arxiv.org/pdf/1709.06056.pdf).

Note that this implementation in its current form:

 - Does *not* implement node deletion. It was not required for the use-case for
   which this implementation was written. Consequently, we did not implement
   tomb node support.
 - Resolves hashcode conflicts using array lists in what we call an "LNode".
 - Leaks memory. None of the memory that is no longer used by the CTrie will be
   freed, because at the time of removal, it is not clear whether a different
   thread might still be using it. Implementing lock-free reference counting in
   the `any_node_t` should probably allow you to fix this together with
   `retain`/`release`-style functions, where `retain` is called before a node
   is read, and `release` is called after reading a node is finished.
 - Was written to support putting the CTrie into a shared memory area that is
   mapped into multiple processes at different addresses. The requirement to
   put the shared memory segment at different addresses in different processes
   means that instead of pointers, raw offsets must be used and all offsets
   must be interpreted relative to a shared memory segment base address. For
   this reason, all pointer operations are abstracted using the `PTR()` and
   `DEREF()` macros. Note that for this to work, you will need a memory
   allocator that supports obtaining and releasing memory from a shared memory
   area; the implementation should be refactored to support passing
   a malloc/realloc/free pointer set to `ctrie_new()`.
 - There is currently no support for arbitrary value types (i.e. using `size_t
   vallen` and `void* value`). Instead we define a `value_t` that supports our
   use-case.

## License
This source code is licensed under the BSD-2-Clause license.
