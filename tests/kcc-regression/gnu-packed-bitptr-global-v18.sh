#!/bin/sh
set -eu
testroot=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
. "$testroot/kcc-env.sh"
kcc_setup_env
root=$PDP10_PREFIX/lib/kcc
KCC=$PDP10_PREFIX/bin/kcc
tmp=${TMPDIR:-/tmp}/kcc-gnu-packed-bitptr-global-v18-$$
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir -p "$tmp"

cat > "$tmp/store.c" <<'SRC'
typedef unsigned _KCCtype_char16 u16;
struct req_v18 { u16 *input; };
u16 *global_ptr_v18;
struct req_v18 global_req_v18;
void save_global_v18(u16 *p)
{
    global_ptr_v18 = p;
    global_req_v18.input = p;
}
SRC

cat > "$tmp/access.c" <<'SRC'
typedef unsigned _KCCtype_char16 u16;
struct req_v18 { u16 *input; };
extern u16 *global_ptr_v18;
extern struct req_v18 global_req_v18;
u16 read_ptr_v18(int i) { return global_ptr_v18[i]; }
u16 read_req_v18(int i) { return global_req_v18.input[i]; }
void write_ptr_v18(int i, u16 v) { global_ptr_v18[i] = v; }
void write_req_v18(int i, u16 v) { global_req_v18.input[i] = v; }
SRC

cat > "$tmp/main.c" <<'SRC'
volatile int __test_exit;
typedef unsigned _KCCtype_char16 u16;
struct outer_v18 {
    unsigned int pre:5;
    u16 a[3];
    unsigned int post:4;
} __attribute__((packed));
static struct outer_v18 packed_v18;
static u16 plain_v18[3];
extern void save_global_v18(u16 *);
extern u16 read_ptr_v18(int);
extern u16 read_req_v18(int);
extern void write_ptr_v18(int, u16);
extern void write_req_v18(int, u16);
int main(void)
{
    packed_v18.pre = 025;
    packed_v18.post = 011;
    packed_v18.a[0] = 01111;
    packed_v18.a[1] = 02222;
    packed_v18.a[2] = 03333;
    plain_v18[0] = 04444;
    plain_v18[1] = 05555;
    plain_v18[2] = 06666;

    save_global_v18(packed_v18.a);
    if (read_ptr_v18(0) != 01111 || read_ptr_v18(1) != 02222
      || read_ptr_v18(2) != 03333) return 1;
    if (read_req_v18(0) != 01111 || read_req_v18(1) != 02222
      || read_req_v18(2) != 03333) return 2;
    write_ptr_v18(1, 012345);
    write_req_v18(2, 023456);
    if (packed_v18.a[1] != 012345 || packed_v18.a[2] != 023456) return 3;

    save_global_v18(plain_v18);
    if (read_ptr_v18(0) != 04444 || read_ptr_v18(1) != 05555
      || read_ptr_v18(2) != 06666) return 4;
    if (read_req_v18(0) != 04444 || read_req_v18(1) != 05555
      || read_req_v18(2) != 06666) return 5;
    write_ptr_v18(1, 034567);
    write_req_v18(2, 045670);
    if (plain_v18[1] != 034567 || plain_v18[2] != 045670) return 6;
    if (packed_v18.pre != 025 || packed_v18.post != 011) return 7;
    return 0;
}
SRC

cd "$tmp"
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackglob18s store.c
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackglob18a access.c
TERM=dumb "$KCC" -S -v=nostats -x=pdp6 -R=gpackglob18m main.c
"$P10RUN" --machine pdp6 --mode deposit --exec-mode step \
    --step-limit 18000000 --timeout 30 --workdir "$tmp/run" \
    --name gnu-packed-bitptr-global-v18 --expect __test_exit=0 \
    "$testroot/semantic-crt0.s" "$tmp/gpackglob18s.s" \
    "$tmp/gpackglob18a.s" "$tmp/gpackglob18m.s" "$KCC_RT" >/dev/null
printf '%s\n' 'GNU packed global exact-width pointer round-trip regression passed'
