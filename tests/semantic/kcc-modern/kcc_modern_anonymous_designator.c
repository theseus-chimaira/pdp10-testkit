volatile int __test_exit;

struct anonymous_designator_v7 {
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

static struct anonymous_designator_v7 g_v7 = {
    .x = 3,
    .y = 4,
    .b = 5
};

int main(void)
{
    struct anonymous_designator_v7 q = { .x = 6, .z = 7, .b = 8 };
    if (g_v7.x != 3) return 1;
    if (g_v7.y != 4) return 2;
    if (g_v7.b != 5) return 3;
    if (q.x != 6) return 4;
    if (q.y != 7) return 5;
    if (q.b != 8) return 6;
    return 0;
}
