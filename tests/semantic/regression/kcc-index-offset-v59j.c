/* KCC native local-word addressing regression, not portable ISO C.
   A local PDP-10 effective address uses the low 18 bits of the
   index calculation.  Exercise full-word offsets without reserving
   a whole address space or dereferencing an unmapped address. */
static int words[4] = { 11, 22, 33, 44 };

static int read_large(int *p) { return p[01000001L]; }
static int read_negative(int *p) { return p[-01000001L]; }
static int read_boundary(int *p) { return p[0777777L]; }
static int read_small(int *p) { return p[1]; }
static void write_large(int *p, int value) { p[01000002L] = value; }
static void write_negative(int *p, int value) { p[-01000001L] = value; }

int main(void)
{
    if (read_large(words) != 22) return 1;
    if (read_negative(words + 2) != 22) return 2;
    if (read_boundary(words + 1) != 11) return 3;
    if (read_small(words) != 22) return 4;
    write_large(words, 57);
    if (words[2] != 57) return 5;
    write_negative(words + 3, 73);
    if (words[2] != 73 || words[0] != 11 || words[1] != 22 ||
        words[3] != 44) return 6;
    return 0;
}
