/* One-word fields declared long long use the 36-bit target promotions.
** Check both static initialization and volatile cross-word writeback.
*/
struct fields {
    signed long long a:5;
    unsigned long long b:35;
    signed long long c:36;
    unsigned long long d:36;
    unsigned int tail:7;
};
static volatile struct fields x = {-7, 0377777777777ULL,
                                    -34359738368LL,
                                    0777777777777ULL, 0123};

int main(void)
{
    if (x.a != -7 || x.b != 0377777777777ULL ||
        x.c != -34359738368LL || x.d != 0777777777777ULL ||
        x.tail != 0123)
        return 1;
    x.a = 0;
    x.b = 0;
    x.c = 0;
    x.d = 0;
    if (x.a - 2 >= 0 || x.b - 2 >= 0 || x.c - 2 >= 0 ||
        x.d - 2 <= 0)
        return 2;
    x.a = -16LL;
    x.b = 0377777777777ULL;
    x.c = -1LL;
    x.d = 0777777777777ULL;
    if (x.a != -16 || x.b != 0377777777777ULL ||
        x.c != -1 || x.d != 0777777777777ULL || x.tail != 0123)
        return 3;
    return 0;
}
