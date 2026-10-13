/* codegen-kcc-policy-only: yes */
/* Original KCC source and codegen assertions. */
static float ff(a, b)
float a;
float b;
{
    return (a - b) * 3.0f;
}

int main()
{
    return (int)ff(7.0f, 2.0f) != 15;
}
