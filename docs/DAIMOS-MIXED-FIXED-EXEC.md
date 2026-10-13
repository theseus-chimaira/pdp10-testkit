# DAIMOS mixed KCC/GCC fixed-call execution

Executable KS10 probes confirm direct calls in both directions for normalized
71-bit fixed arguments and returns:

- GCC caller to KCC callee;
- KCC caller to GCC callee.

Both tests pass two 71-bit arguments in AC1:AC2 and AC3:AC4, return the result
in AC1:AC2, link the generated assembly together, and execute it under SIMH.
Variadic interoperability is tested separately by `test-wide-varargs-abi.sh`.
