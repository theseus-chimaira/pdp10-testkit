/* Native counterpart to comp-goto-1.c. A virtual page is 4096 C bytes.
 * Translate byte offsets into word indices inside a genuine allocation;
 * never round a pointer's machine encoding as a flat integer address.
 */
#include <stdlib.h>
#include <stddef.h>

typedef unsigned long reg_t;
typedef union {
    struct {
        unsigned int offset : 18;
        unsigned int ignore : 4;
        unsigned int s1 : 8;
        unsigned int : 2;
        signed int simm : 14;
        unsigned int s3 : 8;
        unsigned int s2 : 8;
        unsigned int pad : 2;
    } f;
    double alignment;
} instruction;
typedef struct {
    unsigned long tag;
    reg_t *page;
} tlb_entry;
typedef struct {
    instruction *pc;
    reg_t regs[256];
    instruction *program;
    tlb_entry tlb[256];
} environment;
static instruction program[3];
volatile unsigned fail_id, loads;

static reg_t
execute(environment *env)
{
    static void *ops[] = { &&load, &&done };
    void *base = &&dispatch;
    instruction *pc = env->pc;
    instruction insn;
    unsigned int i, dst;
    reg_t address;
    tlb_entry *entry;

    for (i = 0; i < 3; ++i)
        env->program[i].f.offset =
            (unsigned int)((char *)ops[env->program[i].f.offset] -
                           (char *)base);
dispatch:
    insn = *pc++;
    dst = insn.f.s1;
    address = env->regs[insn.f.s2];
    goto *((char *)base + insn.f.offset);
load:
    entry = &env->tlb[(address / 4096UL) % 256UL];
    if (entry->tag != address / 4096UL ||
        address % sizeof(reg_t) != 0) {
        fail_id = 4;
        return 0;
    }
    env->regs[dst] =
        entry->page[(address % 4096UL) / sizeof(reg_t)];
    ++loads;
    goto dispatch;
done:
    return env->regs[dst];
}

int main(void)
{
    environment env;
    reg_t *page = (reg_t *)malloc(4096);
    instruction insn;
    unsigned long addr = 0x123450UL;
    unsigned int index = (unsigned int)((addr / 4096UL) % 256UL);
    fail_id = 1;
    if (!page) return 1;
    env.tlb[index].tag = addr / 4096UL;
    env.tlb[index].page = page;
    page[(addr % 4096UL) / sizeof(reg_t)] = 88;
    env.regs[0] = 0;
    env.regs[1] = 0;
    env.regs[2] = addr;
    insn.alignment = 0.0;
    insn.f.offset = 0;
    insn.f.s1 = 0;
    insn.f.s2 = 2;
    program[0] = insn;
    insn.f.s1 = 1;
    program[1] = insn;
    insn.f.offset = 1;
    insn.f.s1 = 1;
    insn.f.s2 = 2;
    program[2] = insn;
    env.pc = env.program = program;
    fail_id = 2;
    if (execute(&env) != 88) return 2;
    fail_id = 3;
    if (loads != 2 || env.regs[0] != 88 || env.regs[1] != 88)
        return 3;
    free(page);
    fail_id = 0;
    return 0;
}
