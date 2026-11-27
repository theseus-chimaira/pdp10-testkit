/* An incomplete tentative array with internal linkage is not permitted. */
static int invalid[];
int read_invalid(void) { return invalid[0]; }
