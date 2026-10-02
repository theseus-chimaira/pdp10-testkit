/* codegen-forbid: JFCL JRSTF HALT JEN CONI CONO DATAI DATAO BLKI BLKO CONSZ CONSO */
volatile int g;
int main()
{
    int i;
    int s;
    s = 0;
    for (i = 0; i < 8; ++i) {
        if (g & (1 << i))
            s += i;
        else
            s -= i;
    }
    g = s;
    return s == 0 ? 0 : 1;
}
