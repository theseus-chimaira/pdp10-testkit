.text
f:
	movei 1,1
	popj 17,

uf:
	movei 1,1
	popj 17,

clobber:
	popj 17,

use_int:
	popj 17,

use_uint:
	popj 17,

use_sint:
	popj 17,

use_usint:
	popj 17,

use_dint:
	popj 17,

use_udint:
	popj 17,

use_ptr:
	popj 17,

use_intp:
	popj 17,

use_sintp:
	popj 17,

use_char6p:
	popj 17,

use_short18p:
	popj 17,

use_char_pointer:
	popj 17,

use_uchar_pointer:
	popj 17,

; Minimal byte-pointer helpers used by KCC builtin lowering tests.
; GCC-compatible KCC ABI: AC1=dst, AC2=src, AC3=n; memcpy returns dst.
memcpy:
	move	4,1
	move	5,2
	move	6,3
	jumpe	6,memcpy_done
memcpy_loop:
	ldb	7,5
	dpb	7,4
	ibp	5
	ibp	4
	sojg	6,memcpy_loop
memcpy_done:
	popj	17,

; memset(dst, c, n) returns dst.
memset:
	move	1,-1(17)
	move	2,-1(17)
	move	5,-2(17)
	move	4,-3(17)
	jumpe	4,memset_done
memset_loop:
	dpb	5,2
	ibp	2
	sojg	4,memset_loop
memset_done:
	popj	17,
