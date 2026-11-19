; DAS syntax port of upstream support/920428-1.s.
; Assembly-only: __main is the current GCC PDP-10 runtime entry for legacy ..main.
; Original source and expected machine behavior are not changed.
	TITLE	920428-1

	EXTERN %ONE,%BADX6,%BADX7,%BADX8,%BADX9,%BADXH

	.TEXT
	.TEXT
	ENTRY	x
x:
	xmovei 17,1(17)
	ldb 3,1
	xmovei 2,(17)
	tlo 2,730000
	adjbp 3,2
	move 2,3
	ldb 3,3
	iori 3,1
	dpb 3,2
	ibp 1
	came 1,1
	 tdza 4,4
	  movei 4,1
	move 1,4
	xmovei 17,-1(17)
	popj 17,

	.DATA
%LC0:
	.BYTE 9,0
	.TEXT
	ENTRY	main
main:
	pushj 17,__main
	skipa 1,.+1
	 OWGBP 070,GIW %LC0
	pushj 17,x
	caie 1,1
	jrst abort
	movei 1,0
	jrst exit


	EXTERN	abort
	EXTERN	exit
	EXTERN	__main

; expanded load unsigned 16  left:    0
; output   load unsigned 16  left:    0
; expanded load unsigned 16 right:    0
; output   load unsigned 16 right:    0
; expanded load unsigned 32:          0
; output   load unsigned 32:          0
; output   load   signed  9:          0
; expanded load   signed 16  left:    0
; output   load   signed 16  left:    0
; expanded load   signed 16 right:    0
; output   load   signed 16 right:    0
; expanded load   signed 32:          0
; output   load   signed 32:          0
; expanded load   signed:             0
; output   load   signed:             0
; expanded ffs:                       0

	END
