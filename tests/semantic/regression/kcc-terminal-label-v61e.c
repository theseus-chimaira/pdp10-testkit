/* GNU terminal labels act like labeled empty statements.  The closing
** brace must remain available to the enclosing block and switch parser.
*/
static int ordinary(int x)
{
    int result = 3;
    {
        if (x)
            goto end;
        result = 5;
    end:
    }
    return result;
}

static int cases(int x)
{
    int result = 7;
    switch (x) {
    default:
        result = 9;
        break;
    case 1:
    case 2:
    }
    return result;
}

static int defaults(int x)
{
    int result = 11;
    switch (x) {
    case 1:
        result = 13;
        break;
    default:
    }
    return result;
}

static void nested(void)
{
    switch (0) {
    default:
    finish:
    }
done:
}

int main(void)
{
    if (ordinary(1) != 3 || ordinary(0) != 5)
        return 1;
    if (cases(1) != 7 || cases(2) != 7 || cases(0) != 9)
        return 2;
    if (defaults(1) != 13 || defaults(0) != 11)
        return 3;
    nested();
    return 0;
}
