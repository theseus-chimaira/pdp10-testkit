# Width classification: sixth eight-test batch (2026-10-14, v9)

Eight consecutive `review-width` manifest entries were evaluated on PDP-6
using installed KCC and GCC `-O0`. No source or compiler code was changed.
Non-ICE compiler/runtime failures were recorded without investigation.

| Test | KCC PDP-6 | GCC PDP-6 -O0 | Decision |
| --- | --- | --- | --- |
| `cmpdi-1.c` | Runtime fail | Runtime fail | Deferred; already includes 71/72-bit PDP-10 comparison data |
| `cmpsi-1.c` | PASS | PASS | Active; sign-boundary masks follow 36-bit type width |
| `conversion.c` | Runtime fail | Link fail: `__fixunssfsi` | Deferred; integer/floating conversion coverage |
| `cvt-1.c` | Runtime fail | PASS | Deferred; double-to-long conversions |
| `divconst-2.c` | Runtime fail | PASS | Deferred; fixed divisor remains representable on PDP-10 |
| `lshrdi-1.c` | PASS | PASS | Active; already contains 71/72-bit PDP-10 logical shifts |
| `nestfunc-3.c` | Compile rejection | Run not confirmed | Extension review; GNU nested functions and trampolines |
| `pdp10/930106-1.c` | Runtime fail | PASS | Deferred; large automatic array and double return value |

The extension-only case was transferred to `review-extension`, not silently
discarded or treated as a width regression. Both activated cases retain their
upstream assertions unchanged. Only PDP-6 KCC and GCC `-O0` passes have
been demonstrated; additional matrix profiles remain pending.
