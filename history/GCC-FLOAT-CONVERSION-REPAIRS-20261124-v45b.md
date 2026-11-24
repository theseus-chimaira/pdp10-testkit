# GCC floating conversion repairs v45b

Review commit 5c89d46 (repair/float-conversions-v45b), based on f11b292.
Hosted cc1 SHA256:
3214735aa60ff2d270ddbb6c2e2a74b509eceb2784a0a568d404122ff6bd64a7.

All 30 selected historical floating failures reproduced before repair.
Unsigned SF conversion shifts right, reads its source once, preserves
a sticky bit and scales only high-bit inputs. Integer-derived D-format
values are explicitly normalized, rather than represented as an
addition by zero that the optimizer can remove. Unsigned conversion
uses the correct exponent bias and does not shift the 71-bit low
continuation twice. Negative SF-to-DF extension duplicates the sign
bit. No new permanent target storage. G-format and native RAM/speed
are not established by this run.

The first candidate had a decimal branch displacement in octal
assembly; v45b fixes it. All 30 historical cells, 44 new boundary
regression cells and 76 existing floating-point guards pass.
All 16 packed-unaligned complex cells still fail (four O0 at
assertion 1 and twelve optimized at assertion 2); keep them in
the aggregate backlog. The new regression is selected for GCC only.

Staged backlog 2696 cells: 2520 original historical runtime cells
plus 176 exact-type cells. No full sweep, master merge or installation.
Earlier cumulative acceptance remains incomplete.
