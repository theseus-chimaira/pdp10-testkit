/* Check the target limits and real buffered formatter at word boundaries. */
#include <limits.h>
#include <stdio.h>
#include <string.h>

volatile unsigned fail_id;
static char output[80];

int main(void)
{
    int (*volatile format)(char *, const char *, ...) = sprintf;
    int n;
    fail_id = 1;
    if ((unsigned long)INT_MAX != 0377777777777UL ||
        (unsigned long)INT_MIN != 0400000000000UL ||
        (unsigned long)LONG_MAX != 0377777777777UL ||
        (unsigned long)LONG_MIN != 0400000000000UL) return 1;
    fail_id = 2;
    n = (*format)(output, "%d %ld %lu", INT_MAX, LONG_MIN, ULONG_MAX);
    if (n != 36 || strcmp(output, "34359738367 -34359738368 68719476735"))
        return 2;
    fail_id = 3;
    n = snprintf(output, 6, "%#012lo", ULONG_MAX);
    if (n != 13 || strcmp(output, "07777")) return 3;
    fail_id = 4;
    n = snprintf(output, sizeof(output), "%.34359738368d", 1);
    if (n != -1 || output[0]) return 4;
    fail_id = 5;
    n = snprintf(output, sizeof(output), "%*d", INT_MIN, 1);
    if (n != -1 || output[0]) return 5;
    fail_id = 0;
    return 0;
}
