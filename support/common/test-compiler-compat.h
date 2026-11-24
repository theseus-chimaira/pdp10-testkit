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

/* Target linkage and semantic attributes must not degrade silently. */
#if defined(__COMPILER_KCC__)
/* Attributes with implemented KCC semantics use their native spellings.
 * Linkage attributes that KCC cannot implement remain explicit failures.
 */
#define PDP10_UNUSED __attribute__ ((unused))
#define PDP10_NOINLINE __attribute__ ((noinline))
#define PDP10_NORETURN __attribute__ ((noreturn))
#define PDP10_PACKED __attribute__ ((packed))
#define PDP10_ALIGNED(N) __attribute__ ((aligned (N)))
#define PDP10_WEAK PDP10_WEAK_IS_NOT_SUPPORTED_BY_KCC
#define PDP10_ALIAS(NAME) PDP10_ALIAS_IS_NOT_SUPPORTED_BY_KCC
#elif defined(__GNUC__) && defined(__pdp10__)
#define PDP10_UNUSED __attribute__ ((unused))
#define PDP10_NOINLINE __attribute__ ((noinline))
#define PDP10_NORETURN __attribute__ ((noreturn))
#define PDP10_PACKED __attribute__ ((packed))
#define PDP10_ALIGNED(N) __attribute__ ((aligned (N)))
#define PDP10_WEAK __attribute__ ((weak))
#define PDP10_ALIAS(NAME) __attribute__ ((alias (NAME)))
#endif

#endif
