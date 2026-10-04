#include <stdio.h>
#include <stdlib.h>

#include "dpy_text.c"

static kword_t arena[DPY_TEXT_ALLOC_WORDS];
static kword_t requested_words;
static unsigned int alloc_calls;

int
mm_alloc(kword_t words, unsigned int type, unsigned int owner,
    unsigned int preference, kword_t *basep)
{
        if (words != (kword_t)DPY_TEXT_ALLOC_WORDS ||
            type != MM_TYPE_KERNEL_DYNAMIC ||
            owner != DPY_TEXT_MM_OWNER ||
            preference != MM_ALLOC_LOW || basep == 0)
                return MM_ERR_INVAL;
        ++alloc_calls;
        requested_words = words;
        *basep = (kword_t)(unsigned long)arena;
        return MM_OK;
}

static void
fail(const char *why)
{
        fprintf(stderr, "type340-text-v1: %s\n", why);
        exit(1);
}

static unsigned int
cached_code(unsigned int prow, unsigned int n)
{
        kword_t *prog;
        unsigned int shift;

        prog = &arena[DPY_TEXT_PROG_OFF + prow * DPY_TEXT_PROG_WORDS];
        shift = 30U - (n % 6U) * 6U;
        return (unsigned int)((prog[n / 6U] >> shift) & 077UL);
}

int
main(void)
{
        unsigned int i;
        unsigned int ncode;
        unsigned int saw_so;
        unsigned int saw_si_after_so;

        if (dpy_text_active != 0UL || alloc_calls != 0U)
                fail("text storage is not lazy");
        if (dpy_text_putchar('L') != 0)
                fail("first character failed");
        if (alloc_calls != 1U ||
            requested_words != (kword_t)DPY_TEXT_ALLOC_WORDS)
                fail("wrong first-use allocation");
        if (dpy_text_active == 0UL ||
            dpy_cell_get(0U, 0U) != (unsigned int)('L' - 040))
                fail("first character not retained");
        if (dpy_text_rows_used != 1UL)
                fail("first visible row bound is wrong");

        if (dpy_text_putchar('o') != 0 ||
            dpy_cell_get(0U, 1U) != (unsigned int)('O' - 040))
                fail("lowercase character was not normalized to SIXBIT");

        ncode = (unsigned int)arena[DPY_TEXT_LENGTH_OFF] * 6U;
        saw_so = 0U;
        saw_si_after_so = 0U;
        for (i = 0U; i < ncode; ++i) {
                if (cached_code(0U, i) == DPY_T342_SO)
                        saw_so = 1U;
                if (saw_so != 0U && cached_code(0U, i) == DPY_T342_SI)
                        saw_si_after_so = 1U;
        }
        if (saw_so != 0U)
                fail("ordinary lowercase incorrectly entered shifted text");
        if (arena[DPY_TEXT_LENGTH_OFF] == 0UL ||
            arena[DPY_TEXT_LENGTH_OFF] > (kword_t)DPY_TEXT_PROG_WORDS)
                fail("compiled row length outside cache bound");
        if (arena[DPY_TEXT_LENGTH_OFF] != 1UL)
                fail("short row was not trimmed to one native word");

        if (dpy_text_putchar('[') != 0)
                fail("shifted SIXBIT punctuation failed");
        ncode = (unsigned int)arena[DPY_TEXT_LENGTH_OFF] * 6U;
        saw_so = 0U;
        saw_si_after_so = 0U;
        for (i = 0U; i < ncode; ++i) {
                if (cached_code(0U, i) == DPY_T342_SO)
                        saw_so = 1U;
                if (saw_so != 0U && cached_code(0U, i) == DPY_T342_SI)
                        saw_si_after_so = 1U;
        }
        if (saw_so == 0U || saw_si_after_so == 0U)
                fail("shifted SIXBIT punctuation state missing");

        if (dpy_text_putchar(014U) != 0)
                fail("sparse-frame form feed failed");
        {
                static const char login[] = "LOGIN: ";
                static const char shell[] = "DSH V1";
                for (i = 0U; login[i] != 0; ++i)
                        if (dpy_text_putchar((unsigned int)login[i]) != 0)
                                fail("sparse LOGIN row failed");
                if (dpy_text_rows_used != 1UL ||
                    arena[DPY_TEXT_LENGTH_OFF] != 2UL ||
                    arena[DPY_TEXT_PROG_OFF] != 0141707111672UL ||
                    arena[DPY_TEXT_PROG_OFF + 1U] != 0353535353433UL)
                        fail("LOGIN row is not compact two-word Type-342");
                if (dpy_text_putchar(015U) != 0 ||
                    dpy_text_putchar(012U) != 0)
                        fail("sparse row advance failed");
                for (i = 0U; shell[i] != 0; ++i)
                        if (dpy_text_putchar((unsigned int)shell[i]) != 0)
                                fail("sparse DSH row failed");
                if (dpy_text_rows_used != 2UL ||
                    arena[DPY_TEXT_LENGTH_OFF + 1U] != 2UL)
                        fail("visible-row bound did not stop after DSH row");
        }

        if (dpy_text_putchar(014U) != 0)
                fail("form feed failed");
        if (dpy_text_rows_used != 0UL)
                fail("form feed did not clear visible-row bound");
        for (i = 0U; i < DPY_TEXT_COLS; ++i)
                if (dpy_text_putchar('A') != 0)
                        fail("full-row output failed");
        if (dpy_text_row != 1U || dpy_text_col != 0U)
                fail("84-column wrap is wrong");
        if (dpy_text_rows_used != 1UL)
                fail("full first row visible bound is wrong");

        if (dpy_text_putchar(014U) != 0)
                fail("second form feed failed");
        for (i = 0U; i < DPY_TEXT_ROWS; ++i) {
                if (dpy_text_putchar(015U) != 0 ||
                    dpy_text_putchar(012U) != 0)
                        fail("newline/scroll output failed");
        }
        if (dpy_text_top != 1UL ||
            dpy_text_row != DPY_TEXT_ROWS - 1U ||
            dpy_text_rows_used != (kword_t)(DPY_TEXT_ROWS - 1U) ||
            alloc_calls != 1U)
                fail("42-row ring scroll is wrong");

        printf("type340-text-v1: PASS (%lu dynamic words, no permanent buffer)\n",
            (unsigned long)requested_words);
        return 0;
}
