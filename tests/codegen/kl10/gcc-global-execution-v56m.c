/* Native global data pointers, static offsets and a function pointer.
 * The link places code, initialized data and BSS in distinct sections.
 * Volatile accesses keep the load/store and call oracles observable. */
volatile char bytes[8] = { 1, 2, 3, 4, 5, 6, 7, 8 };
volatile short halves[4] = { 11, 12, 13, 14 };
volatile int words[3] = { 21, 22, 23 };
volatile char * volatile bp = bytes + 5;
volatile short * volatile hp = halves + 3;
volatile int * volatile wp = words + 1;
volatile int scratch;
static int callee(int x) { return x + 7; }
int (* volatile fp)(int) = callee;
int main(void)
{
    if (scratch != 0) return 1;
    if (*bp != 6 || *hp != 14 || *wp != 22) return 2;
    *bp = 27;
    *hp = 28;
    *wp = 29;
    if (bytes[5] != 27 || halves[3] != 28 || words[1] != 29) return 3;
    scratch = fp(*wp);
    if (scratch != 36) return 4;
    return 0;
}
