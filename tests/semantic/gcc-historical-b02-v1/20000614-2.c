/* GCC historical: union of one 36-bit word and four 9-bit C bytes.
 * See docs/GCC-C-BATCH02-REVIEW-20261117-v1.md for the
 * exact source-level oracle, target gating, and compiler scope.
 */

extern void abort (void);
extern void exit (int);

char buf[8];
static volatile unsigned int batch02_seed;

void bar(char *p)
{
}

int main()
{
  union {
    unsigned int val;
    unsigned char p[4];
  } serial;

  int i;
  serial.val = 0;
  for (i = 0; i < 8; ++i)
    buf[i] = (char)batch02_seed;
  bar(buf);
  for(i = 0; i < 8; i += 4)
    {
      serial.p [0] += buf [i + 0];
      serial.p [1] += buf [i + 1];
      serial.p [2] += buf [i + 2];
      serial.p [3] += buf [i + 3];
    }
  if (serial.val)
    abort();
  exit(0);
}
