/* Both conventional target spellings must identify native PDP-10 C. */
#include <limits.h>
#if !defined(__PDP10__) || !defined(__pdp10__)
#error missing PDP-10 target identification
#endif
int main(void)
{
    return CHAR_BIT != 9 || sizeof(int) != 4;
}
