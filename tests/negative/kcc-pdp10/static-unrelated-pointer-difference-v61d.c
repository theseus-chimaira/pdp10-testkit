/* Different static objects cannot cancel a relocation. */
static int a[2], b[2];
int difference = &a[1] - &b[0];
