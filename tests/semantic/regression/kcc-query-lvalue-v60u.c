/* Addressable conditional lvalues, including the omitted true arm. */
static int a, b, calls;
static int data[3] = { 7, 0, 9 };
static int *get(int i) { ++calls; return &data[i]; }
struct S { int a, b; };
int main(void)
{
    volatile int select = 1;
    volatile int v = 12, w = 17;
    char c = 5, d = 6;
    int i = 0;
    register int r = 3, z = 4;
    int *p;
    struct S x = { 11, 12 }, y = { 21, 22 };
    a = 1; b = 2;
    (select ? a : b) = 31;
    if (a != 31 || b != 2) return 1;
    select = 0;
    (select ? a : b) += 7;
    if (b != 9 || a != 31) return 2;
    if (++(select ? a : b) != 10 || b != 10) return 3;
    if ((select ? c : d)++ != 6 || d != 7 || c != 5) return 4;
    p = &(select ? a : b);
    if (p != &b) return 5;
    (select ? x : y).b = 44;
    if (x.b != 12 || y.b != 44) return 6;
    (select ? v : w) = 51;
    if (v != 12 || w != 51) return 7;
    (a ?: b) = 18;
    if (a != 18 || b != 10) return 8;
    a = 0;
    (a ?: b) = 29;
    if (a != 0 || b != 29) return 9;
    (data[i++] ?: b) = 41;
    if (i != 1 || data[0] != 41 || b != 29) return 10;
    (*get(1) ?: b) = 55;
    if (calls != 1 || data[1] != 0 || b != 55) return 11;
    (*get(2) ?: b) = 66;
    if (calls != 2 || data[2] != 66 || b != 55) return 12;
    (select ? a : (select ? b : data[1])) = 77;
    if (data[1] != 77) return 13;
    if (sizeof(select ? c : d) != sizeof(int)) return 14;
    (select ? r : z) = 19;
    if (r != 3 || z != 19) return 15;
    return 0;
}
