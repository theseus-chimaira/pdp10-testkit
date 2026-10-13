struct extent {
        unsigned long span;
        unsigned long meta;
};

extern unsigned int find_slot(unsigned long);
extern unsigned int extent_count;
extern struct extent extents[];
extern void coalesce(unsigned int);

int
gcc_scalar_move_order_v39(unsigned long base, unsigned int type,
                          unsigned int owner)
{
        unsigned int i;
        struct extent *e;
        unsigned long m;

        i = find_slot(base);
        if (i >= extent_count)
                return -4;
        e = &extents[i];
        m = e->meta;
        if (((unsigned int)(m >> 18) & 7U) != type ||
            ((unsigned int)m & 0377U) != owner)
                return -4;
        e->meta = 0;
        coalesce(i);
        return 0;
}
