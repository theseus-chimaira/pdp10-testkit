/* A 36-bit target field must not be masked with a host 32-bit int. */
struct fields {
    unsigned int u32:32;
    signed int s32:32;
    unsigned int u35:35;
    signed int s35:35;
    unsigned int u36:36;
    signed int s36:36;
};
static volatile struct fields x = {
    0x87654321UL, -1234567L, 0377777777777UL, -123456789L,
    0777777777777UL, -34359738368L
};
int main(void)
{
    if (x.u32 != 0x87654321UL) return 1;
    if (x.s32 != -1234567L) return 2;
    if (x.u35 != 0377777777777UL) return 3;
    if (x.s35 != -123456789L) return 4;
    if (x.u36 != 0777777777777UL) return 5;
    if (x.s36 != -34359738368L) return 6;
    return 0;
}
