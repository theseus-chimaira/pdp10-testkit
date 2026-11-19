# P1 original-source matrix admission v1

Four previously deferred original upstream C sources have been admitted to
`COMPILER_MATRIX.tsv` for the **KCC native PDP-6** semantic profile. Their
source bytes and original assertions are unchanged. All four were rerun
through the normal matrix runner with `--compiler kcc --family native
--cpu pdp6 --opt noopt --kind semantic --source <path>` and returned
`new_pass=1`, with zero failures per isolated run.

| Original source | KCC PDP-6 noopt | GCC PDP-6 O0 | Oracle caveat |
| --- | --- | --- | --- |
| `tests/todo/generic/920726-1.c` | pass | compile error | Original `strcmp` checks both varargs paths; its return value from an uninitialized local is ignored |
| `tests/todo/generic/930513-1.c` | pass | compile error | Original checks the formatted float output bytes |
| `tests/todo/generic/960327-1.c` | pass | compile error | Original checks the `sprintf` destination after pointer arithmetic |
| `tests/todo/generic/980605-1.c` | pass | compile error | Original checks the arithmetic sum, but does not assert its formatted output |

GCC O0 `error` entries preserve observed compile failures. Unchecked
architectures and optimization levels remain `no_test`, not presumed passing.
These are **four admitted KCC cells**, not four fully closed P1 obligations:
GCC and other profiles remain unresolved, and the original P1 disposition
manifest is intentionally not rewritten to claim coverage closure.

Reproduction for each source:

```
python3 tools/run-tests.py --compiler kcc --family native --cpu pdp6 \
  --opt noopt --kind semantic --source tests/todo/generic/920726-1.c
```
