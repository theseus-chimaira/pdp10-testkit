#ifndef DAIMOS_LANGUAGE_V1_H
#define DAIMOS_LANGUAGE_V1_H

/* Shared DAIMOS language subset for KCC and PDP-10 GCC. */
#if defined(__COMPILER_KCC__)

typedef signed _KCCtype_char6 daimos_int6_t;
typedef unsigned _KCCtype_char6 daimos_uint6_t;
typedef signed _KCCtype_char7 daimos_int7_t;
typedef unsigned _KCCtype_char7 daimos_uint7_t;
typedef signed _KCCtype_char8 daimos_int8_t;
typedef unsigned _KCCtype_char8 daimos_uint8_t;
typedef signed _KCCtype_char9 daimos_int9_t;
typedef unsigned _KCCtype_char9 daimos_uint9_t;
typedef signed _KCCtype_char18 daimos_int18_t;
typedef unsigned _KCCtype_char18 daimos_uint18_t;
typedef signed _KCCtype_char16 daimos_int16_t;
typedef unsigned _KCCtype_char16 daimos_uint16_t;
typedef signed _KCCtype_int32 daimos_int32_t;
typedef unsigned _KCCtype_int32 daimos_uint32_t;

#define DAIMOS_HAVE_EXACT_INT6 1
#define DAIMOS_HAVE_EXACT_INT7 1
#define DAIMOS_HAVE_EXACT_INT8 1
#define DAIMOS_HAVE_EXACT_INT9 1
#define DAIMOS_HAVE_EXACT_INT18 1
#define DAIMOS_HAVE_EXACT_INT16 1
#define DAIMOS_HAVE_EXACT_INT32 1

/* Explicitly widened adapters. These names never promise exact storage. */
typedef int daimos_word16_t;
typedef unsigned int daimos_uword16_t;
typedef int daimos_word18_t;
typedef unsigned int daimos_uword18_t;
typedef int daimos_word32_t;
typedef unsigned int daimos_uword32_t;

/* KCC/GCC exact-width names promise value precision, not identical C
 * address-unit layout.  KCC char16/char18 objects each have sizeof 1,
 * while GCC size(16)/size(18) objects occupy two 9-bit C address units.
 * Do not pass pointers to these exact-width objects, or aggregates whose
 * layout depends on them, directly between the compilers.  Use the word
 * adapters below at an interoperability boundary.
 */

/* Attributes with implemented KCC semantics use their native spellings.
 * Linkage attributes that KCC cannot implement remain explicit failures.
 */
#define DAIMOS_UNUSED __attribute__ ((unused))
#define DAIMOS_NOINLINE __attribute__ ((noinline))
#define DAIMOS_NORETURN __attribute__ ((noreturn))
#define DAIMOS_PACKED __attribute__ ((packed))
#define DAIMOS_ALIGNED(N) __attribute__ ((aligned (N)))
#define DAIMOS_WEAK DAIMOS_WEAK_IS_NOT_SUPPORTED_BY_KCC
#define DAIMOS_ALIAS(NAME) DAIMOS_ALIAS_IS_NOT_SUPPORTED_BY_KCC

#else

typedef int daimos_int6_t __attribute__ ((size (6)));
typedef unsigned int daimos_uint6_t __attribute__ ((size (6)));
typedef int daimos_int7_t __attribute__ ((size (7)));
typedef unsigned int daimos_uint7_t __attribute__ ((size (7)));
typedef int daimos_int8_t __attribute__ ((size (8)));
typedef unsigned int daimos_uint8_t __attribute__ ((size (8)));
typedef int daimos_int9_t __attribute__ ((size (9)));
typedef unsigned int daimos_uint9_t __attribute__ ((size (9)));
typedef int daimos_int16_t __attribute__ ((size (16)));
typedef unsigned int daimos_uint16_t __attribute__ ((size (16)));
typedef int daimos_int18_t __attribute__ ((size (18)));
typedef unsigned int daimos_uint18_t __attribute__ ((size (18)));
typedef int daimos_int32_t __attribute__ ((size (32)));
typedef unsigned int daimos_uint32_t __attribute__ ((size (32)));

#define DAIMOS_HAVE_EXACT_INT6 1
#define DAIMOS_HAVE_EXACT_INT7 1
#define DAIMOS_HAVE_EXACT_INT8 1
#define DAIMOS_HAVE_EXACT_INT9 1
#define DAIMOS_HAVE_EXACT_INT18 1
#define DAIMOS_HAVE_EXACT_INT16 1
#define DAIMOS_HAVE_EXACT_INT32 1

typedef int daimos_word16_t;
typedef unsigned int daimos_uword16_t;
typedef int daimos_word18_t;
typedef unsigned int daimos_uword18_t;
typedef int daimos_word32_t;
typedef unsigned int daimos_uword32_t;

#define DAIMOS_UNUSED __attribute__ ((unused))
#define DAIMOS_NOINLINE __attribute__ ((noinline))
#define DAIMOS_NORETURN __attribute__ ((noreturn))
#define DAIMOS_PACKED __attribute__ ((packed))
#define DAIMOS_ALIGNED(N) __attribute__ ((aligned (N)))
#define DAIMOS_WEAK __attribute__ ((weak))
#define DAIMOS_ALIAS(NAME) __attribute__ ((alias (NAME)))

#endif

/* Exact-width value limits and constant constructors. */
#define DAIMOS_INT6_MIN (-040)
#define DAIMOS_INT6_MAX 037
#define DAIMOS_UINT6_MAX 077U
#define DAIMOS_INT7_MIN (-0100)
#define DAIMOS_INT7_MAX 077
#define DAIMOS_UINT7_MAX 0177U
#define DAIMOS_INT8_MIN (-0200)
#define DAIMOS_INT8_MAX 0177
#define DAIMOS_UINT8_MAX 0377U
#define DAIMOS_INT9_MIN (-0400)
#define DAIMOS_INT9_MAX 0377
#define DAIMOS_UINT9_MAX 0777U
#define DAIMOS_INT18_MIN (-0400000)
#define DAIMOS_INT18_MAX 0377777
#define DAIMOS_UINT18_MAX 0777777U

#define DAIMOS_INT6_C(V) (V)
#define DAIMOS_UINT6_C(V) (V##U)
#define DAIMOS_INT7_C(V) (V)
#define DAIMOS_UINT7_C(V) (V##U)
#define DAIMOS_INT8_C(V) (V)
#define DAIMOS_UINT8_C(V) (V##U)
#define DAIMOS_INT9_C(V) (V)
#define DAIMOS_UINT9_C(V) (V##U)
#define DAIMOS_INT18_C(V) (V)
#define DAIMOS_UINT18_C(V) (V##U)

/* Explicit word-register adapters for exact-width values whose native
 * address-unit layout differs between KCC and GCC. */
#define DAIMOS_I16_TO_WORD(V) ((daimos_word16_t)(V))
#define DAIMOS_U16_TO_WORD(V) ((daimos_uword16_t)(V))
#define DAIMOS_I18_TO_WORD(V) ((daimos_word18_t)(V))
#define DAIMOS_U18_TO_WORD(V) ((daimos_uword18_t)(V))
#define DAIMOS_I16_FROM_WORD(V) ((daimos_int16_t)(V))
#define DAIMOS_U16_FROM_WORD(V) ((daimos_uint16_t)(V))
#define DAIMOS_I18_FROM_WORD(V) ((daimos_int18_t)(V))
#define DAIMOS_U18_FROM_WORD(V) ((daimos_uint18_t)(V))

#endif
