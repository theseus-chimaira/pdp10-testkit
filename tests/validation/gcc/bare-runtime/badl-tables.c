typedef int char7 __attribute__ ((size (7)));
typedef int char8 __attribute__ ((size (8)));
typedef int char18 __attribute__ ((size (18)));

char6 data6[32];
char7 data7[32];
char8 data8[32];
char data9[32];
char18 data18[32];

char6 * volatile p6;
char6 * volatile q6;
char7 * volatile p7;
char7 * volatile q7;
char8 * volatile p8;
char8 * volatile q8;
char * volatile p9;
char * volatile q9;
char18 * volatile p18;
char18 * volatile q18;

volatile int __test_exit;

#define CHECK_DIFF(A, P, Q, ID) do { \
        (P) = &(A)[19]; \
        (Q) = &(A)[4]; \
        if ((P) - (Q) != 15) { \
                __test_exit = (ID); \
                return __test_exit; \
        } \
        (Q) = &(A)[17]; \
        (P) = &(A)[2]; \
        if ((Q) - (P) != 15) { \
                __test_exit = (ID) + 10; \
                return __test_exit; \
        } \
} while (0)

int
main(void)
{
        __test_exit = 0;
        CHECK_DIFF(data6, p6, q6, 1);
        CHECK_DIFF(data7, p7, q7, 2);
        CHECK_DIFF(data8, p8, q8, 3);
        CHECK_DIFF(data9, p9, q9, 4);
        CHECK_DIFF(data18, p18, q18, 5);
        return 0;
}
