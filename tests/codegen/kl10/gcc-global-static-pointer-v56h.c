/* Static and code-literal global pointers on the KL10B.  Referenced
 * arrays live in a separate object, so the linker must use ADDR30. */
extern char bytes[20];
extern short halves[20];
extern int words[20];
extern char scalar_byte;
extern short scalar_half;
extern int fun(void);

char *p0 = bytes;
char *p1 = bytes + 5;
short *p2 = halves + 3;
int *p3 = words + 5;
int (*p4)(void) = fun;
char *p5 = &bytes[5] - 1;
char *p6 = &bytes[5] - 2;
char *p7 = &bytes[5] + 3;
char *p8 = (char *)(words + 2);
short *p9 = (short *)(words + 1);
int *p10 = (int *)(bytes + 4);
char *p11 = &scalar_byte;
short *p12 = &scalar_half;
char *p13 = (char *)0;

char *get(void) { return bytes + 5; }
