/* A static pointer variable's value is not its symbol address. */
static int a[2];
static int *p = a;
int difference = p - a;
