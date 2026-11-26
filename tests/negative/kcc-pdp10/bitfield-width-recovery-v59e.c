/* Diagnose malformed widths before laying out or constructing a type.
   Access each named member after the declaration to exercise recovery. */
struct invalid {
    unsigned int wide : 37;
    unsigned int zero : 0;
    unsigned int negative : -1;
    unsigned int huge : 4294967297ULL;
    unsigned int : 4294967297ULL;
};

void update(struct invalid *p)
{
    p->wide |= 1;
    p->zero |= 1;
    p->negative |= 1;
    p->huge |= 1;
}
