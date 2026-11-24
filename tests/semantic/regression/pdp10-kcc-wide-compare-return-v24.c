/* KCC v24: a wide relational true edge can reach an early return.
 *
 * The generated 71-bit comparison finishes with a raw JUMPN that
 * skips the following buffered JRST.  The optimizer must not mistake
 * that JRST for an unconditional control transfer and delete the
 * reachable return statement.  The two 36-bit words of the address
 * comparison must both participate in the condition.
 *
 * C89 source, using GCC/KCC's native unsigned long long extension.
 */

typedef unsigned long long wide_addr_v24;

struct range_v24 {
  wide_addr_v24 first;
  wide_addr_v24 last;
};

struct range_set_v24 {
  int count;
  struct range_v24 *entry[2];
};

static struct range_set_v24 *
find_v24 (wide_addr_v24 pc, struct range_set_v24 *set)
{
  register struct range_v24 *entry;
  register int index = 0;

  while (index >= 0)
    {
      entry = set->entry[index];
      if (entry->last > pc)
        return set;
      --index;
    }
  return (struct range_set_v24 *) 0;
}

int
main (void)
{
  struct range_v24 below = { 0, 0200000 };
  struct range_v24 above = { 0200000, 0400000 };
  struct range_set_v24 set = { 2, { &below, &above } };

  if (find_v24 (02400, &set) != &set)
    return 1;
  if (find_v24 (0500000, &set) != (struct range_set_v24 *) 0)
    return 2;
  return 0;
}
