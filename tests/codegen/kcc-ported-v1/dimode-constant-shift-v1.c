/* Original KCC instruction assertion migration. */
/* codegen-require-regex: "(?im)^\\s*TLZ\\s+[^,]+,0400000$" "(?im)^\\s*TRNE\\s+[^,]+,1$" "(?im)^\\s*LSH\\s+[^,]+,-1$" "(?im)^\\s*LSH\\s+[^,]+,1$" "(?im)^\\s*AND\\s+[^,]+,\\[0377777777777\\]$" "(?im)^\\s*lshc\\s+[^,]+,0\\([^)]*\\)$" "(?im)^\\s*ashc\\s+[^,]+,0\\([^)]*\\)$" */
typedef long long Dint;
typedef unsigned long long Uint;
Dint sl1(Dint x) { return x << 1; }
Dint sl5(Dint x) { return x << 5; }
Dint sr1(Dint x) { return x >> 1; }
Uint ur5(Uint x) { return x >> 5; }
Dint sv(Dint x, int n) { return x << n; }
Dint srv(Dint x, int n) { return x >> n; }
