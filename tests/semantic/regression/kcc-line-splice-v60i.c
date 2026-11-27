/* A source token's line is its start, not its lookahead position. */
#define LINE_ALIAS __LINE__
#define CALL_LINE(x) __LINE__
#define CALL_ALIAS CALL_LINE
#ident "optional identification metadata"
#line 20
enum { a = __LINE__\
};
enum { b = LINE_ALIAS\
};
enum { c = __LI\
NE__ };
enum { d = CALL_LINE(
0) };
enum { e = CALL_ALIAS(
0)
};
#if 0
#ident this is inactive
#endif
int main(void)
{
    return a != 20 || b != 22 || c != 24 || d != 27 || e != 29;
}
