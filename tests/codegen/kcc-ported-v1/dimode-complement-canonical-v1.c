/* Migrated KCC canonical 72-bit complement regression. */
/* codegen-require-regex: "(?ims)\\A(?:(?!^\\s*setca\\s).)*^\\s*setca\\s[^\\n]*\\n(?:(?!^\\s*setca\\s).)*^\\s*setca\\s[^\\n]*\\n(?:(?!^\\s*setca\\s).)*^\\s*setca\\s[^\\n]*\\n(?:(?!^\\s*setca\\s).)*^\\s*setca\\s[^\\n]*\\n(?:(?!^\\s*setca\\s).)*\\Z" */
/* codegen-forbid-regex: "(?im)^\\s*xor\\s+[^,]+,\\[377777777777\\]" "(?im)^\\s*and\\s+[^,]+,\\[377777777777\\]" */
typedef long long Dint;
typedef unsigned long long Uint;
Dint sc(Dint x) { return ~x; }
Uint uc(Uint x) { return ~x; }
