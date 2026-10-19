#ifndef PDP10_TESTKIT_STDBOOL_V1_H
#define PDP10_TESTKIT_STDBOOL_V1_H

/* C99 Boolean spellings.  _Bool must be implemented by the compiler;
 * these macros intentionally do not replace it with int or char.
 */
#define bool _Bool
#define true 1
#define false 0
#define __bool_true_false_are_defined 1

#endif
