/* Historical declarations default each declarator's base to int. */
first(), second(), value, array[2];
static local_value, local_array[2];
int first(void) { return 11; }
int second(void) { return 22; }
int main(void)
{
    value = first();
    array[0] = second();
    local_value = 33;
    local_array[1] = 44;
    if (sizeof(value) != sizeof(int) || sizeof(array) != 2 * sizeof(int))
        return 1;
    return value != 11 || array[0] != 22
        || local_value != 33 || local_array[1] != 44;
}
