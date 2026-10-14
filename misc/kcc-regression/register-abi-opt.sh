#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc

KCC=$PDP10_PREFIX/bin/kcc
TMP=${TMPDIR:-/tmp}/kcc-register-abi-$$
trap 'rm -rf "$TMP"' EXIT HUP INT TERM
mkdir -p "$TMP"

cat > "$TMP/test.c" <<'SRC'
int one(unsigned int level)
{
    return level >= 1U && level <= 7U;
}

int retadd(int x)
{
    return x + 1;
}

extern int h(int);
int call1(int x)
{
    return h(x);
}

int calllocal(int x)
{
    int y;

    y = h(x);
    return y + x;
}

extern int setp(int **);
int localaddr(int x)
{
    int *p;

    if (setp(&p) != 0)
        return x;
    return *p + x;
}

extern unsigned int hu(unsigned int);
int spillcall(unsigned int x)
{
    unsigned int a;

    a = x + 1U;
    if (a > hu(5U) || a > hu(6U) - x)
        return -1;
    return 0;
}

void regindex(unsigned long *mem, unsigned int words, unsigned long value)
{
    unsigned int i;

    for (i = 0; i < words; ++i)
        if (mem[i] == (unsigned long)-1)
            mem[i] = value;
}

int preword(int *p)
{
    return ++*p;
}

int four(int a, int b, int c, int d)
{
    return a + b + c + d;
}

int addr(int x)
{
    int *p = &x;
    return *p;
}

int five(int a, int b, int c, int d, int e)
{
    return a + b + c + d + e;
}

extern int h3(int, int, int);
int tail3(int a, int b, int c)
{
    return h3(a, b, c);
}

extern int g(int, int, int, int);
int forward(int a, int b, int c, int d)
{
    return g(b, a, d, c);
}

unsigned int udivv(unsigned int a, unsigned int b)
{
    return a / b;
}

int sdivv(int a, int b)
{
    return a / b;
}

extern int g5(int, int, int, int, int);
int forward5(int a, int b, int c, int d, int e)
{
    return g5(b, a, d, c, e);
}

int readp(int *p)
{
    return *p;
}

int read2p(int *p)
{
    return p[1] + p[2];
}

int leafif(int *p, int x)
{
    if (x)
        return p[0];
    return p[1];
}

int *nullp(int *p)
{
    if (p == 0)
        return 0;
    return p;
}

int *prepi(int *p)
{
    return ++p;
}

int *postpi(int *p)
{
    return p++;
}

struct pair { int a; int b; };
struct pair *preps(struct pair *p)
{
    return ++p;
}

int paira(struct pair *p)
{
    return p->a;
}

char *prepc(char *p)
{
    return ++p;
}

char *postpc(char *p)
{
    return p++;
}

int readc(char *p)
{
    return *p;
}

int addrp(int *p)
{
    int **q = &p;
    return **q;
}
SRC

(
    cd "$TMP"
    "$KCC" -S test.c >/dev/null
)
ASM=$TMP/test.s

function_body()
{
    name=$1
    awk -v name="$name" '
        $0 == name ":" { in_fn = 1; next }
        in_fn && /^[A-Za-z_][A-Za-z0-9_]*:$/ { exit }
        in_fn { print }
    ' "$ASM"
}

one_body=$(function_body one)
retadd_body=$(function_body retadd)
call1_body=$(function_body call1)
calllocal_body=$(function_body calllocal)
localaddr_body=$(function_body localaddr)
spillcall_body=$(function_body spillcall)
regindex_body=$(function_body regindex)
preword_body=$(function_body preword)
four_body=$(function_body four)
addr_body=$(function_body addr)
five_body=$(function_body five)
tail3_body=$(function_body tail3)
forward_body=$(function_body forward)
udivv_body=$(function_body udivv)
sdivv_body=$(function_body sdivv)
forward5_body=$(function_body forward5)
readp_body=$(function_body readp)
read2p_body=$(function_body read2p)
leafif_body=$(function_body leafif)
nullp_body=$(function_body nullp)
prepi_body=$(function_body prepi)
postpi_body=$(function_body postpi)
preps_body=$(function_body preps)
paira_body=$(function_body paira)
prepc_body=$(function_body prepc)
postpc_body=$(function_body postpc)
readc_body=$(function_body readc)
addrp_body=$(function_body addrp)

if printf '%s\n' "$one_body" | grep -q 'push[[:space:]]*17,0*10'; then
    echo "one: leaf parameter was unnecessarily moved to a preserved AC" >&2
    exit 1
fi
if printf '%s\n' "$one_body" | grep -q 'movem[[:space:]]*1,0(17)'; then
    echo "one: private parameter image was not eliminated" >&2
    exit 1
fi

if printf '%s\n' "$retadd_body" | grep -q 'push[[:space:]]*17,0*10'; then
    echo "retadd: one-argument leaf unnecessarily preserved AC10" >&2
    exit 1
fi
printf '%s\n' "$retadd_body" | grep -q 'addi[[:space:]]*1,1'
if printf '%s\n' "$call1_body" | grep -q 'move[[:space:]]*10,1'; then
    echo "call1: tail-only argument was unnecessarily moved to preserved AC10" >&2
    exit 1
fi
printf '%s\n' "$call1_body" | grep -q 'jrst[[:space:]]*h'
if printf '%s\n' "$call1_body" | grep -q 'pushj[[:space:]]*17,h'; then
    echo "call1: direct returned call was not tail-transferred" >&2
    exit 1
fi
printf '%s\n' "$calllocal_body" | grep -q 'move[[:space:]]*10,-1(17)'
if printf '%s\n' "$calllocal_body" | grep -q 'move[[:space:]]*16,'; then
    echo "calllocal: scalar local/call unnecessarily preserves AC16" >&2
    exit 1
fi
printf '%s\n' "$localaddr_body" | grep -q 'movei[[:space:]]*[0-9][0-9]*,0(17)'
printf '%s\n' "$localaddr_body" | grep -q 'move[[:space:]]*10,-1(17)'
if printf '%s\n' "$localaddr_body" | grep -q 'move[[:space:]]*16,'; then
    echo "localaddr: local address/call unnecessarily preserves AC16" >&2
    exit 1
fi
printf '%s\n' "$localaddr_body" | grep -q 'adjsp[[:space:]]*17,-2'
printf '%s\n' "$spillcall_body" | grep -q 'pushj[[:space:]]*17,hu'
printf '%s\n' "$spillcall_body" | grep -q 'adjsp[[:space:]]*17,-2'
if printf '%s\n' "$spillcall_body" | grep -q 'adjsp[[:space:]]*17,-5'; then
    echo "spillcall: live outer spills leaked into the call frame" >&2
    exit 1
fi
if printf '%s\n' "$regindex_body" | grep -q 'add[[:space:]]*10,'; then
    echo "regindex: pointer indexing destructively changed preserved AC10" >&2
    exit 1
fi
printf '%s\n' "$preword_body" | grep -q 'aos[[:space:]]*1,0(1)'
if printf '%s\n' "$preword_body" | grep -q 'push[[:space:]]*17,0*16'; then
    echo "preword: word increment unnecessarily preserved AC16" >&2
    exit 1
fi

for pair in '10,1' '11,2' '12,3' '13,4'; do
    if printf '%s\n' "$four_body" | grep -q "move[[:space:]]*$pair"; then
        echo "four: leaf argument was unnecessarily moved to preserved AC" >&2
        exit 1
    fi
done
if printf '%s\n' "$four_body" | grep -q 'push[[:space:]]*17,0*1[0-3]'; then
    echo "four: leaf arguments unnecessarily consumed preserved ACs" >&2
    exit 1
fi

printf '%s\n' "$addr_body" | grep -q 'movem[[:space:]]*1,0(17)'
printf '%s\n' "$five_body" | grep -q 'movem[[:space:]]*1,0(17)'
if printf '%s\n' "$tail3_body" | grep -q 'move[[:space:]]*[1-3],1[0-2]'; then
    echo "tail3: tail-only parameters were unnecessarily copied from preserved ACs" >&2
    exit 1
fi
printf '%s\n' "$tail3_body" | grep -q 'jrst[[:space:]]*h3'
if printf '%s\n' "$tail3_body" | grep -q 'move[[:space:]]*[1-4],-[0-9][0-9]*(17)'; then
    echo "tail3: direct ABI tail call reloaded arguments from a stack image" >&2
    exit 1
fi
printf '%s\n' "$forward_body" | grep -q 'jrst[[:space:]]*g'
if printf '%s\n' "$forward_body" | grep -q 'pushj[[:space:]]*17,g'; then
    echo "forward: remapped register-only return call was not tail-transferred" >&2
    exit 1
fi
if printf '%s\n' "$forward_body" | grep -q 'push[[:space:]]*17,0*1[0-3]'; then
    echo "forward: tail-only parameters unnecessarily consumed preserved ACs" >&2
    exit 1
fi
if printf '%s\n' "$forward_body" | grep -q 'push[[:space:]]*17,0*16'; then
    echo "forward: register permutation unnecessarily preserved AC16" >&2
    exit 1
fi
printf '%s\n' "$udivv_body" | grep -q 'push[[:space:]]*17,0*16'
if printf '%s\n' "$udivv_body" | grep -q '^ *[^;]*popj[[:space:]]*17' && \
   ! printf '%s\n' "$udivv_body" | grep -q 'move[[:space:]]*16,'; then
    echo "udivv: unsigned division failed to restore AC16" >&2
    exit 1
fi
printf '%s\n' "$sdivv_body" | grep -q 'idiv[[:space:]]'
if printf '%s\n' "$sdivv_body" | grep -q 'push[[:space:]]*17,0*16'; then
    echo "sdivv: signed division unnecessarily preserved AC16" >&2
    exit 1
fi
printf '%s\n' "$forward5_body" | grep -q 'pushj[[:space:]]*17,g5'
printf '%s\n' "$forward5_body" | grep -q 'push[[:space:]]*17'
if printf '%s\n' "$forward5_body" | grep -q 'push[[:space:]]*17,0*16'; then
    echo "forward5: ordinary five-argument direct call unnecessarily preserved AC16" >&2
    exit 1
fi

if printf '%s\n' "$readp_body" | grep -q 'push[[:space:]]*17,0*10'; then
    echo "readp: single-use leaf pointer parameter was unnecessarily preserved" >&2
    exit 1
fi
if printf '%s\n' "$read2p_body" | grep -q 'push[[:space:]]*17,0*10'; then
    echo "read2p: multi-use leaf pointer parameter was unnecessarily preserved" >&2
    exit 1
fi

if printf '%s\n' "$leafif_body" | grep -q 'push[[:space:]]*17,0*10'; then
    echo "leafif: conditional leaf parameter unnecessarily consumed preserved AC10" >&2
    exit 1
fi
if printf '%s\n' "$leafif_body" | grep -q 'push[[:space:]]*17,0*16'; then
    echo "leafif: neutral N_NODE container unnecessarily forced AC16 preservation" >&2
    exit 1
fi
if printf '%s\n' "$leafif_body" | grep -q 'movem[[:space:]]*[12],0(17)'; then
    echo "leafif: private parameter image was not eliminated" >&2
    exit 1
fi

if printf '%s\n' "$nullp_body" | grep -q 'setz[[:space:]]'; then
    echo "nullp: null pointer comparison materialized a zero register" >&2
    exit 1
fi
if printf '%s\n' "$nullp_body" | grep -q 'cam[en][[:space:]]'; then
    echo "nullp: null pointer comparison used a register-register compare" >&2
    exit 1
fi
printf '%s\n' "$nullp_body" | grep -q 'skip[en][[:space:]]'
if printf '%s\n' "$read2p_body" | grep -Eq '^[[:space:]]*dmove[[:space:]]+[0-9]+,1\(1\)'; then
    :       # Native pair covers both 1(1) and 2(1).
else
    printf '%s\n' "$read2p_body" | grep -q '1(1)'
    printf '%s\n' "$read2p_body" | grep -q '2(1)'
fi
if printf '%s\n' "$readp_body" | grep -q 'movem[[:space:]]*1,0(17)'; then
    echo "readp: pointer parameter was unnecessarily materialized" >&2
    exit 1
fi
printf '%s\n' "$prepi_body" | grep -q 'addi[[:space:]]*[0-9][0-9]*,1'
printf '%s\n' "$postpi_body" | grep -q 'addi[[:space:]]*[0-9][0-9]*,1'
printf '%s\n' "$preps_body" | grep -q 'addi[[:space:]]*[0-9][0-9]*,2'
printf '%s\n' "$paira_body" | grep -q 'move[[:space:]]*[0-9][0-9]*,0(1)'
for body in "$prepc_body" "$postpc_body"; do
    printf '%s\n' "$body" | grep -q 'ibp[[:space:]]*1'
    if printf '%s\n' "$body" | grep -q 'adjbp[[:space:]]'; then
        echo "char pointer increment regressed to general ADJBP" >&2
        exit 1
    fi
done
printf '%s\n' "$readc_body" | grep -q 'ldb[[:space:]]*[0-9][0-9]*,[0-9][0-9]*'
printf '%s\n' "$addrp_body" | grep -q 'movem[[:space:]]*1,0(17)'

printf '%s\n' "register ABI optimization tests passed"

cat > "$TMP/auto-init.c" <<'SRC'
int auto_init(int x)
{
    int y = x + 1;
    if (y > 4)
        return y;
    return 0;
}
SRC
( cd "$TMP" && "$KCC" -S auto-init.c >/dev/null )
if grep -Eiq '^[[:space:]]*push[[:space:]]+17,0*16([[:space:]]|$)' "$TMP/auto-init.s"; then
    echo "scalar automatic initializer unnecessarily preserves AC16" >&2
    exit 1
fi
