/* Unknown member and positional union overflow must still be rejected. */
struct record { int a, b; };
struct record bad = { nonexistent: 1 };
union choice { int i; long l; };
union choice overflow = { i: 1, 2 };
