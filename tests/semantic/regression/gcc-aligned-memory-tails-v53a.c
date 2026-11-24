/* Word-aligned memory builtins count nine-bit C characters, not
   exact16 elements. Check the tail, adjacent storage and return value.
   The volatile character views provide independent bytewise oracles. */
#include <string.h>

static unsigned int dst[24], src[24];
static volatile unsigned char *d = (unsigned char *)dst;
static volatile unsigned char *s = (unsigned char *)src;
static volatile unsigned int calls;
volatile unsigned int fail_id;

static unsigned int *get_dst(void) __attribute__((noinline));
static unsigned int *get_src(void) __attribute__((noinline));

static unsigned int *get_dst(void)
{
    ++calls;
    return dst + 1;
}

static unsigned int *get_src(void)
{
    ++calls;
    return src + 1;
}

static void reset(void)
{
    unsigned int i;
    for (i = 0; i < sizeof(dst); ++i) {
        d[i] = 0252;
        s[i] = (i * 13 + 0400) & 0777;
    }
    calls = 0;
}

static int check(unsigned int n, int copy, unsigned int fill)
{
    unsigned int i, expected;
    for (i = 0; i < sizeof(dst); ++i) {
        expected = 0252;
        if (i >= 4 && i < n + 4)
            expected = copy ? s[i] : fill;
        if (d[i] != expected)
            return 0;
        if (s[i] != ((i * 13 + 0400) & 0777))
            return 0;
    }
    return 1;
}

#define CHECK_COPY(N) do { \
    reset(); \
    if (memcpy(get_dst(), get_src(), (N)) != (void *)(dst + 1) \
        || calls != 2 || !check((N), 1, 0)) { \
        fail_id = 100 + (N); return 1; \
    } \
} while (0)

#define CHECK_FILL(N, V, ID) do { \
    reset(); \
    if (memset(get_dst(), (V), (N)) != (void *)(dst + 1) \
        || calls != 1 || !check((N), 0, (V) & 0777)) { \
        fail_id = (ID) + (N); return 1; \
    } \
} while (0)

static unsigned char scalar = 0123;

int main(void)
{
    CHECK_COPY(0); CHECK_COPY(1); CHECK_COPY(2); CHECK_COPY(3);
    CHECK_COPY(4); CHECK_COPY(5); CHECK_COPY(6); CHECK_COPY(7);
    CHECK_COPY(12); CHECK_COPY(15); CHECK_COPY(16); CHECK_COPY(17);
    CHECK_COPY(18); CHECK_COPY(19); CHECK_COPY(80);
    CHECK_FILL(0, 0, 200); CHECK_FILL(1, 0, 200);
    CHECK_FILL(2, 0, 200); CHECK_FILL(3, 0, 200);
    CHECK_FILL(4, 0, 200); CHECK_FILL(17, 0, 200);
    CHECK_FILL(1, 0400, 300); CHECK_FILL(2, 0400, 300);
    CHECK_FILL(3, 0400, 300); CHECK_FILL(4, 0400, 300);
    CHECK_FILL(17, 0400, 300); CHECK_FILL(18, 0777, 400);
    CHECK_FILL(19, -2, 500); CHECK_FILL(80, 0777, 400);
    if (memset(&scalar, 0321, 1) != &scalar || scalar != 0321) {
        fail_id = 600; return 1;
    }
    return 0;
}
