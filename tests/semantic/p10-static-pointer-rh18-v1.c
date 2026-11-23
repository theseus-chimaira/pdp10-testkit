/* PDP-10 static pointers must relocate their 18-bit address without
   carrying into the byte-pointer P/S selector in the left half.

   Exercise 9-bit char pointer arithmetic, conversion back to word
   pointers, and both standalone and aggregate static initializers.
   The resulting pointers stay within one array.  */

static int words[8] = { 11, 22, 33, 44, 55, 66, 77, 88 };

struct pointers
{
  int *word;
  char *byte;
};

struct pointers grouped =
{
  (int *) ((char *) &words[3] - 8),
  (char *) &words[3] - 8
};

int *standalone_word = (int *) ((char *) &words[3] - 8);
char *standalone_byte = (char *) &words[3] - 8;

int
main (void)
{
  char *dynamic_byte = (char *) &words[3] - 8;
  int *dynamic_word = (int *) dynamic_byte;

  if (grouped.word != &words[1])
    return 1;
  if (standalone_word != &words[1])
    return 2;
  if (grouped.byte != (char *) &words[1])
    return 3;
  if (standalone_byte != (char *) &words[1])
    return 4;
  if (grouped.word != dynamic_word)
    return 5;
  if (grouped.byte != dynamic_byte)
    return 6;

  return 0;
}
