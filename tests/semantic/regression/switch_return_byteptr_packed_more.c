volatile int __test_exit;
volatile int fail_id;
volatile int got;
volatile int got1;
volatile int got2;
volatile int got3;
volatile int got4;
volatile int got5;

struct holder {
    char op;
    char buf[8];
    short code;
    int score;
};

struct holder gh[4];

static char ret_op(hp)
struct holder *hp;
{
    return hp->op;
}

static short ret_code(hp)
struct holder *hp;
{
    return hp->code;
}

static int take(cpp, hp)
char **cpp;
struct holder *hp;
{
    int v;
    v = **cpp;
    ++*cpp;
    hp->score = hp->score + v;
    return v;
}

static int apply(hp)
struct holder *hp;
{
    char *p;
    int r;
    p = hp->buf;
    r = 0;
    switch (ret_op(hp)) {
    case 1:
        r = take(&p, hp);
        /* fall through */
    case 2:
        hp->code = (short)(hp->code + *p++);
        hp->score = hp->score + hp->code + r;
        break;
    case 3:
        switch (ret_code(hp)) {
        case -5:
            hp->score = hp->score + 31;
            hp->code = (short)(hp->code - 2);
            break;
        case -7:
            hp->score = hp->score + 37;
            break;
        default:
            hp->score = hp->score - 41;
            break;
        }
        break;
    default:
        hp->buf[0] = (char)(hp->buf[0] + 1);
        break;
    }
    return (p - hp->buf) + hp->score + hp->code;
}

int main()
{
    fail_id = 0;
    gh[0].op = 1; gh[0].buf[0] = 5; gh[0].buf[1] = 7; gh[0].code = 10; gh[0].score = 100;
    gh[1].op = 2; gh[1].buf[0] = 3; gh[1].buf[1] = 4; gh[1].code = 20; gh[1].score = 200;
    gh[2].op = 3; gh[2].buf[0] = 8; gh[2].buf[1] = 9; gh[2].code = -5; gh[2].score = 300;
    gh[3].op = 9; gh[3].buf[0] = 8; gh[3].buf[1] = 1; gh[3].code = 40; gh[3].score = 400;

    got = apply(&gh[0]);
    if (got != 146) { fail_id = 1; return 1; }
    got1 = apply(&gh[1]);
    if (got1 != 247) { fail_id = 2; return 1; }
    got2 = apply(&gh[2]);
    if (got2 != 324) { fail_id = 3; return 1; }
    got3 = apply(&gh[3]);
    if (got3 != 440) { fail_id = 4; return 1; }
    got4 = gh[0].score + gh[0].code;
    if (got4 != 144) { fail_id = 5; return 1; }
    got5 = gh[3].buf[0];
    if (got5 != 9) { fail_id = 6; return 1; }
    return 0;
}
