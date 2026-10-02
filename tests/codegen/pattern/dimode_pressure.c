#include "insns.h"

/*
 * DImode pressure coverage.
 *
 * Long long / Dint is avoidable for very early DAIMON, but this file
 * gives the backend a concrete regression target for register allocation
 * around double-word values:
 *
 *   DI moves across calls
 *   DI add/sub/xor/and/or with several live SI values
 *   DI stores and reloads
 *   DI branches under register pressure
 *   mixed DImode and SImode live ranges
 *   signed and unsigned DImode values
 *
 * This is not a full DImode arithmetic correctness suite.  It is a
 * pressure / reload / lifetime-shaping test.
 */

#ifndef OPAQUE_REG
#define OPAQUE_REG(x) __asm__ __volatile__ ("" : "=r" (x) : "0" (x))
#endif

extern void sink_int();
extern void sink_di();
extern void sink_udi();

static Dint gd0;
static Dint gd1;
static Dint gd2;
static Dint gd3;

static uDint gud0;
static uDint gud1;

static Dint gbuf[16];
static uDint gubuf[16];

struct di_pair {
  Dint a;
  Dint b;
};

struct udi_pair {
  uDint a;
  uDint b;
};

static struct di_pair gpair;
static struct udi_pair gupair;

static Dint
make_di(hi, lo)
Sint hi;
uSint lo;
{
  Dint r;

  r = (Dint)hi;
  r = r << 36;
  r += (Dint)lo;
  return r;
}

static uDint
make_udi(hi, lo)
uSint hi;
uSint lo;
{
  uDint r;

  r = (uDint)hi;
  r = r << 36;
  r += (uDint)lo;
  return r;
}

static Dint
mix_di(a, b, c, d, e, f)
Dint a;
Dint b;
int c;
int d;
int e;
int f;
{
  Dint x;
  Dint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  x = a + b;
  y = a - b;

  if (c != 0)
    x += (Dint)d;
  if (e != 0)
    y -= (Dint)f;

  return x ^ y;
}

static uDint
mix_udi(a, b, c, d, e, f)
uDint a;
uDint b;
int c;
int d;
int e;
int f;
{
  uDint x;
  uDint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  x = a + b;
  y = a ^ b;

  if (c != 0)
    x += (uDint)(uSint)d;
  if (e != 0)
    y -= (uDint)(uSint)f;

  return x ^ y;
}

static Dint
mix_di_many(a, b, c, d, e, f, g, h)
Dint a;
Dint b;
Dint c;
Dint d;
int e;
int f;
int g;
int h;
{
  Dint x;
  Dint y;
  Dint z;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);
  OPAQUE_REG(g);
  OPAQUE_REG(h);

  x = a + b;
  y = c - d;
  z = x ^ y;

  if (e != 0)
    z += (Dint)f;
  if (g != 0)
    z -= (Dint)h;

  return z + x + y;
}

static Dint
mix_di_constants(a, b, c)
Dint a;
Dint b;
int c;
{
  Dint k0;
  Dint k1;
  Dint x;

  k0 = make_di(0123456, 0654321);
  k1 = make_di(1, 0);

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(k0);
  OPAQUE_REG(k1);

  x = a + k0;
  if (c != 0)
    x += b;
  else
    x -= k1;

  return x ^ b;
}

static Dint
mix_di_shifts(a, b, c)
Dint a;
Dint b;
int c;
{
  Dint x;
  Dint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  x = a << 1;
  y = b << 18;

  if (c != 0)
    x += y;
  else
    x ^= y;

  return x;
}

static uDint
mix_udi_shifts(a, b, c)
uDint a;
uDint b;
int c;
{
  uDint x;
  uDint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  x = a >> 1;
  y = b << 18;

  if (c != 0)
    x += y;
  else
    x ^= y;

  return x;
}

static Dint
store_load_di(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  gd0 = a;
  gd1 = b;

  return gd0 + gd1;
}

static uDint
store_load_udi(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  gud0 = a;
  gud1 = b;

  return gud0 + gud1;
}

static Dint
store_load_three(a, b, c)
Dint a;
Dint b;
Dint c;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  gd0 = a;
  gd1 = b;
  gd2 = c;

  return gd0 + gd1 - gd2;
}

static Dint
store_load_array(a, b, i)
Dint a;
Dint b;
int i;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(i);

  gbuf[i & 017] = a;
  gbuf[(i + 1) & 017] = b;

  return gbuf[i & 017] + gbuf[(i + 1) & 017];
}

static uDint
store_load_uarray(a, b, i)
uDint a;
uDint b;
int i;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(i);

  gubuf[i & 017] = a;
  gubuf[(i + 1) & 017] = b;

  return gubuf[i & 017] ^ gubuf[(i + 1) & 017];
}

static Dint
store_load_struct(a, b)
Dint a;
Dint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  gpair.a = a;
  gpair.b = b;

  return gpair.a + gpair.b;
}

static uDint
store_load_ustruct(a, b)
uDint a;
uDint b;
{
  OPAQUE_REG(a);
  OPAQUE_REG(b);

  gupair.a = a;
  gupair.b = b;

  return gupair.a ^ gupair.b;
}

static Dint
store_load_local(a, b, c)
Dint a;
Dint b;
Dint c;
{
  Dint v[4];

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  v[0] = a;
  v[1] = b;
  v[2] = c;
  v[3] = v[0] + v[1];

  sink_di(v[3]);

  return v[3] - v[2];
}

static Dint
store_load_local_pressure(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
int d;
int e;
int f;
{
  Dint v[4];
  Dint x;
  Dint y;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s = d + e + f;
  x = a + (Dint)s;
  y = b - c;

  v[0] = x;
  v[1] = y;
  v[2] = x ^ y;
  v[3] = v[2] + (Dint)s;

  sink_di(v[3]);

  return v[0] + v[1] + v[2] + v[3];
}

static int
branch_di_pressure(a, b, c, d, e, f)
Dint a;
Dint b;
int c;
int d;
int e;
int f;
{
  Dint x;
  int s;

  x = mix_di(a, b, c, d, e, f);
  s = c + d + e + f;

  if (x < gd0)
    return s - 1;
  if (x == gd1)
    return s;
  return s + 1;
}

static int
branch_udi_pressure(a, b, c, d, e, f)
uDint a;
uDint b;
int c;
int d;
int e;
int f;
{
  uDint x;
  int s;

  x = mix_udi(a, b, c, d, e, f);
  s = c + d + e + f;

  if (x < gud0)
    return s - 1;
  if (x == gud1)
    return s;
  return s + 1;
}

static int
branch_di_all(a, b, c, d, e, f)
Dint a;
Dint b;
int c;
int d;
int e;
int f;
{
  Dint x;
  Dint y;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  x = a + (Dint)c + (Dint)d;
  y = b - (Dint)e - (Dint)f;
  s = c + d + e + f;

  if (x < y)
    return s - 1;
  if (x > y)
    return s + 1;
  return s;
}

static int
branch_udi_all(a, b, c, d, e, f)
uDint a;
uDint b;
int c;
int d;
int e;
int f;
{
  uDint x;
  uDint y;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  x = a + (uDint)(uSint)c + (uDint)(uSint)d;
  y = b - (uDint)(uSint)e - (uDint)(uSint)f;
  s = c + d + e + f;

  if (x < y)
    return s - 1;
  if (x > y)
    return s + 1;
  return s;
}

static int
branch_di_zero_pressure(a, b, c, d)
Dint a;
Dint b;
int c;
int d;
{
  Dint x;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  x = a - b;
  s = c + d;

  if (x < 0)
    return s - 1;
  if (x == 0)
    return s;
  return s + 1;
}

static int
branch_di_const_pressure(a, b, c, d)
Dint a;
Dint b;
int c;
int d;
{
  Dint x;
  Dint k;
  int s;

  k = make_di(1, 0);

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(k);

  x = a + b;
  s = c + d;

  if (x < k)
    return s - 1;
  if (x == k)
    return s;
  return s + 1;
}

static Dint
call_pressure_di(a, b, c, d)
Dint a;
Dint b;
int c;
int d;
{
  Dint x;
  Dint y;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  x = a + b;
  y = a - b;
  s = c + d;

  sink_int(s);
  sink_di(x);

  return x + y + (Dint)s;
}

static uDint
call_pressure_udi(a, b, c, d)
uDint a;
uDint b;
int c;
int d;
{
  uDint x;
  uDint y;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  x = a + b;
  y = a ^ b;
  s = c + d;

  sink_int(s);
  sink_udi(x);

  return x + y + (uDint)(uSint)s;
}

static Dint
call_between_di_ops(a, b, c, d)
Dint a;
Dint b;
int c;
int d;
{
  Dint x;
  Dint y;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  x = a + b;
  s = c + d;

  sink_di(x);
  sink_int(s);

  y = x - a + (Dint)s;
  return y ^ b;
}

static int
branch_after_call_di(a, b, c, d)
Dint a;
Dint b;
int c;
int d;
{
  Dint x;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  x = a + b;
  s = c + d;

  sink_di(x);
  sink_int(s);

  if (x < b)
    return s - 1;
  return s + 1;
}

static Dint
many_live_di_1(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
int e;
int f;
{
  Dint x0;
  Dint x1;
  Dint x2;
  Dint x3;
  int s0;
  int s1;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  s0 = e + f;
  s1 = e - f;

  x0 = a + b;
  x1 = c + d;
  x2 = a - c;
  x3 = b ^ d;

  if (s0 != 0)
    x0 += (Dint)s0;
  if (s1 != 0)
    x1 -= (Dint)s1;

  return x0 + x1 + x2 + x3;
}

static Dint
many_live_di_2(a, b, c, d, e, f, g, h)
Dint a;
Dint b;
Dint c;
Dint d;
int e;
int f;
int g;
int h;
{
  Dint x0;
  Dint x1;
  Dint x2;
  int s0;
  int s1;
  int s2;
  int s3;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);
  OPAQUE_REG(g);
  OPAQUE_REG(h);

  s0 = e + f;
  s1 = g + h;
  s2 = e - g;
  s3 = f - h;

  x0 = a + b + (Dint)s0;
  x1 = c - d + (Dint)s1;
  x2 = (x0 ^ x1) + (Dint)(s2 + s3);

  return x0 + x1 + x2;
}

static int
many_live_branch_di(a, b, c, d, e, f, g, h)
Dint a;
Dint b;
Dint c;
Dint d;
int e;
int f;
int g;
int h;
{
  Dint x0;
  Dint x1;
  Dint x2;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);
  OPAQUE_REG(g);
  OPAQUE_REG(h);

  x0 = a + b;
  x1 = c - d;
  x2 = x0 ^ x1;
  s = e + f + g + h;

  if (x2 < x0)
    return s - 1;
  if (x2 == x1)
    return s;
  return s + 1;
}

static Dint
array_pressure_di(v, n, seed)
Dint *v;
int n;
int seed;
{
  int i;
  Dint acc;
  Dint x;
  Dint y;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  acc = (Dint)seed;
  x = make_di(1, 0);
  y = make_di(0, 0123456);

  for (i = 0; i < n; ++i) {
    acc += v[i & 017];
    acc ^= x;
    acc -= y;
  }

  return acc;
}

static uDint
array_pressure_udi(v, n, seed)
uDint *v;
int n;
int seed;
{
  int i;
  uDint acc;
  uDint x;
  uDint y;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  acc = (uDint)(uSint)seed;
  x = make_udi(1, 0);
  y = make_udi(0, 0123456);

  for (i = 0; i < n; ++i) {
    acc += v[i & 017];
    acc ^= x;
    acc -= y;
  }

  return acc;
}

static int
array_branch_pressure_di(v, n, limit)
Dint *v;
int n;
Dint limit;
{
  int i;
  int count;
  Dint acc;

  OPAQUE_REG(n);
  OPAQUE_REG(limit);

  count = 0;
  acc = 0;

  for (i = 0; i < n; ++i) {
    acc += v[i & 017];
    if (acc < limit)
      ++count;
  }

  return count;
}

static int
array_branch_pressure_udi(v, n, limit)
uDint *v;
int n;
uDint limit;
{
  int i;
  int count;
  uDint acc;

  OPAQUE_REG(n);
  OPAQUE_REG(limit);

  count = 0;
  acc = 0;

  for (i = 0; i < n; ++i) {
    acc += v[i & 017];
    if (acc >= limit)
      ++count;
  }

  return count;
}

static Dint
struct_pressure_di(p, a, b, c)
struct di_pair *p;
Dint a;
Dint b;
int c;
{
  Dint x;
  Dint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  x = p->a + a;
  y = p->b - b;

  if (c != 0)
    p->a = x;
  else
    p->b = y;

  return p->a + p->b + x + y;
}

static uDint
struct_pressure_udi(p, a, b, c)
struct udi_pair *p;
uDint a;
uDint b;
int c;
{
  uDint x;
  uDint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  x = p->a + a;
  y = p->b ^ b;

  if (c != 0)
    p->a = x;
  else
    p->b = y;

  return p->a + p->b + x + y;
}

static Dint
conversion_pressure_di(a, b, c, d, e, f)
Dint a;
Dint b;
Sint c;
Sint d;
uSint e;
uSint f;
{
  Dint x;
  Dint y;
  Dint z;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  x = a + (Dint)c;
  y = b - (Dint)d;
  z = (Dint)e + (Dint)f;

  return x + y + z;
}

static uDint
uconversion_pressure_di(a, b, c, d, e, f)
uDint a;
uDint b;
Sint c;
Sint d;
uSint e;
uSint f;
{
  uDint x;
  uDint y;
  uDint z;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);

  x = a + (uDint)(uSint)c;
  y = b - (uDint)(uSint)d;
  z = (uDint)e + (uDint)f;

  return x + y + z;
}

static int
compare_store_pressure(a, b, p)
Dint a;
Dint b;
Dint *p;
{
  Dint x;
  int r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  x = a + b;
  *p = x;

  if (x < a)
    r = -1;
  else if (x == b)
    r = 0;
  else
    r = 1;

  sink_di(*p);
  return r;
}

static int
compare_store_pressure_udi(a, b, p)
uDint a;
uDint b;
uDint *p;
{
  uDint x;
  int r;

  OPAQUE_REG(a);
  OPAQUE_REG(b);

  x = a + b;
  *p = x;

  if (x < a)
    r = -1;
  else if (x == b)
    r = 0;
  else
    r = 1;

  sink_udi(*p);
  return r;
}

static Dint
pointer_pressure_di(pp, qq, a, b, c)
Dint **pp;
Dint **qq;
Dint a;
Dint b;
int c;
{
  Dint *p;
  Dint *q;
  Dint x;
  Dint y;

  p = *pp;
  q = *qq;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  x = *p + a;
  y = *q - b;

  if (c != 0)
    *p = x;
  else
    *q = y;

  return x + y + *p + *q;
}

static Dint
nested_call_pressure_di(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
int e;
int f;
{
  Dint x;
  Dint y;
  Dint z;

  x = mix_di(a, b, e, f, e + f, f - e);
  y = mix_di(c, d, f, e, f - e, e + f);
  z = x + y;

  sink_di(z);

  return z + x - y;
}

static int
nested_branch_pressure_di(a, b, c, d, e, f)
Dint a;
Dint b;
Dint c;
Dint d;
int e;
int f;
{
  Dint x;
  Dint y;
  int s;

  x = mix_di(a, b, e, f, e + f, f - e);
  y = mix_di(c, d, f, e, f - e, e + f);
  s = e + f;

  if (x < y)
    return s - 1;
  if (x == y)
    return s;
  return s + 1;
}

static Dint
global_mix_pressure(a, b, c, d)
Dint a;
Dint b;
int c;
int d;
{
  Dint x;
  Dint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  x = gd0 + a + (Dint)c;
  y = gd1 - b - (Dint)d;

  gd2 = x;
  gd3 = y;

  return gd2 ^ gd3;
}

static int
global_branch_pressure(a, b, c, d)
Dint a;
Dint b;
int c;
int d;
{
  Dint x;
  int s;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);

  x = gd0 + a - b;
  s = c + d;

  if (x < gd1)
    return s - 1;
  if (x == gd2)
    return s;
  return s + 1;
}

static Dint
volatile_pressure_di(p, q, a, b, c)
volatile Dint *p;
volatile Dint *q;
Dint a;
Dint b;
int c;
{
  Dint x;
  Dint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  x = *p + a;
  y = *q - b;

  if (c != 0)
    *p = x;
  else
    *q = y;

  return x + y;
}

static int
volatile_branch_pressure_di(p, q, a, b, c)
volatile Dint *p;
volatile Dint *q;
Dint a;
Dint b;
int c;
{
  Dint x;
  Dint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);

  x = *p + a;
  y = *q - b;

  if (x < y)
    return c - 1;
  if (x == y)
    return c;
  return c + 1;
}

static Dint
select_pressure_di(a, b, c, d, flag)
Dint a;
Dint b;
Dint c;
Dint d;
int flag;
{
  Dint x;
  Dint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(flag);

  x = a + b;
  y = c - d;

  if (flag)
    return x + y;
  return x - y;
}

static uDint
select_pressure_udi(a, b, c, d, flag)
uDint a;
uDint b;
uDint c;
uDint d;
int flag;
{
  uDint x;
  uDint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(flag);

  x = a + b;
  y = c ^ d;

  if (flag)
    return x + y;
  return x - y;
}

static Dint
loop_with_call_pressure(v, n, seed)
Dint *v;
int n;
int seed;
{
  int i;
  Dint acc;

  OPAQUE_REG(n);
  OPAQUE_REG(seed);

  acc = (Dint)seed;

  for (i = 0; i < n; ++i) {
    acc += v[i & 017];
    sink_int(i);
    sink_di(acc);
  }

  return acc;
}

static int
loop_branch_with_call_pressure(v, n, limit)
Dint *v;
int n;
Dint limit;
{
  int i;
  int c;
  Dint acc;

  OPAQUE_REG(n);
  OPAQUE_REG(limit);

  c = 0;
  acc = 0;

  for (i = 0; i < n; ++i) {
    acc += v[i & 017];
    sink_di(acc);
    if (acc < limit)
      ++c;
  }

  return c;
}

static Dint
spill_many_scalars_and_di(a, b, c, d, e, f, g, h)
Dint a;
Dint b;
int c;
int d;
int e;
int f;
int g;
int h;
{
  int s0;
  int s1;
  int s2;
  int s3;
  Dint x;
  Dint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);
  OPAQUE_REG(g);
  OPAQUE_REG(h);

  s0 = c + d;
  s1 = e + f;
  s2 = g + h;
  s3 = c - h;

  x = a + (Dint)s0 + (Dint)s1;
  y = b - (Dint)s2 + (Dint)s3;

  return x ^ y;
}

static int
spill_many_scalars_branch(a, b, c, d, e, f, g, h)
Dint a;
Dint b;
int c;
int d;
int e;
int f;
int g;
int h;
{
  int s0;
  int s1;
  int s2;
  int s3;
  Dint x;
  Dint y;

  OPAQUE_REG(a);
  OPAQUE_REG(b);
  OPAQUE_REG(c);
  OPAQUE_REG(d);
  OPAQUE_REG(e);
  OPAQUE_REG(f);
  OPAQUE_REG(g);
  OPAQUE_REG(h);

  s0 = c + d;
  s1 = e + f;
  s2 = g + h;
  s3 = c - h;

  x = a + (Dint)s0 + (Dint)s1;
  y = b - (Dint)s2 + (Dint)s3;

  if (x < y)
    return s0 - s1;
  if (x == y)
    return s2;
  return s3;
}
