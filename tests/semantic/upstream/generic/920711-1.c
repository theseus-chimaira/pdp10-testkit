/* Original boundary regression adapted to a bare-metal return-code check.
 * 0x80000000 is an interior positive value on PDP-10, not its sign bit. */
volatile int __test_exit;
static int f(long a) { return --a > 0; }
int main(void) { return f(0x80000000L) == 0; }
