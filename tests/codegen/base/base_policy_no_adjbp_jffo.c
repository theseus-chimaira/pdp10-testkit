/* codegen-forbid: ADJBP JFFO */
volatile int sink;
char buf[18];
int main()
{
    char *p;
    int i;
    int s;
    p = &buf[1];
    s = 0;
    for (i = 0; i < 12; ++i) {
        p[i] = (char)(i + 1);
        s += p[i];
    }
    sink = s;
    return s == 78 ? 0 : 1;
}
