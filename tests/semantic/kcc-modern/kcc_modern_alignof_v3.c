volatile int __test_exit;

struct alignof_v3_s {
    char c;
    int i;
};

struct alignof_v3_p {
    char c;
    short s;
} __attribute__((packed));

int main(void)
{
    if (_Alignof(char) != 1) return 1;
    if (_Alignof(short) != 2) return 2;
    if (_Alignof(int) != 4) return 3;
    if (_Alignof(char[3]) != 4) return 4;
    if (_Alignof(struct alignof_v3_s) != 4) return 5;
    if (_Alignof(struct alignof_v3_p) != 1) return 6;
    return 0;
}
