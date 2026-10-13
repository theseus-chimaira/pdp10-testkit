/* codegen-kcc-policy-only: yes */
/* KCC compiler-specific instruction assertions. */
/* codegen-require-regex: "DIINC" "DIDEC" "MOVEM" */
/* codegen-forbid-regex: "(?i)internal error" */
long long global_value;
static long long static_value;
long long array_value[4];
long long pre_g(void) { return ++global_value; }
long long post_g(void) { return global_value++; }
long long predec_g(void) { return --global_value; }
long long postdec_g(void) { return global_value--; }
long long auto_all(int k) { long long x; x = k; ++x; x++; --x; return x--; }
long long ptr_pre(long long *p) { return ++*p; }
long long ptr_post(long long *p) { return (*p)++; }
long long arr_pre(int i) { return ++array_value[i]; }
long long arr_post(int i) { return array_value[i]++; }
void discard(void) { ++static_value; static_value++; --static_value; static_value--; }
