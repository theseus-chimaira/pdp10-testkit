/* GCC must diagnose invalid aggregate layout and pointer arithmetic
   without crashing during static initializer or RTL error recovery.  */
struct missing;

struct record {
    int first;
    struct missing bad;
    int last;
};

static struct record rec = { 1, { 2, 3 }, 4 };

int test(struct missing *p)
{
    ++p;
    return rec.last;
}
