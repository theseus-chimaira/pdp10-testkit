/* Historical GCC compile-only regression: const pointer (not const pointee) and byte-store compile lowering.
 * Oracle, options, and KCC applicability: GCC-C-BATCH04-REVIEW-20261117-v1.md.
 */

char *const f(void)
{
        char *const line = "/dev/ptyXX";
        line[8] = 1;
        return line;
}
