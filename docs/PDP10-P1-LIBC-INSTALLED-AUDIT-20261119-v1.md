# P1 installed freestanding selector audit (2026-11-19, v1)

Static validation against the installed KCC/GCC freestanding sources,
not a full compiler matrix or simulator sweep.

- 13 source members selected by the semantic runner export 23 symbols.
- Every selector-owned symbol is exported by its declared source member;
  no installed source exports are unaccounted for or duplicated.
- Source-local labels are excluded from the cross-member dependency graph.
- The only cross-member call detected is memmove -> memcpy, already
  declared in the selector. Both PUSHJ and JRST call forms are examined.
- Installed KCC and GCC sources are instruction-identical after ignoring
  blank lines and trailing/leading whitespace. The string source differs
  in whitespace only. Both installed archives are byte-identical.
- The PDP-6-only D-format member is not automatically selected on other
  machines. This is a policy check, not evidence of cross-CPU runtime PASS.

The host-only audit and its three mutation controls are registered as
`installed-freestanding-selector-audit-v1`. Negative controls corrupt a
member dependency, remove an expected export and alter one archive;
each must cause validation to fail. They work in a versioned temporary
workspace and do not modify installed files.

Reproduction:

    python3 tools/audit-installed-freestanding-v1.py
    python3 tools/test-installed-freestanding-audit-v1.py

The production linker/execution distinction remains as described in
`docs/PDP10-P1-LIBC-VERIFICATION-20261119-v1.md`. Remaining P1 tasks:
missing hosted dependencies, ABI/header/varargs policy, and runner
failure/resume preflight. No compiler errors were suppressed.
