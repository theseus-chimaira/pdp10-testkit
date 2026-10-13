/* codegen-kcc-policy-only: yes */
/* Migrated KCC assembly assertions. */
/* codegen-require-regex: "(?im)^\\s*movn\\s+[0-9]+," */
/* codegen-forbid-regex: "(?ms)\\A(?=.*^\\s*move\\s+1,[0-9]+\\s*$)(?=.*^\\s*movn\\s+1,1\\s*$)" "(?ms)\\A(?=.*^\\s*move\\s+1,0\\([0-9]+\\)\\s*$)(?=.*^\\s*movn\\s+1,1\\s*$)" */
int negreg(x)
int x;
{
    int y;

    y = x;
    return -y;
}

int negmem(p)
int *p;
{
    int y;

    y = *p;
    return -y;
}
