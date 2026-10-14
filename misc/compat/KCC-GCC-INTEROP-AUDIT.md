# KCC/GCC direct interoperability audit

The direct interoperability matrix uses separately compiled KCC and PDP-10 GCC
translation units in both caller/callee directions.  Tests are semantic/runtime
unless an object-format property is inherently link-time.

Covered directly:

- argument assignment and register/stack crossing: v12, v24, v28, v30, v32;
- scalar and 71-bit return registers: v12, v24, v32;
- preserved registers and stack cleanup: v24, v36;
- 1--5 word aggregate returns: v24, v36;
- aggregate arguments and stack placement: v25, v28, v29;
- aggregate/bit-field layout: v26, v27, v29, v31;
- ordinary and byte-pointer arguments/results: v24, v36;
- float and double direct calls/returns: v36;
- symbol spelling/significance and runtime helper coexistence: v11, v34, v37;
- data/function relocation: v35;
- separate DAS DOBJ assembly and dlink object linking: v37.

Not claimed as native direct compatibility:

- source types whose storage units or native representation differ between KCC
  and GCC;
- interfaces that intentionally expose a compiler-internal machine mode rather
  than an equivalent C type;
- mixed variadic calls beyond the combinations proven by the dedicated varargs
  matrix.

Those cases belong to explicit adapters or to the separate variadic-policy
item.  They must not be made compatible by changing KCC's native language
model, `long`, byte pointers, or default ABI.

Explicit representation adapters:

- exact 16- and 18-bit values cross mixed-compiler interfaces as canonical
  36-bit word-register values and are converted explicitly at each endpoint;
- `raw72_t` is the stable two-word interface for a full raw 72-bit value;
- direct pointers/aggregate layouts involving native exact 16/18-bit objects
  are intentionally not part of the mixed ABI.
