/* codegen-kcc-policy-only: yes */
/* Original KCC regression checks. */
/* codegen-require-regex: "(?im)movem\\s+1,0\\([0-7]+\\)\\s*$" "(?im)jrst\\s+sink\\s*$" */
/* codegen-forbid-regex: "(?im)move\\s+3,0\\(10\\)\\s*$" */
extern int source(void);
extern int sink(int);

int forward(int *p)
{
    *p = source();
    return sink(*p);
}
