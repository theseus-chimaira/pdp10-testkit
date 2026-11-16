/* GCC execute/20011126-2.c: loop iteration after GCSE. */
static const char *test(const char *in, char *out)
{
    while (1) {
        if (*in == 'a') {
            const char *p = in + 1;
            while (*p == 'x')
                ++p;
            if (*p == 'b')
                return p;
            while (in < p)
                *out++ = *in++;
        }
    }
}
int main(void)
{
    const char input[] = "aab";
    char out[4] = { 0, 0, 0, 0 };
    const char *end = test(input, out);
    if (end != input + 2)
        return 1;
    if (out[0] != 'a')
        return 2;
    return 0;
}
