/* KCC compatibility header for the PDP-10 compiler assembly tests.
 *
 * The normal GCC test-suite header uses GCC-only attributes:
 *   __attribute__((mode(QI)))
 *   __attribute__((size(9)))
 *   __builtin_expect
 * and compiler-specific builtin spellings.
 *
 * This shim lets KCC compile the shared test sources and emit PDP-10
 * assembler for comparison/inspection.  It is intentionally not an exact
 * semantic clone of every GCC machine mode.  DImode is the shared
 * normalized 71-bit long long model; TImode remains unsupported here.
 */
#ifndef DAIMON_KCC_INSNS_H
#define DAIMON_KCC_INSNS_H

#include "raw72.h"

/* KCC now parses GNU function attributes itself.  Leave __attribute__
 * visible so semantic attributes such as noreturn/noinline are preserved;
 * unsupported attributes are consumed by KCC's compatibility scanner.
 */

typedef signed _KCCtype_char9 Qint;
typedef signed _KCCtype_char18 Hint;
typedef int Sint;
typedef long long Dint;
typedef long Tint;

typedef signed _KCCtype_char9 sQint;
typedef unsigned _KCCtype_char9 uQint;
typedef unsigned _KCCtype_char18 uHint;
typedef unsigned int uSint;
typedef unsigned long long uDint;
typedef unsigned long uTint;

typedef float Sfloat;
typedef double Dfloat;

/* Shared tests use char6 as the signed six-bit scalar.  Keep this
 * compiler adapter semantically aligned with GCC; PDP10_PREFIX selects
 * tools, not C type signedness. */
typedef signed _KCCtype_char6 char6;
typedef signed _KCCtype_char6 int6;
typedef signed _KCCtype_char7 char7;
typedef signed _KCCtype_char7 int7;
typedef signed _KCCtype_char8 char8;
typedef signed _KCCtype_char8 int8;
typedef signed _KCCtype_char9 char9;
typedef signed _KCCtype_char9 int9;

typedef signed _KCCtype_char16 short16;
typedef signed _KCCtype_char16 int16;
typedef signed _KCCtype_char18 short18;
typedef signed _KCCtype_char18 int18;
typedef signed _KCCtype_int32 int32;
typedef int int36;
typedef long long int71_t;
#if defined(__LONG_LONG_72BIT__)
typedef long long int72_t;
#else
typedef raw72_t int72_t;
#endif
typedef int71_t int72; /* Obsolete compatibility alias; use int71_t. */

typedef unsigned _KCCtype_char6 uchar6;
typedef unsigned _KCCtype_char6 uint6;
typedef unsigned _KCCtype_char7 uchar7;
typedef unsigned _KCCtype_char7 uint7;
typedef unsigned _KCCtype_char8 uchar8;
typedef unsigned _KCCtype_char8 uint8;
typedef unsigned _KCCtype_char9 uchar9;
typedef unsigned _KCCtype_char9 uint9;

typedef unsigned _KCCtype_char16 ushort16;
typedef unsigned _KCCtype_char16 uint16;
typedef unsigned _KCCtype_char18 ushort18;
typedef unsigned _KCCtype_char18 uint18;
typedef unsigned _KCCtype_int32 uint32;
typedef unsigned int uint36;
typedef unsigned long long uint71_t;
#if defined(__LONG_LONG_72BIT__)
typedef unsigned long long uint72_t;
#else
typedef uraw72_t uint72_t;
#endif
typedef uint71_t uint72; /* Obsolete compatibility alias; use uint71_t. */

typedef struct { Hint l; Hint r; } H2int;
typedef struct { uHint l; uHint r; } uH2int;

#define OPAQUE_REG(X) ((X) = (X))

#define __builtin_abs(X) (((X) < 0) ? -(X) : (X))

extern char *memcpy();
extern char *memset();
extern char *kcc_alloca();
extern int kcc_ffs();
extern int kcc_jffo();

#define __builtin_memcpy memcpy
#define __builtin_memset memset
#define __builtin_alloca kcc_alloca
#define __builtin_ffs(X) kcc_ffs((Sint)(X))
#define __builtin_pdp10_jffo(X) kcc_jffo((uSint)(X))

typedef char *__builtin_va_list;
#define __builtin_va_start(AP, LAST) ((AP) = (char *)&(LAST))
#define __builtin_va_arg(AP, TYPE) (*(TYPE *)((AP) -= sizeof(TYPE)))
#define __builtin_va_end(AP) ((void)0)

#define ROTL(X, N) (((X) << (N)) + ((X) >> (36 - (N))))
#define ROTR(X, N) (((X) >> (N)) + ((X) << (36 - (N))))

#define ROTCL(X, N) (((X) << (N)) + ((X) >> (72 - (N))))
#define ROTCR(X, N) (((X) >> (N)) + ((X) << (72 - (N))))

#define SWAP(X) (((X) << 18) | ((X) >> 18))

#define MUL(X, Y) ((Dint)(X) * (Dint)(Y))
#define smul_highpart(X, Y) (MUL ((X), (Y)) >> 35)

#define BOTH(NAME, OP) \
  BOTH1 (Sint, NAME, OP)
#define BOTH1(T, NAME, OP) \
  BOTH2 (T, NAME##a, OP, a, *b)		BOTH2 (T, NAME##b, OP, *b, a)
#define BOTH2(T, NAME, OP, A, B) \
  BOTH3 (T, NAME##a, OP, A, B, a)	BOTH3 (T, NAME##b, OP, A, B, *b)
#define BOTH3(T, NAME, OP, A, B, C)		\
static T NAME (T a, T *b)			\
{						\
  A = OP;					\
  B = A;					\
  return C;					\
}

#define likely(x) (x)
#define unlikely(x) (x)

#endif /* DAIMON_KCC_INSNS_H */
