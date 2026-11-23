/* GCC PDP-10 must expose the generic and historical lowercase target
   predefined macros through its driver on every supported CPU profile.
   Upstream source uses __pdp10__ to exclude unavailable hosted calls.  */

#ifndef __PDP10__
#error missing canonical PDP-10 target identification
#endif

#ifndef __pdp10__
#error missing lowercase PDP-10 target identification
#endif

#if __PDP10__ != 1 || __pdp10__ != 1
#error inconsistent PDP-10 target macro values
#endif

int
main(void)
{
    return __PDP10__ != __pdp10__;
}
