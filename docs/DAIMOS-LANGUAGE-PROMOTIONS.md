# DAIMOS narrow integer promotions v1

The shared exact-width 6-, 7-, 8-, 9-, and 18-bit types use the existing PDP-10 byte representations, but expressions promote their values to the native 36-bit `int` domain before ordinary arithmetic and comparison.

This rule avoids adding a machine-mode lattice or new arithmetic operators to KCC. It is suitable for a native PDP-6 compiler because narrow values remain storage types while computation uses existing word arithmetic.

Unsigned narrow values also promote to 36-bit `int`: every supported unsigned narrow value fits in a signed PDP-10 word. Mixed narrow/word expressions therefore use signed 36-bit arithmetic unless an operand is explicitly converted to `unsigned int`.

The `DAIMOS_INT*_C` and `DAIMOS_UINT*_C` macros construct word-sized source constants. Assignment to an exact-width object performs the documented truncation. They do not create distinct narrow literal types.

Exact 16- and 32-bit arithmetic remains outside the KCC common language subset.
