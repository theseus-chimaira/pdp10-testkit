/* GCC execute/20011128-1.c: partial static-size array initializer. */
int main(void)
{
    volatile char blah[33] = "01234567890123456789";
    if (blah[0] != '0' || blah[19] != '9')
        return 1;
    if (blah[20] != 0 || blah[32] != 0)
        return 2;
    return 0;
}
