# DAIMOS wide integer data layout v1

## Measured common layout

KCC and GCC in normalized 71-bit mode agree on the following C object sizes.
The values are C addressable-character units and are written in PDP-10 octal:

| Object | `sizeof` |
|---|---:|
| `int` / one machine word | `04` |
| `int71_t` / `uint71_t` | `010` |
| `raw72_t` / `uraw72_t` | `010` |
| two adjacent wide values | `020` |
| `struct { int; int71_t; int; }` | `020` |

Thus both wide representations occupy two consecutive 36-bit words and the
measured structures introduce no extra padding between word-aligned members.
The normalized 71-bit and flat raw-72 representations remain semantically and
ABI-distinct even though their storage sizes agree.

## `sizeof` rule

Portable tests must express word counts relative to `sizeof(int)`.  They must
not compare a two-word object directly with integer constant 2, because PDP-10
C reports sizes in addressable character units rather than 36-bit words.

## Public interfaces

Public persistent formats should continue to use explicit high/low words.
Compiler bit fields remain outside this frozen layout until direction,
container selection, and cross-word allocation are measured separately.
