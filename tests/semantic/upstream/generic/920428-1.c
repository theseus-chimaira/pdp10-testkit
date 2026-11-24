/* The historical uninitialized a[0] was read by |= before being written.
 * That makes the original upstream test undefined even though its purpose
 * is only to verify that the postincrement of s is preserved.  Initialize
 * a[0] so a compiler is tested against defined C semantics; keep the
 * pointer arithmetic and the original comparison unchanged.  */
x(const char*s){char a[1]={0};const char*ss=s;a[*s++]|=1;return(int)(ss+1)==(int)s;}
main(){if(x("")!=1)abort();exit(0);}

