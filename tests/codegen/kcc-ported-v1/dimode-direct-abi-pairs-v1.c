/* codegen-kcc-check: "dimode-direct-abi-pairs" */
long long add71(long long a, long long b) { return a + b; }
long long id71(long long a) { return a; }
long long twice71(long long a) { return a + a; }
long long sub71(long long a, long long b) { return a - b; }
long long and71(long long a, long long b) { return a & b; }
long long or71(long long a, long long b) { return a | b; }
long long xor71(long long a, long long b) { return a ^ b; }
long long mul71(long long a, long long b) { return a * b; }
long long change71(long long a) { a += 1; return a; }
extern void sink(void);
long long call71(long long a) { sink(); return a; }
