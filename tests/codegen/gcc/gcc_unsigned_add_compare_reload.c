typedef unsigned int word_t;

int
gcc_unsigned_add_compare_reload(word_t a, word_t b, word_t c)
{
        return (a + b) < c;
}
