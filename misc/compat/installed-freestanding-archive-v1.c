/* Operational PDP-6 libc archive extraction and callable ABI regression.
 * Keep the four calls real: no test stubs or substituted implementations.
 */
#include <string.h>

static char source[16] = "abcdef";
static char target[16];

int main(void)
{
    if (memcpy(target, source, 7) != target)
        return 1;
    if (strlen(target) != 6)
        return 2;
    if (strcmp(target, "abcdef") != 0)
        return 3;
    if (strstr(target, "cd") != target + 2)
        return 4;
    return 0;
}
