char *ptr_char_add(char *p, int n) { return p + n; }
short *ptr_short_add(short *p, int n) { return p + n; }
int *ptr_word_add(int *p, int n) { return p + n; }
char ptr_char_get(char *p) { return *p; }
short ptr_short_get(short *p) { return *p; }
int ptr_word_get(int *p) { return *p; }
void ptr_char_set(char *p, char v) { *p = v; }
void ptr_short_set(short *p, short v) { *p = v; }
void ptr_word_set(int *p, int v) { *p = v; }
