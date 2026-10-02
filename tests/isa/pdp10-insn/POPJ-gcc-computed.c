#include "insns.h"

/* GCC labels-as-values/computed-goto coverage split from POPJ.c. */

static void
popj_computed_arg(p)
void **p;
{
  goto *p--;
}

static void
popj_computed_local(pp)
void ***pp;
{
  void **p;

  p = *pp;
  goto *p--;
}

static void
popj_computed_store(pp)
void ***pp;
{
  void **p;

  p = *pp;
  goto *p--;
}
