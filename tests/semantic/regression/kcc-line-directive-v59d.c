/* Check macro-expanded line numbers, optional filenames and blank lines.
   Keep the source-located assertions independent of optimization. */
#define LINE_NUMBER 90
#define LINE_FILE "v59d.c"

#line 20
enum { first = __LINE__ };
#line LINE_NUMBER LINE_FILE
enum { second = __LINE__ };
#line 100


enum { third = __LINE__ };

static const char name[] = __FILE__;

int main(void)
{
    if (first != 20 || second != 90 || third != 102)
        return 1;
    if (name[0] != 'v' || name[1] != '5' || name[2] != '9' ||
        name[3] != 'd' || name[4] != '.' || name[5] != 'c' || name[6])
        return 2;
    return 0;
}
