/* Original KCC instruction assertion migration. */
/* codegen-require-regex: "(?im)lsh\\s+[0-7]+,-0*32\\s*$" "(?im)lsh\\s+[0-7]+,0*32\\s*$" */
/* codegen-forbid-regex: "(?im)movei\\s+([0-7]+),0*32\\s*$" "(?im)movn\\s+[0-7]+,[0-7]+\\s*$" */
typedef unsigned long kword_t;

#define REFCNT_MASK 01777UL
#define REFCNT_SHIFT 26U

struct vnode {
    kword_t meta;
};

#define GET_REFCNT(p) \
    ((unsigned int)(((p)->meta >> REFCNT_SHIFT) & REFCNT_MASK))
#define SET_REFCNT(p, value) do { \
    (p)->meta = ((p)->meta & ~((kword_t)REFCNT_MASK << REFCNT_SHIFT)) | \
        (((kword_t)(value) & REFCNT_MASK) << REFCNT_SHIFT); \
} while (0)

int bump(struct vnode *p)
{
    SET_REFCNT(p, GET_REFCNT(p) + 1U);
    return 0;
}
