volatile int __test_exit;

struct anonymous_v7_outer {
    int a;
    struct {
        int x;
        union {
            int y;
            unsigned int z;
        };
    };
    int b;
};

static struct anonymous_v7_outer g_v7 = { 7, { 3, { 4 } }, 5 };

int main(void)
{
    struct anonymous_v7_outer q = { 1, { 2, { 3 } }, 4 };

    if (q.a != 1) return 1;
    if (q.x != 2) return 2;
    if (q.y != 3) return 3;
    if (q.b != 4) return 4;

    q.x += q.y;
    if (q.x != 5) return 5;
    q.z = 6;
    if (q.y != 6) return 6;

    if (g_v7.x != 3) return 7;
    if (g_v7.y != 4) return 8;
    if (g_v7.b != 5) return 9;

    return 0;
}
