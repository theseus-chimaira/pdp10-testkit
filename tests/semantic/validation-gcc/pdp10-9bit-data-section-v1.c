/* GCC target regression: pending 9-bit data bytes must be flushed
 * before the next .text section directive.  C89, no OS dependencies.
 */
static char first[] = "abcdE";
static char second[] = "abcdefghI";

int
main(void)
{
    if (first[0] != 'a' || first[3] != 'd' || first[4] != 'E' ||
        first[5] != 0)
        return 1;
    if (second[0] != 'a' || second[3] != 'd' ||
        second[4] != 'e' || second[7] != 'h' ||
        second[8] != 'I' || second[9] != 0)
        return 2;
    return 0;
}
