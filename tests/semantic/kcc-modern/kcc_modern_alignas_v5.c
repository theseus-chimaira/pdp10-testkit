volatile int __test_exit;

struct alignas_v5_s {
    char a;
    _Alignas(short) char b;
    char c;
    _Alignas(int) char d;
};

_Alignas(int) char alignas_v5_global;

int main(void)
{
    struct alignas_v5_s s;
    _Alignas(1) _Alignas(int) char local;

    if ((char *)&s.b - (char *)&s != 2) return 1;
    if ((char *)&s.d - (char *)&s != 4) return 2;
    (void)alignas_v5_global;
    (void)local;
    return 0;
}
