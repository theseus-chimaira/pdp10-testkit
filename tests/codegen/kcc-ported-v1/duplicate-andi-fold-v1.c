/* Migrated KCC assembly assertions. */
/* codegen-require-regex: "(?ims)\\A(?:(?!^\\s*andi\\s+[0-7]+,0?777\\s*$).)*^\\s*andi\\s+[0-7]+,0?777\\s*$\\n(?:(?!^\\s*andi\\s+[0-7]+,0?777\\s*$).)*^\\s*andi\\s+[0-7]+,0?777\\s*$\\n(?:(?!^\\s*andi\\s+[0-7]+,0?777\\s*$).)*\\Z" */
/* codegen-forbid-regex: "(?im)^\\s*andi\\s+([0-7]+),0?777\\s*\\n\\s*andi\\s+\\1,0?777\\s*$" */
typedef unsigned long kword_t;

struct packed_proc {
    kword_t meta;
};

#define FIELD_MASK 0777UL
#define UID_SHIFT 18U
#define GID_SHIFT 27U
#define GET_UID(p) ((unsigned int)(((p)->meta >> UID_SHIFT) & FIELD_MASK))
#define GET_GID(p) ((unsigned int)(((p)->meta >> GID_SHIFT) & FIELD_MASK))
#define SET_CRED(p, uid, gid) ((p)->meta = \
    ((p)->meta & ((((kword_t)1U << UID_SHIFT) - 1U))) | \
    (((kword_t)(uid) & FIELD_MASK) << UID_SHIFT) | \
    (((kword_t)(gid) & FIELD_MASK) << GID_SHIFT))

void copy_cred(struct packed_proc *dst, const struct packed_proc *src)
{
    SET_CRED(dst, GET_UID(src), GET_GID(src));
}

unsigned long narrower_mask(unsigned long x)
{
    return (x & 07777UL) & 0777UL;
}
