#include "insns.h"

/*
 * SPECIAL CASE: inline-assembly smoke test.
 *
 * JFCL/JFOV/JCRY* operate on the PDP-6/PDP-10 arithmetic flags.
 * Plain C has no portable semantic way to read, clear, or branch on
 * those flags directly.  Therefore this file is intentionally not a
 * normal C-to-insn recognition test.
 *
 * Purpose of this file:
 *   - verify that PDP-10 inline assembly in C compiles
 *   - verify that the assembler accepts JFCL-family mnemonics/forms
 *   - keep a small insn-level placeholder for the flags/jump family
 *
 * Do not treat this as proof that the C backend can derive JFCL from
 * ordinary C expressions.  Real backend-generated JFCL/JCRY/JOV usage
 * should be tested later through multiword arithmetic, overflow/carry
 * lowering, or dedicated assembler/opcode tests.
 *
 * The local numeric labels below are deliberately used inside each asm
 * block so that repeated inlining or multiple functions do not create
 * ordinary global-label collisions.
 */


static Sint
jfcl_direct_0(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 0,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_1(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 1,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_2(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 2,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_3(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 3,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_4(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 4,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_5(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 5,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_6(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 6,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_7(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 7,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_10(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 10,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_11(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 11,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_12(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 12,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_13(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 13,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_14(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 14,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_15(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 15,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_16(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 16,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_direct_17(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 17,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

/*
 * Alias mnemonics.  These are intentionally assembler-facing tests.
 * If the assembler does not support one of these aliases yet, this file
 * should fail until the assembler/opcode table is taught the alias or
 * the test expectation is adjusted.
 */

static Sint
jfcl_alias_jfov(x)
Sint x;
{
  __asm__ __volatile__ (
    "jfov 1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_alias_jcry1(x)
Sint x;
{
  __asm__ __volatile__ (
    "jcry1 1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_alias_jcry0(x)
Sint x;
{
  __asm__ __volatile__ (
    "jcry0 1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_alias_jcry(x)
Sint x;
{
  __asm__ __volatile__ (
    "jcry 1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_alias_jov(x)
Sint x;
{
  __asm__ __volatile__ (
    "jov 1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

/*
 * A few ordinary C wrappers around the inline asm.  These keep values
 * live across the asm and make sure inline assembly behaves correctly
 * in simple expression/control-flow contexts.
 */

static Sint
jfcl_before_add(x, y)
Sint x;
Sint y;
{
  __asm__ __volatile__ (
    "jfcl 0,1f\n"
    "1:"
    :
    :
    : "memory");

  return x + y;
}

static Sint
jfcl_after_add(x, y)
Sint x;
Sint y;
{
  x += y;

  __asm__ __volatile__ (
    "jfcl 0,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_between_ops(x, y)
Sint x;
Sint y;
{
  x += y;

  __asm__ __volatile__ (
    "jfcl 0,1f\n"
    "1:"
    :
    :
    : "memory");

  return x ^ y;
}

static Sint
jfcl_in_branch(x, y)
Sint x;
Sint y;
{
  if (x < y) {
    __asm__ __volatile__ (
      "jfcl 0,1f\n"
      "1:"
      :
      :
      : "memory");
    return x;
  }

  return y;
}

static Sint
jfcl_in_loop(n, x)
Sint n;
Sint x;
{
  while (n-- > 0) {
    __asm__ __volatile__ (
      "jfcl 0,1f\n"
      "1:"
      :
      :
      : "memory");
    ++x;
  }

  return x;
}

static void
jfcl_store_after(p, x)
Sint *p;
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 0,1f\n"
    "1:"
    :
    :
    : "memory");

  *p = x;
}

static Sint
jfcl_load_before(p)
Sint *p;
{
  Sint x;

  x = *p;

  __asm__ __volatile__ (
    "jfcl 0,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static Sint
jfcl_volatile_load(p)
volatile Sint *p;
{
  Sint x;

  x = *p;

  __asm__ __volatile__ (
    "jfcl 0,1f\n"
    "1:"
    :
    :
    : "memory");

  return x;
}

static void
jfcl_volatile_store(p, x)
volatile Sint *p;
Sint x;
{
  __asm__ __volatile__ (
    "jfcl 0,1f\n"
    "1:"
    :
    :
    : "memory");

  *p = x;
}
