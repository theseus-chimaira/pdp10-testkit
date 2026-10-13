/* codegen-kcc-policy-only: yes */
/* KCC compiler-specific instruction assertions. */
/* codegen-require-regex: "(?i)movm\\s*15,016" "(?i)move\\s*16,015" "(?i)jumpl\\s*16,%UIDN" "(?i)aoja\\s*[0-7]+,%UIDD" */
/* codegen-forbid-regex: "(?i)jumpge\\s*15,%SIDP" "(?i)movn\\s*15,15" "(?i)skipge\\s*16,16" */
long sdiv(long a, long b)
{
    return a / b;
}
