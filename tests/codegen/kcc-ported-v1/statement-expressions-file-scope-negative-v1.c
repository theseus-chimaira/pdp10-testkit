/* codegen-kcc-expect-compile-fail: yes */
/* codegen-kcc-diagnostic-require-regex: "Statement\\ expressions\\ are\\ only\\ allowed\\ inside\\ functions" */
int x = ({ int y = 1; y; });
