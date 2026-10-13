/* codegen-kcc-policy-only: yes */
/* Preserves the original KCC assembly checks. */
/* codegen-require-regex: "(?ims)\\A(?:(?!^\\s*PUSHJ\\s*17,%ADJBPH).)*^\\s*PUSHJ\\s*17,%ADJBPH[^\\n]*\\n(?:(?!^\\s*PUSHJ\\s*17,%ADJBPH).)*^\\s*PUSHJ\\s*17,%ADJBPH[^\\n]*\\n(?:(?!^\\s*PUSHJ\\s*17,%ADJBPH).)*\\Z" "(?ims)\\A(?:(?!^\\s*PUSH\\s*17,13).)*^\\s*PUSH\\s*17,13[^\\n]*\\n(?:(?!^\\s*PUSH\\s*17,13).)*\\Z" "(?ims)\\A(?:(?!^\\s*PUSH\\s*17,14).)*^\\s*PUSH\\s*17,14[^\\n]*\\n(?:(?!^\\s*PUSH\\s*17,14).)*\\Z" "(?ims)\\A(?:(?!^\\s*PUSH\\s*17,15).)*^\\s*PUSH\\s*17,15[^\\n]*\\n(?:(?!^\\s*PUSH\\s*17,15).)*\\Z" "(?ims)\\A(?:(?!^\\s*POP\\s*17,13).)*^\\s*POP\\s*17,13[^\\n]*\\n(?:(?!^\\s*POP\\s*17,13).)*\\Z" "(?ims)\\A(?:(?!^\\s*POP\\s*17,14).)*^\\s*POP\\s*17,14[^\\n]*\\n(?:(?!^\\s*POP\\s*17,14).)*\\Z" "(?ims)\\A(?:(?!^\\s*POP\\s*17,15).)*^\\s*POP\\s*17,15[^\\n]*\\n(?:(?!^\\s*POP\\s*17,15).)*\\Z" */
char *f(char *p, int i) { return p + i; }
char *g(char *p, int i) { return p + i + 1; }
