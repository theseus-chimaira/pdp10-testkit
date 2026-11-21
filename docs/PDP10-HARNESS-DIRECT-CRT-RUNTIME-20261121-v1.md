# Direct upstream CRT runtime isolation (v1)

Date: 2026-11-21. Scope: harness only; no compiler repairs.

The registered `upstream-crt-v1` special test previously executed its
`p10run` guest directly against the installed PDP10_PREFIX. That driver
implicitly considers `lib/libc.a`, which may be an OS library rather than
the KCC compiler's freestanding archive. Dispatcher isolation covered
registered runs but did not protect raw script invocation.

`misc/validation/test-upstream-crt-v2.sh` now stages a per-script prefix
through the existing `prepare_script_prefix(..., "kcc")` helper and
passes it explicitly to every guest `p10run` invocation. The original
v1 script remains as historical evidence. The registered test ID stays
`upstream-crt-v1` to avoid changing external selection interfaces;
its script path is upgraded to v2.

Verified on the installed environment:

- Direct `sh misc/validation/test-upstream-crt-v2.sh`: PASS, all five
  termination cases with their original expected outcomes.
- `python3 tools/test-special-compiler-stdlib-dispatch-v1.py`: PASS.
- `python3 tools/test-runner-result-accounting-v1.py`: PASS.

This is a focused hardening change, not completion of the wider direct
`p10run` audit. The remaining potential callers, restart/interrupt
acceptance, and full 123,576-cell sweep remain outstanding. Ordinary
compiler failures are explicitly deferred.
