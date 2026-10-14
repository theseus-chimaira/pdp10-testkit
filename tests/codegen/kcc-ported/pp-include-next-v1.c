/* codegen-kcc-preprocess: "source" */
/* codegen-kcc-extra: "-Isupport/kcc/include-next-v1/first" "-Isupport/kcc/include-next-v1/second" "-Isupport/kcc/include-next-v1/third" */
/* codegen-require-regex: "include_next_v1_ok" */

/* Both angled and quoted forms must continue AFTER their own -I path.
 * In particular, the final-line include_next in a small header must not
 * lose its origin when the preprocessor reads past the header's EOF.
 */
#include <chain-v1.h>

#if CHAIN_FIRST_V1 != 11 || CHAIN_SECOND_V1 != 22 || CHAIN_THIRD_V1 != 33
#error include_next did not traverse all three include directories
#endif
#if RESTART_FIRST_V1 != 41 || RESTART_SECOND_V1 != 42 || RESTART_THIRD_V1 != 43
#error include_next lost the parent path after nested includes
#endif

#if 0
#include_next <header-which-must-not-be-opened-v1.h>
#endif

int include_next_v1_ok(void)
{
    return CHAIN_FIRST_V1 + CHAIN_SECOND_V1 + CHAIN_THIRD_V1 +
           RESTART_FIRST_V1 + RESTART_SECOND_V1 + RESTART_THIRD_V1;
}
