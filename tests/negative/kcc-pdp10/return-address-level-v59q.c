/* The level is a nonnegative integer constant, not a runtime value. */
void bad_return_address(int level)
{
    __builtin_return_address(level);
    __builtin_return_address(-1);
    __builtin_return_address();
    __builtin_return_address(0, 1);
}
