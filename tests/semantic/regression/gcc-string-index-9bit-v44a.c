/* Constant string reads use target characters, not host storage bytes.
   Exercise literal, pointer and named const-array expansion. */
static const char chars[] = "A\400\777Z";
static const unsigned char bytes[] = "A\400\777Z";
static volatile int index_value = 2;

int main(void)
{
    if ((unsigned char)"A\400\777Z"[0] != 65) return 1;
    if ((unsigned char)"A\400\777Z"[1] != 0400) return 2;
    if ((unsigned char)*("A\400\777Z" + 2) != 0777) return 3;
    if ((unsigned char)chars[1] != 0400 || chars[3] != 'Z') return 4;
    if (bytes[2] != 0777 || bytes[4] != 0) return 5;
    if (bytes[index_value] != 0777 || sizeof bytes != 5) return 6;
    return 0;
}
