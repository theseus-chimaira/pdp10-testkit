/* Host-side equivalents for native DAIMOS phase system calls in tests.
 * The phase byte-identity harness runs DAIMOS-profile compiler components
 * as hosted Unix processes.  Unlink must retain its filesystem semantics
 * so the regression checks the real phase lifecycle, not a no-op stub.
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void
daimos_unlink_path(char *name)
{
    /* The native helper deliberately ignores dsys_unlink's result. */
    (void)unlink(name);
}

/* Native DAIMOS RUN/EXEC chaining cannot occur in a hosted test.  Fail
 * closed if a phase inadvertently tries to take that code path.
 */
int
daimos_exec_kopt(char *source, char *output)
{
    (void)source;
    (void)output;
    fputs("unexpected native DAIMOS phase chaining in host test\n", stderr);
    exit(126);
}

int
daimos_exec_kgen(char *input, char *kpcode, char *output, int optimize)
{
    (void)input;
    (void)kpcode;
    (void)output;
    (void)optimize;
    fputs("unexpected native DAIMOS KPARSE/KGEN chaining in host test\n",
          stderr);
    exit(126);
}
