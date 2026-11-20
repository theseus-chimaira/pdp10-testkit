# P1 semantic resolution v12: original variable-size va_arg covered

The current live P1 ledger contains 67 frozen historical original
identities. Exactly one P1 disposition changes from v11:
`tests/todo/generic/20020412-1.c` is **covered** because its
unchanged GNU variable-sized `va_arg` checks compile and execute
under installed GCC with four genuine assertion failures. KCC
still rejects the GNU extension. These remain compiler issues,
not reasons to weaken a meaningful testkit oracle.

Current counts: **41 covered, 0 partial, 26 blocked**.
No other original SHA or classification was changed.
The authoritative TSV is
`PDP10-P1-SEMANTIC-RESOLUTION-20261120-v12.tsv`, generated
by `tools/build-p1-semantic-resolution-v12.py`.
The source-specific diagnostic evidence is described in
`PDP10-P1-VARIADIC-VLA-ORIGINAL-20261120-v1.md`.
