/* Original KCC source and codegen assertions. */
float fmul(a, b)
float a;
float b;
{
    return a * b;
}

int main()
{
    float f;
    f = fmul(2.0f, 3.0f);
    return (int)f != 6;
}
