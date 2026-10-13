/* codegen-kcc-policy-only: yes */
/* codegen-kcc-extra: "-Pgnu99" "-m=gas" */
/* codegen-require-regex: "(?ims)^char_pointer:\\s*\\n\\s*\\.word\\s+0\\s*$" "(?ims)^word_pointer:\\s*\\n\\s*\\.word\\s+0\\s*$" */
/* codegen-forbid-regex: "(?im)^\\s*\\.LINK(?:\\s|$)" */
#define NULL ((void *)0)

char *char_pointer = NULL;
int *word_pointer = NULL;

int
main(void)
{
        return char_pointer != 0 || word_pointer != 0;
}
