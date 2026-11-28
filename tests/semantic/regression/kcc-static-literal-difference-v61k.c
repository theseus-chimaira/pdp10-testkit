/* GNU literal subtraction may choose a shared literal object. The decoded
 * payload, extent and element type must agree. No global pooling contract. */
static volatile int offsets[] = {
    &"Foobar"[1] - &"Foobar"[0],
    ("abcdefgh" + 8) - ("abcd" "efgh" + 1),
    &"abcdef"[1] - &"abcdef"[5],
    ("a\000b" + 4) - "a\000b",
    ("\777\400x" + 2) - "\777\400x",
    (L"\x12345xyz" + 3) - L"\x12345xyz",
    (L"\x12345xyz" + 1) - (L"\x12345xyz" + 4),
    ((const char *)"abcde" + 4) - (const char *)"abcde"
};
static int diff(const char *a, const char *b) { return a - b; }
int main(void)
{
    static const char a[] = "abcdefgh";
    if (offsets[0] != 1 || offsets[1] != 7 || offsets[2] != -4) return 1;
    if (offsets[3] != 4 || offsets[4] != 2) return 2;
    if (offsets[5] != 3 || offsets[6] != -3 || offsets[7] != 4) return 3;
    if (diff(a + 8, a + 1) != offsets[1]) return 4;
    return 0;
}
