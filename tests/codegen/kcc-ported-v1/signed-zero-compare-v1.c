/* Exact signed-comparison instruction selection. */
/* codegen-require-regex: "(?im)^\\s*skipn\\s+[0-7]+,[0-7]+\\s*$" "(?im)^\\s*skipl\\s+[0-7]+,[0-7]+\\s*$" "(?im)^\\s*skiple\\s+[0-7]+,[0-7]+\\s*$" "(?im)^\\s*skipg\\s+[0-7]+,[0-7]+\\s*$" "(?im)^\\s*skipge\\s+[0-7]+,[0-7]+\\s*$" */
/* codegen-forbid-regex: "(?im)^\\s*(setz|cam[e-ngl]*)\\s+" */
int ne0(int x) { return x != 0; }
int lt0(int x) { return x < 0; }
int le0(int x) { return x <= 0; }
int gt0(int x) { return x > 0; }
int ge0(int x) { return x >= 0; }
