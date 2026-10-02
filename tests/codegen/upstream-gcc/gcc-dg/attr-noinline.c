/* { dg-do compile } */
/* { dg-options "-O2 -finline-functions" } */

static inline void __attribute__((__noinline__)) function_definition(void) {} /* { dg-warning "inline function \[^\n\]* given attribute noinline" "" } */

static inline void __attribute__((__noinline__)) function_declaration_bot_841d8d(void); /* { dg-warning "inline function \[^\n\]* given attribute noinline" "" } */

static void function_declaration_bot_841d8d(void) {}

static void function_declaration_both_after(void);

static inline void __attribute__((__noinline__)) function_declaration_both_after(void); /* { dg-warning "(inline function \[^\n\]* given attribute noinline|declared inline after its definition)" "" } */

static void function_declaration_both_after(void) {}

static void function_declaration_noi_9c45c7(void) __attribute__((__noinline__)); /* { dg-warning "previous declaration \[^\n\]* with attribute noinline" "" } */

static inline void function_declaration_noi_9c45c7(void) {} /* { dg-warning "function \[^\n\]* redeclared as inline" "" } */

static inline void function_declaration_noi_148240(void) {} /* { dg-warning "previous declaration \[^\n\]* was inline" "" } */

static void function_declaration_noi_148240(void) __attribute__((__noinline__)); /* { dg-warning "function \[^\n\]* redeclared with attribute noinline" "" } */

static inline void function_declaration_inl_ba8fd8(void); /* { dg-warning "previous declaration \[^\n\]* was inline" "" } */

static void __attribute__((__noinline__)) function_declaration_inl_ba8fd8(void) {} /* { dg-warning "function \[^\n\]* redeclared with attribute noinline" "" } */

static inline void function_declaration_inl_799682(void); /* { dg-warning "previous declaration \[^\n\]* was inline" "" } */

static void function_declaration_inl_799682(void) __attribute__((__noinline__)); /* { dg-warning "function \[^\n\]* redeclared with attribute noinline" "" } */

static void function_declaration_inl_799682(void) {}

static inline void function_declaration_inl_a719e6(void);

static void function_declaration_inl_a719e6(void) {} /* { dg-warning "previous declaration \[^\n\]* was inline" "" } */

static void function_declaration_inl_a719e6(void) __attribute__((__noinline__)); /* { dg-warning "function \[^\n\]* redeclared with attribute noinline" "" } */

static void function_declaration_noi_0fce97(void) __attribute__((__noinline__)); /* { dg-warning "previous declaration\[^\n\]* with attribute noinline" "" } */

static inline void function_declaration_noi_0fce97(void); /* { dg-warning "function \[^\n\]* redeclared as inline" "" } */

static void function_declaration_noi_0fce97(void) {}

void f () {
  function_definition ();
  function_declaration_bot_841d8d ();
  function_declaration_both_after ();
  function_declaration_noi_9c45c7 ();
  function_declaration_noi_148240 ();
  function_declaration_inl_ba8fd8 ();
  function_declaration_inl_799682 ();
  function_declaration_inl_a719e6 ();
  function_declaration_noi_0fce97 ();
}

/* { dg-final { scan-assembler "function_definition" } } */
/* { dg-final { scan-assembler "function_declaration_bot_841d8d" } } */
/* { dg-final { scan-assembler "function_declaration_both_after" } } */
/* { dg-final { scan-assembler "function_declaration_noi_9c45c7" } } */
/* { dg-final { scan-assembler "function_declaration_noi_148240" } } */
/* { dg-final { scan-assembler "function_declaration_inl_ba8fd8" } } */
/* { dg-final { scan-assembler "function_declaration_inl_799682" } } */
/* { dg-final { scan-assembler "function_declaration_inl_a719e6" } } */
/* { dg-final { scan-assembler "function_declaration_noi_0fce97" } } */
