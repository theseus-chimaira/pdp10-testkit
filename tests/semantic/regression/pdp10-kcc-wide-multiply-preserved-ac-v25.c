/* KCC v25: keep preserved AC10 out of 71-bit multiply scratch pairs.
 *
 * This reduction preserves the register pressure and structure-pointer
 * lifetime of upstream 20001203-2.c.  The old optimized KCC chose
 * MUL AC7,operand, which also overwrites AC10.  AC10 is still holding
 * result_type across the multiplication.  A subsequent store through
 * that clobbered pointer corrupts the guest and prevents return.
 *
 * The obstack/field layout and zero-initialized local objects keep the
 * original C semantics and preserved-register allocation.  The unused
 * allocator functions are retained to keep the original call paths.
 * This is C89 apart from the compiler's supported long long extension.
 */

struct obstack
{
  long chunk_size;
  struct _obstack_chunk *chunk;
  char *object_base;
  char *next_free;
  char *chunk_limit;
  int alignment_mask;
  unsigned maybe_empty_object;
};

struct objfile
  {
    struct objfile *next;
    struct obstack type_obstack;
  };

struct type
  {
    unsigned length;
    struct objfile *objfile;
    short nfields;
    struct field
      {
        union field_location
          {
            int bitpos;
            unsigned long physaddr;
            char *physname;
          }
        loc;
        int bitsize;
        struct type *type;
        char *name;
      }
     *fields;
  };

struct type *alloc_type (void);
void * xmalloc (unsigned int z);
void _obstack_newchunk (struct obstack *o, int i);
void get_discrete_bounds (long long *lowp, long long *highp);

extern void *memset(void *, int, __SIZE_TYPE__);

struct type *
create_array_type (struct type *result_type, struct type *element_type)
{
  long long low_bound, high_bound;
  if (result_type == ((void *)0))
    {
      result_type = alloc_type ();
    }
  get_discrete_bounds (&low_bound, &high_bound);
  (result_type)->length =
    (element_type)->length * (high_bound - low_bound + 1);
  (result_type)->nfields = 1;
  result_type->fields = (struct field *) 0;
  return (result_type);
}

struct type *
alloc_type (void)
{
  abort ();
}
void * xmalloc (unsigned int z)
{
  return 0;
}
void _obstack_newchunk (struct obstack *o, int i)
{
  abort ();
}
void
get_discrete_bounds (long long *lowp, long long *highp)
{
  *lowp = 0;
  *highp = 2;
}

int main(void)
{
  struct type element_type;
  struct type result_type;

  memset (&element_type, 0, sizeof (struct type));
  memset (&result_type, 0, sizeof (struct type));
  element_type.length = 4;
  create_array_type (&result_type, &element_type);
  if (result_type.length != 12)
    abort ();
  exit (0);
}
