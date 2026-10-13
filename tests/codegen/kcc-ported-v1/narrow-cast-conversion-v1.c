/* KCC source and original assembly policies. */
/* codegen-require-regex: "(?ims)\\A(?:(?!^\\s*trne\\s*1,0*40$).)*^\\s*trne\\s*1,0*40$[^\\n]*\\n(?:(?!^\\s*trne\\s*1,0*40$).)*\\Z" "(?ims)\\A(?:(?!^\\s*trne\\s*1,0*400).)*^\\s*trne\\s*1,0*400[^\\n]*\\n(?:(?!^\\s*trne\\s*1,0*400).)*\\Z" "(?ims)\\A(?:(?!^\\s*andi\\s*1,0*77$).)*^\\s*andi\\s*1,0*77$[^\\n]*\\n(?:(?!^\\s*andi\\s*1,0*77$).)*^\\s*andi\\s*1,0*77$[^\\n]*\\n(?:(?!^\\s*andi\\s*1,0*77$).)*\\Z" "(?ims)\\A(?:(?!^\\s*andi\\s*1,0*777).)*^\\s*andi\\s*1,0*777[^\\n]*\\n(?:(?!^\\s*andi\\s*1,0*777).)*^\\s*andi\\s*1,0*777[^\\n]*\\n(?:(?!^\\s*andi\\s*1,0*777).)*\\Z" */
typedef signed _KCCtype_char6 s6;
typedef unsigned _KCCtype_char6 u6;
typedef signed _KCCtype_char9 s9;
typedef unsigned _KCCtype_char9 u9;
int cs6(int x) { return (s6)x; }
int cu6(int x) { return (u6)x; }
int cs9(int x) { return (s9)x; }
int cu9(int x) { return (u9)x; }
