/* codegen-require-regex: '(?ms)^\s*\.data\s*$.*^\s*\.text\s*$.*^section_function:' */
volatile int section_data = 1;

int
section_function(void)
{
    return section_data + 1;
}
