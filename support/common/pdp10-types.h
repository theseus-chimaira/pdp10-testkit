#ifndef PDP10_TYPES_V1_H
#define PDP10_TYPES_V1_H

/* Shared PDP-10 integer types for KCC and PDP-10 GCC. */
#if defined(__COMPILER_KCC__)

typedef signed _KCCtype_char6 pdp10_int6_t;
typedef unsigned _KCCtype_char6 pdp10_uint6_t;
typedef signed _KCCtype_char7 pdp10_int7_t;
typedef unsigned _KCCtype_char7 pdp10_uint7_t;
typedef signed _KCCtype_char8 pdp10_int8_t;
typedef unsigned _KCCtype_char8 pdp10_uint8_t;
typedef signed _KCCtype_char9 pdp10_int9_t;
typedef unsigned _KCCtype_char9 pdp10_uint9_t;
typedef signed _KCCtype_char18 pdp10_int18_t;
typedef unsigned _KCCtype_char18 pdp10_uint18_t;
typedef signed _KCCtype_char16 pdp10_int16_t;
typedef unsigned _KCCtype_char16 pdp10_uint16_t;
typedef signed _KCCtype_int32 pdp10_int32_t;
typedef unsigned _KCCtype_int32 pdp10_uint32_t;

#define PDP10_HAVE_EXACT_INT6 1
#define PDP10_HAVE_EXACT_INT7 1
#define PDP10_HAVE_EXACT_INT8 1
#define PDP10_HAVE_EXACT_INT9 1
#define PDP10_HAVE_EXACT_INT18 1
#define PDP10_HAVE_EXACT_INT16 1
#define PDP10_HAVE_EXACT_INT32 1

/* Explicitly widened adapters. These names never promise exact storage. */
typedef int pdp10_word16_t;
typedef unsigned int pdp10_uword16_t;
typedef int pdp10_word18_t;
typedef unsigned int pdp10_uword18_t;
typedef int pdp10_word32_t;
typedef unsigned int pdp10_uword32_t;

/* KCC/GCC exact-width names promise value precision, not identical C
 * address-unit layout.  KCC char16/char18 objects each have sizeof 1,
 * while GCC size(16)/size(18) objects occupy two 9-bit C address units.
 * Do not pass pointers to these exact-width objects, or aggregates whose
 * layout depends on them, directly between the compilers.  Use the word
 * adapters below at an interoperability boundary.
 */


#elif defined(__GNUC__) && defined(__pdp10__)

typedef int pdp10_int6_t __attribute__ ((size (6)));
typedef unsigned int pdp10_uint6_t __attribute__ ((size (6)));
typedef int pdp10_int7_t __attribute__ ((size (7)));
typedef unsigned int pdp10_uint7_t __attribute__ ((size (7)));
typedef int pdp10_int8_t __attribute__ ((size (8)));
typedef unsigned int pdp10_uint8_t __attribute__ ((size (8)));
typedef int pdp10_int9_t __attribute__ ((size (9)));
typedef unsigned int pdp10_uint9_t __attribute__ ((size (9)));
typedef int pdp10_int16_t __attribute__ ((size (16)));
typedef unsigned int pdp10_uint16_t __attribute__ ((size (16)));
typedef int pdp10_int18_t __attribute__ ((size (18)));
typedef unsigned int pdp10_uint18_t __attribute__ ((size (18)));
typedef int pdp10_int32_t __attribute__ ((size (32)));
typedef unsigned int pdp10_uint32_t __attribute__ ((size (32)));

#define PDP10_HAVE_EXACT_INT6 1
#define PDP10_HAVE_EXACT_INT7 1
#define PDP10_HAVE_EXACT_INT8 1
#define PDP10_HAVE_EXACT_INT9 1
#define PDP10_HAVE_EXACT_INT18 1
#define PDP10_HAVE_EXACT_INT16 1
#define PDP10_HAVE_EXACT_INT32 1

typedef int pdp10_word16_t;
typedef unsigned int pdp10_uword16_t;
typedef int pdp10_word18_t;
typedef unsigned int pdp10_uword18_t;
typedef int pdp10_word32_t;
typedef unsigned int pdp10_uword32_t;


#else
#error Unsupported PDP-10 compiler
#endif

/* Exact-width value limits and constant constructors. */
#define PDP10_INT6_MIN (-040)
#define PDP10_INT6_MAX 037
#define PDP10_UINT6_MAX 077U
#define PDP10_INT7_MIN (-0100)
#define PDP10_INT7_MAX 077
#define PDP10_UINT7_MAX 0177U
#define PDP10_INT8_MIN (-0200)
#define PDP10_INT8_MAX 0177
#define PDP10_UINT8_MAX 0377U
#define PDP10_INT9_MIN (-0400)
#define PDP10_INT9_MAX 0377
#define PDP10_UINT9_MAX 0777U
#define PDP10_INT18_MIN (-0400000)
#define PDP10_INT18_MAX 0377777
#define PDP10_UINT18_MAX 0777777U

#define PDP10_INT6_C(V) (V)
#define PDP10_UINT6_C(V) (V##U)
#define PDP10_INT7_C(V) (V)
#define PDP10_UINT7_C(V) (V##U)
#define PDP10_INT8_C(V) (V)
#define PDP10_UINT8_C(V) (V##U)
#define PDP10_INT9_C(V) (V)
#define PDP10_UINT9_C(V) (V##U)
#define PDP10_INT18_C(V) (V)
#define PDP10_UINT18_C(V) (V##U)

/* Explicit word-register adapters for exact-width values whose native
 * address-unit layout differs between KCC and GCC. */
#define PDP10_I16_TO_WORD(V) ((pdp10_word16_t)(V))
#define PDP10_U16_TO_WORD(V) ((pdp10_uword16_t)(V))
#define PDP10_I18_TO_WORD(V) ((pdp10_word18_t)(V))
#define PDP10_U18_TO_WORD(V) ((pdp10_uword18_t)(V))
#define PDP10_I16_FROM_WORD(V) ((pdp10_int16_t)(V))
#define PDP10_U16_FROM_WORD(V) ((pdp10_uint16_t)(V))
#define PDP10_I18_FROM_WORD(V) ((pdp10_int18_t)(V))
#define PDP10_U18_FROM_WORD(V) ((pdp10_uint18_t)(V))

#endif
