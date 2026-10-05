#define NULL ((void *)0)

char *char_pointer = NULL;
int *word_pointer = NULL;

int
main(void)
{
        return char_pointer != 0 || word_pointer != 0;
}
