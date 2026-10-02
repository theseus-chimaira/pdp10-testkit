#include "insns.h"

/* GCC labels-as-values/computed-goto coverage split from PUSHJ.c. */
static Sint pushj_ga;
static Sint pushj_gb;

static void **
pushj_reg(p, f)
void **p;
void *f;
{
  *++p = &&label;
  goto *f;

label:
  return p;
}

static void **
pushj_reg_arg(p, f, x)
void **p;
void *f;
Sint x;
{
  pushj_ga = x;
  *++p = &&label;
  goto *f;

label:
  pushj_gb = x + 1;
  return p;
}

static void **
pushj_sym(p)
void **p;
{
  *++p = &&label;
  goto *(void *)pushj_reg;

label:
  return p;
}

static void **
pushj_sym_arg(p, x)
void **p;
Sint x;
{
  pushj_ga = x;
  *++p = &&label;
  goto *(void *)pushj_reg_arg;

label:
  return p;
}
