#ifndef PDP10_TEST_COMPILER_COMPAT_V1_H
#define PDP10_TEST_COMPILER_COMPAT_V1_H

/* Keep compiler spelling differences out of test bodies.  These macros may
 * change syntax, but must not change the C operation being tested. */
#if defined(__COMPILER_KCC__)
#define TEST_ALIGNOF(T) _Alignof(T)
#else
#define TEST_ALIGNOF(T) __alignof__(T)
#endif

#define TEST_ALIGNAS(N) __attribute__((aligned(N)))
#define TEST_NOINLINE __attribute__((noinline))

#endif
