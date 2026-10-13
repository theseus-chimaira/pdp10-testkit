extern int MixedCaseV37(int);
extern int _lead_v37;

int
main(void)
{
    if (MixedCaseV37(2) != 3)
        return 1;
    if (_lead_v37 != 0123)
        return 2;
    return 0;
}
