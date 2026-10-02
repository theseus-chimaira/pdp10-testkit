#define DAS_NO_MAIN 1
#include "das.c"

static int
check_line(struct asmctx *c, char *line, enum das_token token,
           const char *key, const char *rest, const char *label)
{
    struct das_parsed_line parsed;
    int rc;

    rc = parse_line_head(c, line, &parsed);
    if (rc != 1)
        return 1;
    if (parsed.token != token)
        return 2;
    if (strcmp(parsed.key, key) != 0)
        return 3;
    if (strcmp(parsed.rest, rest) != 0)
        return 4;
    if (label == 0) {
        if (parsed.label != 0 || parsed.label_len != 0U)
            return 5;
    } else {
        if (parsed.label == 0 || parsed.label_len != strlen(label) ||
            strncmp(parsed.label, label, parsed.label_len) != 0)
            return 6;
    }
    return 0;
}

int
main(void)
{
    struct asmctx c;
    struct das_parsed_line parsed;
    char line1[] = "START: .TEXT ; comment";
    char line2[] = "  .ASCII /ABC/";
    char line3[] = "MOVE 1,FOO";
    char line4[] = "VALUE: 012345";
    char line5[] = "LABEL:";
    char blank[] = " ; comment";
    int rc;

    memset(&c, 0, sizeof(c));
    rc = check_line(&c, line1, DAS_TOK_TEXT, "TEXT", "", "START");
    if (rc != 0)
        return 10 + rc;
    rc = check_line(&c, line2, DAS_TOK_ASCII, "ASCII", "/ABC/", 0);
    if (rc != 0)
        return 20 + rc;
    rc = check_line(&c, line3, DAS_TOK_OTHER, "MOVE", "1,FOO", 0);
    if (rc != 0)
        return 30 + rc;
    rc = check_line(&c, line4, DAS_TOK_OTHER, "012345", "", "VALUE");
    if (rc != 0)
        return 40 + rc;
    if (parse_line_head(&c, line5, &parsed) != 1 ||
        parsed.label == 0 || parsed.stmt != 0)
        return 50;
    if (parse_line_head(&c, blank, &parsed) != 0)
        return 51;
    if (c.parser_classifications != 4U)
        return 52;
    if (c.parser_token_probes == 0U ||
        c.parser_token_probes >= c.parser_classifications * 8U)
        return 53;
    return 0;
}
