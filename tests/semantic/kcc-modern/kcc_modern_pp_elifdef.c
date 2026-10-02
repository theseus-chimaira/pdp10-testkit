volatile int __test_exit;
volatile int fail_id;

#define PRESENT 1

#if 0
#elifdef PRESENT
#define FIRST 11
#else
#define FIRST 99
#endif

#if 0
#elifndef ABSENT
#define SECOND 13
#else
#define SECOND 99
#endif

#if 1
#define THIRD 17
#elifdef PRESENT
#define THIRD 99
#endif

#if 0
#elifdef ABSENT
#define FOURTH 99
#elifndef PRESENT
#define FOURTH 98
#else
#define FOURTH 19
#endif

int main(void)
{
    fail_id = 0;
    if (FIRST != 11) { fail_id = 1; return 1; }
    if (SECOND != 13) { fail_id = 2; return 1; }
    if (THIRD != 17) { fail_id = 3; return 1; }
    if (FOURTH != 19) { fail_id = 4; return 1; }
    return 0;
}
