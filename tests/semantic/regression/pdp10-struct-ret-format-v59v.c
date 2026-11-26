/* Strengthen, do not edit, the historical struct-ret-1.c test.
 * Its direct/indirect comparison previously accepted two truncated strings.
 * Capture the real vsprintf return value at the same variadic boundary.
 */
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

static int format_count;
static int checked_sprintf(char *output, const char *format, ...)
{
    va_list ap;
    va_start(ap, format);
    format_count = vsprintf(output, format, ap);
    va_end(ap);
    return format_count;
}

#define sprintf checked_sprintf
#define main historical_main
#include "../../todo/generic/generic/struct-ret-1.c"
#undef main
#undef sprintf

volatile unsigned fail_id;
static const char expected[] =
    "X f(B,char,double,B):({0.1,{1,2,3}},'\177',0.3,{0.2,{5,4,3}})";

int main(void)
{
    X result;
    fail_id = 1;
    result = f(B1, c2, d3, B2);
    if (format_count != (int)strlen(expected) || strcmp(out, expected))
        return 1;
    fail_id = 2;
    if (strcmp(result.c, "return val") || result.c1 != c2)
        return 2;
    fail_id = 3;
    result = (*fp)(B1, c2, d3, B2);
    if (format_count != (int)strlen(expected) || strcmp(out, expected))
        return 3;
    fail_id = 4;
    if (strcmp(result.c, "return val") || result.c1 != c2)
        return 4;
    fail_id = 0;
    return 0;
}
