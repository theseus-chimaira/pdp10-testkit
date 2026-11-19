# P1 KL10 assembly fixture disposition v1

`tests/semantic/upstream/support/920428-1.s` is excluded from the
current P1 matrix-admission work. The original source remains unchanged
in the repository and the frozen source inventory remains intact.

The installed DAS assembler was tested directly against the original
fixture, without any source adaptation:

| DAS flags | Result |
| --- | --- |
| `-K` | `malformed expression (9)0`; `malformed directive: BYTE (9)0` |
| `-A` | Same BYTE failure |
| `-K -A` | Same BYTE failure |
| `-S` | `malformed input` |
| `-K -S` | `malformed input` |

Representative command:

```
das -K -O "$TMPDIR/p10tk-920428-1-kl10-v1.dobj" \
  tests/semantic/upstream/support/920428-1.s
```

No executable was produced. This is not a passing ISA test and is not
registered as a C test. Per current scope, no new assembly harness is
being built and no assembler fix is attempted. The fixture is dropped
from the **active P1 admission queue**, not deleted from historical
provenance or misreported as passing. The remaining active queue has
28 C sources, all already registered in the semantic test matrix.
