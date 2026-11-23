/* Link-only client: require the genuine DAIMOS console ABI symbols. */
#include <p10stdio-daimos-v1.h>

int main(void)
{
    int n = printf("GCC DAIMOS %d %s\n", 1, "OK");
    if (n < 0 || putchar('!') < 0 || puts("done") < 0)
        return 1;
    return 0;
}
