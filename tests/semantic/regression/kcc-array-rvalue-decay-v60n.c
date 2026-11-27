/* C99 array decay of aggregate values; consume pointers in full expression. */
struct small { char c[2]; };
struct large { int pad[4]; char c[3]; };
struct nested { struct small inner; int guard; };
static struct small a = {{11, 12}}, b = {{21, 22}}, out;
static struct large big = {{1, 2, 3, 4}, {31, 32, 33}};
static struct nested nest = {{{41, 42}}, 45};
static volatile int effects;
static struct small make_small(void) { ++effects; return a; }
static struct large make_large(void) { ++effects; return big; }
static struct nested make_nested(void) { ++effects; return nest; }
static int read_second(const char *p) { return p[1]; }
int main(void)
{
    volatile int choose = 1;
    effects = 0;
    if ((choose ? a : b).c[0] != 11) return 1;
    if (read_second((choose ? b : a).c) != 22) return 2;
    if ((++effects, b).c[1] != 22 || effects != 1) return 3;
    if (read_second((out = b).c) != 22 || out.c[0] != 21) return 4;
    if (make_small().c[0] != 11 || effects != 2) return 5;
    if (read_second(make_large().c) != 32 || effects != 3) return 6;
    if (make_nested().inner.c[0] != 41 || effects != 4) return 7;
    (void)make_small().c[0];
    if (effects != 5) return 8;
    if (read_second(make_small().c) + read_second(make_small().c) != 24
        || effects != 7) return 9;
    if (sizeof(make_small().c) != 2 || effects != 7) return 10;
    return 0;
}
