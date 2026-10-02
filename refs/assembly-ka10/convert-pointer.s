
arg1__:
	jrst bar1__

stack1__:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar1__
	add 17,[-1,,-1]
	popj 17,

	.bss
x%0:
	.space	4

global1__:
	move 1,[POINT 18,x%0,35]
	jrst bar1__

ret1__:
	popj 17,

round1__:
	popj 17,

voidret1__:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%1:
	.space	4

save1__:
	movem 1,p%1
	movem 1,vp_sink
	popj 17,

cmp1__:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff1__:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load1__:
	ldb 1,1
	popj 17,

store1__:
	dpb 2,1
	popj 17,

arg1s_:
	jrst bar1s_

stack1s_:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar1s_
	add 17,[-1,,-1]
	popj 17,

	.bss
x%2:
	.space	4

global1s_:
	move 1,[POINT 18,x%2,35]
	jrst bar1s_

ret1s_:
	popj 17,

round1s_:
	popj 17,

voidret1s_:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%3:
	.space	4

save1s_:
	movem 1,p%3
	movem 1,vp_sink
	popj 17,

cmp1s_:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff1s_:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load1s_:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store1s_:
	dpb 2,1
	popj 17,

arg1u_:
	jrst bar1u_

stack1u_:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar1u_
	add 17,[-1,,-1]
	popj 17,

	.bss
x%4:
	.space	4

global1u_:
	move 1,[POINT 18,x%4,35]
	jrst bar1u_

ret1u_:
	popj 17,

round1u_:
	popj 17,

voidret1u_:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%5:
	.space	4

save1u_:
	movem 1,p%5
	movem 1,vp_sink
	popj 17,

cmp1u_:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff1u_:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load1u_:
	ldb 1,1
	popj 17,

store1u_:
	dpb 2,1
	popj 17,

arg1_s:
	jrst bar1_s

stack1_s:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar1_s
	add 17,[-1,,-1]
	popj 17,

	.bss
x%6:
	.space	4

global1_s:
	move 1,[POINT 18,x%6,35]
	jrst bar1_s

ret1_s:
	popj 17,

round1_s:
	popj 17,

voidret1_s:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%7:
	.space	4

save1_s:
	movem 1,p%7
	movem 1,vp_sink
	popj 17,

cmp1_s:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff1_s:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load1_s:
	ldb 1,1
	popj 17,

store1_s:
	dpb 2,1
	popj 17,

arg1ss:
	jrst bar1ss

stack1ss:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar1ss
	add 17,[-1,,-1]
	popj 17,

	.bss
x%8:
	.space	4

global1ss:
	move 1,[POINT 18,x%8,35]
	jrst bar1ss

ret1ss:
	popj 17,

round1ss:
	popj 17,

voidret1ss:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%9:
	.space	4

save1ss:
	movem 1,p%9
	movem 1,vp_sink
	popj 17,

cmp1ss:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff1ss:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load1ss:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store1ss:
	dpb 2,1
	popj 17,

arg1us:
	jrst bar1us

stack1us:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar1us
	add 17,[-1,,-1]
	popj 17,

	.bss
x%10:
	.space	4

global1us:
	move 1,[POINT 18,x%10,35]
	jrst bar1us

ret1us:
	popj 17,

round1us:
	popj 17,

voidret1us:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%11:
	.space	4

save1us:
	movem 1,p%11
	movem 1,vp_sink
	popj 17,

cmp1us:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff1us:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load1us:
	ldb 1,1
	popj 17,

store1us:
	dpb 2,1
	popj 17,

arg1_u:
	jrst bar1_u

stack1_u:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar1_u
	add 17,[-1,,-1]
	popj 17,

	.bss
x%12:
	.space	4

global1_u:
	move 1,[POINT 18,x%12,35]
	jrst bar1_u

ret1_u:
	popj 17,

round1_u:
	popj 17,

voidret1_u:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%13:
	.space	4

save1_u:
	movem 1,p%13
	movem 1,vp_sink
	popj 17,

cmp1_u:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff1_u:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load1_u:
	ldb 1,1
	popj 17,

store1_u:
	dpb 2,1
	popj 17,

arg1su:
	jrst bar1su

stack1su:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar1su
	add 17,[-1,,-1]
	popj 17,

	.bss
x%14:
	.space	4

global1su:
	move 1,[POINT 18,x%14,35]
	jrst bar1su

ret1su:
	popj 17,

round1su:
	popj 17,

voidret1su:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%15:
	.space	4

save1su:
	movem 1,p%15
	movem 1,vp_sink
	popj 17,

cmp1su:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff1su:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load1su:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store1su:
	dpb 2,1
	popj 17,

arg1uu:
	jrst bar1uu

stack1uu:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar1uu
	add 17,[-1,,-1]
	popj 17,

	.bss
x%16:
	.space	4

global1uu:
	move 1,[POINT 18,x%16,35]
	jrst bar1uu

ret1uu:
	popj 17,

round1uu:
	popj 17,

voidret1uu:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%17:
	.space	4

save1uu:
	movem 1,p%17
	movem 1,vp_sink
	popj 17,

cmp1uu:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff1uu:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load1uu:
	ldb 1,1
	popj 17,

store1uu:
	dpb 2,1
	popj 17,

arg2__:
	jrst bar2__

stack2__:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar2__
	add 17,[-1,,-1]
	popj 17,

	.bss
x%18:
	.space	4

global2__:
	move 1,[POINT 18,x%18,35]
	jrst bar2__

ret2__:
	popj 17,

round2__:
	popj 17,

voidret2__:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L269
	move 11,1
	tlc 11,113300
%L269:
	pushj 17,clobber
	jumpe 11,%L270
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L270:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%19:
	.space	4

save2__:
	movem 1,p%19
	jumpe 1,%L272
	move 4,1
	tlc 4,113300
%L272:
	movem 4,vp_sink
	popj 17,

cmp2__:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff2__:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

load2__:
	ldb 1,1
	hrre 1,1
	popj 17,

store2__:
	dpb 2,1	; movhi
	popj 17,

arg2s_:
	jrst bar2s_

stack2s_:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar2s_
	add 17,[-1,,-1]
	popj 17,

	.bss
x%20:
	.space	4

global2s_:
	move 1,[POINT 18,x%20,35]
	jrst bar2s_

ret2s_:
	popj 17,

round2s_:
	popj 17,

voidret2s_:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L289
	move 11,1
	tlc 11,113300
%L289:
	pushj 17,clobber
	jumpe 11,%L290
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L290:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%21:
	.space	4

save2s_:
	movem 1,p%21
	jumpe 1,%L292
	move 4,1
	tlc 4,113300
%L292:
	movem 4,vp_sink
	popj 17,

cmp2s_:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff2s_:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

load2s_:
	ldb 1,1
	hrre 1,1
	popj 17,

store2s_:
	dpb 2,1	; movhi
	popj 17,

arg2u_:
	jrst bar2u_

stack2u_:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar2u_
	add 17,[-1,,-1]
	popj 17,

	.bss
x%22:
	.space	4

global2u_:
	move 1,[POINT 18,x%22,35]
	jrst bar2u_

ret2u_:
	popj 17,

round2u_:
	popj 17,

voidret2u_:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L318
	move 11,1
	tlc 11,113300
%L318:
	pushj 17,clobber
	jumpe 11,%L319
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L319:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%23:
	.space	4

save2u_:
	movem 1,p%23
	jumpe 1,%L322
	move 4,1
	tlc 4,113300
%L322:
	movem 4,vp_sink
	popj 17,

cmp2u_:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff2u_:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

load2u_:
	ldb 1,1
	popj 17,

store2u_:
	dpb 2,1	; movhi
	popj 17,

arg2_s:
	jrst bar2_s

stack2_s:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar2_s
	add 17,[-1,,-1]
	popj 17,

	.bss
x%24:
	.space	4

global2_s:
	move 1,[POINT 18,x%24,35]
	jrst bar2_s

ret2_s:
	popj 17,

round2_s:
	popj 17,

voidret2_s:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L342
	move 11,1
	tlc 11,113300
%L342:
	pushj 17,clobber
	jumpe 11,%L343
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L343:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%25:
	.space	4

save2_s:
	movem 1,p%25
	jumpe 1,%L345
	move 4,1
	tlc 4,113300
%L345:
	movem 4,vp_sink
	popj 17,

cmp2_s:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff2_s:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

load2_s:
	ldb 1,1
	hrre 1,1
	popj 17,

store2_s:
	dpb 2,1	; movhi
	popj 17,

arg2ss:
	jrst bar2ss

stack2ss:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar2ss
	add 17,[-1,,-1]
	popj 17,

	.bss
x%26:
	.space	4

global2ss:
	move 1,[POINT 18,x%26,35]
	jrst bar2ss

ret2ss:
	popj 17,

round2ss:
	popj 17,

voidret2ss:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L362
	move 11,1
	tlc 11,113300
%L362:
	pushj 17,clobber
	jumpe 11,%L363
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L363:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%27:
	.space	4

save2ss:
	movem 1,p%27
	jumpe 1,%L365
	move 4,1
	tlc 4,113300
%L365:
	movem 4,vp_sink
	popj 17,

cmp2ss:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff2ss:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

load2ss:
	ldb 1,1
	hrre 1,1
	popj 17,

store2ss:
	dpb 2,1	; movhi
	popj 17,

arg2us:
	jrst bar2us

stack2us:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar2us
	add 17,[-1,,-1]
	popj 17,

	.bss
x%28:
	.space	4

global2us:
	move 1,[POINT 18,x%28,35]
	jrst bar2us

ret2us:
	popj 17,

round2us:
	popj 17,

voidret2us:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L391
	move 11,1
	tlc 11,113300
%L391:
	pushj 17,clobber
	jumpe 11,%L392
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L392:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%29:
	.space	4

save2us:
	movem 1,p%29
	jumpe 1,%L395
	move 4,1
	tlc 4,113300
%L395:
	movem 4,vp_sink
	popj 17,

cmp2us:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff2us:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

load2us:
	ldb 1,1
	popj 17,

store2us:
	dpb 2,1	; movhi
	popj 17,

arg2_u:
	jrst bar2_u

stack2_u:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar2_u
	add 17,[-1,,-1]
	popj 17,

	.bss
x%30:
	.space	4

global2_u:
	move 1,[POINT 18,x%30,35]
	jrst bar2_u

ret2_u:
	popj 17,

round2_u:
	popj 17,

voidret2_u:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L424
	move 11,1
	tlc 11,113300
%L424:
	pushj 17,clobber
	jumpe 11,%L425
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L425:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%31:
	.space	4

save2_u:
	movem 1,p%31
	jumpe 1,%L428
	move 4,1
	tlc 4,113300
%L428:
	movem 4,vp_sink
	popj 17,

cmp2_u:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff2_u:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

load2_u:
	ldb 1,1
	hrre 1,1
	popj 17,

store2_u:
	dpb 2,1	; movhi
	popj 17,

arg2su:
	jrst bar2su

stack2su:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar2su
	add 17,[-1,,-1]
	popj 17,

	.bss
x%32:
	.space	4

global2su:
	move 1,[POINT 18,x%32,35]
	jrst bar2su

ret2su:
	popj 17,

round2su:
	popj 17,

voidret2su:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L457
	move 11,1
	tlc 11,113300
%L457:
	pushj 17,clobber
	jumpe 11,%L458
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L458:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%33:
	.space	4

save2su:
	movem 1,p%33
	jumpe 1,%L461
	move 4,1
	tlc 4,113300
%L461:
	movem 4,vp_sink
	popj 17,

cmp2su:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff2su:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

load2su:
	ldb 1,1
	hrre 1,1
	popj 17,

store2su:
	dpb 2,1	; movhi
	popj 17,

arg2uu:
	jrst bar2uu

stack2uu:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bar2uu
	add 17,[-1,,-1]
	popj 17,

	.bss
x%34:
	.space	4

global2uu:
	move 1,[POINT 18,x%34,35]
	jrst bar2uu

ret2uu:
	popj 17,

round2uu:
	popj 17,

voidret2uu:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L481
	move 11,1
	tlc 11,113300
%L481:
	pushj 17,clobber
	jumpe 11,%L482
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L482:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%35:
	.space	4

save2uu:
	movem 1,p%35
	jumpe 1,%L484
	move 4,1
	tlc 4,113300
%L484:
	movem 4,vp_sink
	popj 17,

cmp2uu:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff2uu:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

load2uu:
	ldb 1,1
	popj 17,

store2uu:
	dpb 2,1	; movhi
	popj 17,

arg3__:
	jrst bar3__

stack3__:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bar3__
	add 17,[-1,,-1]
	popj 17,

	.bss
x%36:
	.space	4

global3__:
	movei 1,x%36
	jrst bar3__

ret3__:
	popj 17,

round3__:
	popj 17,

voidret3__:
	push 17,10
	jumpe 1,%L501
	move 10,1
	tlo 10,331100
%L501:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%37:
	.space	4

save3__:
	movem 1,p%37
	jumpe 1,%L504
	move 4,1
	tlo 4,331100
%L504:
	movem 4,vp_sink
	popj 17,

cmp3__:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff3__:
	sub 1,2
	popj 17,

load3__:
	move 1,(1)
	popj 17,

store3__:
	movem 2,(1)
	popj 17,

arg3s_:
	jrst bar3s_

stack3s_:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bar3s_
	add 17,[-1,,-1]
	popj 17,

	.bss
x%38:
	.space	4

global3s_:
	movei 1,x%38
	jrst bar3s_

ret3s_:
	popj 17,

round3s_:
	popj 17,

voidret3s_:
	push 17,10
	jumpe 1,%L521
	move 10,1
	tlo 10,331100
%L521:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%39:
	.space	4

save3s_:
	movem 1,p%39
	jumpe 1,%L524
	move 4,1
	tlo 4,331100
%L524:
	movem 4,vp_sink
	popj 17,

cmp3s_:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff3s_:
	sub 1,2
	popj 17,

load3s_:
	move 1,(1)
	popj 17,

store3s_:
	movem 2,(1)
	popj 17,

arg3u_:
	jrst bar3u_

stack3u_:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bar3u_
	add 17,[-1,,-1]
	popj 17,

	.bss
x%40:
	.space	4

global3u_:
	movei 1,x%40
	jrst bar3u_

ret3u_:
	popj 17,

round3u_:
	popj 17,

voidret3u_:
	push 17,10
	jumpe 1,%L550
	move 10,1
	tlo 10,331100
%L550:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%41:
	.space	4

save3u_:
	movem 1,p%41
	jumpe 1,%L554
	move 4,1
	tlo 4,331100
%L554:
	movem 4,vp_sink
	popj 17,

cmp3u_:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff3u_:
	sub 1,2
	popj 17,

load3u_:
	move 1,(1)
	popj 17,

store3u_:
	movem 2,(1)
	popj 17,

arg3_s:
	jrst bar3_s

stack3_s:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bar3_s
	add 17,[-1,,-1]
	popj 17,

	.bss
x%42:
	.space	4

global3_s:
	movei 1,x%42
	jrst bar3_s

ret3_s:
	popj 17,

round3_s:
	popj 17,

voidret3_s:
	push 17,10
	jumpe 1,%L574
	move 10,1
	tlo 10,331100
%L574:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%43:
	.space	4

save3_s:
	movem 1,p%43
	jumpe 1,%L577
	move 4,1
	tlo 4,331100
%L577:
	movem 4,vp_sink
	popj 17,

cmp3_s:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff3_s:
	sub 1,2
	popj 17,

load3_s:
	move 1,(1)
	popj 17,

store3_s:
	movem 2,(1)
	popj 17,

arg3ss:
	jrst bar3ss

stack3ss:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bar3ss
	add 17,[-1,,-1]
	popj 17,

	.bss
x%44:
	.space	4

global3ss:
	movei 1,x%44
	jrst bar3ss

ret3ss:
	popj 17,

round3ss:
	popj 17,

voidret3ss:
	push 17,10
	jumpe 1,%L594
	move 10,1
	tlo 10,331100
%L594:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%45:
	.space	4

save3ss:
	movem 1,p%45
	jumpe 1,%L597
	move 4,1
	tlo 4,331100
%L597:
	movem 4,vp_sink
	popj 17,

cmp3ss:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff3ss:
	sub 1,2
	popj 17,

load3ss:
	move 1,(1)
	popj 17,

store3ss:
	movem 2,(1)
	popj 17,

arg3us:
	jrst bar3us

stack3us:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bar3us
	add 17,[-1,,-1]
	popj 17,

	.bss
x%46:
	.space	4

global3us:
	movei 1,x%46
	jrst bar3us

ret3us:
	popj 17,

round3us:
	popj 17,

voidret3us:
	push 17,10
	jumpe 1,%L623
	move 10,1
	tlo 10,331100
%L623:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%47:
	.space	4

save3us:
	movem 1,p%47
	jumpe 1,%L627
	move 4,1
	tlo 4,331100
%L627:
	movem 4,vp_sink
	popj 17,

cmp3us:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff3us:
	sub 1,2
	popj 17,

load3us:
	move 1,(1)
	popj 17,

store3us:
	movem 2,(1)
	popj 17,

arg3_u:
	jrst bar3_u

stack3_u:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bar3_u
	add 17,[-1,,-1]
	popj 17,

	.bss
x%48:
	.space	4

global3_u:
	movei 1,x%48
	jrst bar3_u

ret3_u:
	popj 17,

round3_u:
	popj 17,

voidret3_u:
	push 17,10
	jumpe 1,%L656
	move 10,1
	tlo 10,331100
%L656:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%49:
	.space	4

save3_u:
	movem 1,p%49
	jumpe 1,%L660
	move 4,1
	tlo 4,331100
%L660:
	movem 4,vp_sink
	popj 17,

cmp3_u:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff3_u:
	sub 1,2
	popj 17,

load3_u:
	move 1,(1)
	popj 17,

store3_u:
	movem 2,(1)
	popj 17,

arg3su:
	jrst bar3su

stack3su:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bar3su
	add 17,[-1,,-1]
	popj 17,

	.bss
x%50:
	.space	4

global3su:
	movei 1,x%50
	jrst bar3su

ret3su:
	popj 17,

round3su:
	popj 17,

voidret3su:
	push 17,10
	jumpe 1,%L689
	move 10,1
	tlo 10,331100
%L689:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%51:
	.space	4

save3su:
	movem 1,p%51
	jumpe 1,%L693
	move 4,1
	tlo 4,331100
%L693:
	movem 4,vp_sink
	popj 17,

cmp3su:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff3su:
	sub 1,2
	popj 17,

load3su:
	move 1,(1)
	popj 17,

store3su:
	movem 2,(1)
	popj 17,

arg3uu:
	jrst bar3uu

stack3uu:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bar3uu
	add 17,[-1,,-1]
	popj 17,

	.bss
x%52:
	.space	4

global3uu:
	movei 1,x%52
	jrst bar3uu

ret3uu:
	popj 17,

round3uu:
	popj 17,

voidret3uu:
	push 17,10
	jumpe 1,%L713
	move 10,1
	tlo 10,331100
%L713:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%53:
	.space	4

save3uu:
	movem 1,p%53
	jumpe 1,%L716
	move 4,1
	tlo 4,331100
%L716:
	movem 4,vp_sink
	popj 17,

cmp3uu:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diff3uu:
	sub 1,2
	popj 17,

load3uu:
	move 1,(1)
	popj 17,

store3uu:
	movem 2,(1)
	popj 17,

argchar_short:
	jumpe 1,%L724
	move 4,1
	tlc 4,113300
%L724:
	move 1,4
	jrst barchar_short

stackchar_short:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	tlc 1,113300
	pushj 17,barchar_short
	add 17,[-1,,-1]
	popj 17,

	.bss
x%54:
	.space	4

globalchar_short:
	move 1,[POINT 9,x%54,26]
	jrst barchar_short

retchar_short:
	jumpe 1,%L737
	move 4,1
	tlc 4,113300
%L737:
	move 1,4
	popj 17,

roundchar_short:
	jumpe 1,%L740
	move 3,1
	tlc 3,113300
%L740:
	jumpe 3,%L739
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L739:
	move 1,4
	popj 17,

voidretchar_short:
	push 17,10
	jumpe 1,%L742
	move 10,1
	tlc 10,113300
%L742:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%55:
	.space	4

savechar_short:
	jumpe 1,%L745
	move 4,1
	tlc 4,113300
%L745:
	movem 4,p%55
	movem 4,vp_sink
	popj 17,

cmpchar_short:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffchar_short:
	jumpe 1,%L750
	move 3,1
	tlc 3,113300
%L750:
	move 4,3
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

loadchar_short:
	jumpe 1,%L753
	move 4,1
	tlc 4,113300
%L753:
	ldb 1,4
	popj 17,

storechar_short:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L755
	move 4,1
	tlc 4,113300
%L755:
	dpb 2,4
	popj 17,

argchar_int:
	jumpe 1,%L757
	move 4,1
	tlo 4,331100
%L757:
	move 1,4
	jrst barchar_int

stackchar_int:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,331100
	pushj 17,barchar_int
	add 17,[-1,,-1]
	popj 17,

	.bss
x%56:
	.space	4

globalchar_int:
	move 1,[POINT 9,x%56,8]
	jrst barchar_int

retchar_int:
	jumpe 1,%L770
	move 4,1
	tlo 4,331100
%L770:
	move 1,4
	popj 17,

roundchar_int:
	popj 17,

voidretchar_int:
	push 17,10
	jumpe 1,%L774
	move 10,1
	tlo 10,331100
%L774:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%57:
	.space	4

savechar_int:
	jumpe 1,%L777
	move 4,1
	tlo 4,331100
%L777:
	movem 4,p%57
	movem 4,vp_sink
	popj 17,

cmpchar_int:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffchar_int:
	jumpe 1,%L782
	move 4,1
	tlo 4,331100
%L782:
	sub 4,2
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

loadchar_int:
	jumpe 1,%L785
	move 4,1
	tlo 4,331100
%L785:
	ldb 1,4
	popj 17,

storechar_int:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L787
	move 4,1
	tlo 4,331100
%L787:
	dpb 2,4
	popj 17,

argshort_char:
	jumpe 1,%L789
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L789:
	move 1,4
	jrst barshort_char

stackshort_char:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	tlc 1,3300
	pushj 17,barshort_char
	add 17,[-1,,-1]
	popj 17,

	.bss
x%58:
	.space	4

globalshort_char:
	move 1,[POINT 18,x%58,35]
	jrst barshort_char

retshort_char:
	jumpe 1,%L802
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L802:
	move 1,4
	popj 17,

roundshort_char:
	jumpe 1,%L805
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L805:
	jumpe 4,%L804
	move 3,4
	tlc 3,113300
%L804:
	move 1,3
	popj 17,

voidretshort_char:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,clobber
	jumpe 11,%L808
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L808:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%59:
	.space	4

saveshort_char:
	jumpe 1,%L810
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L810:
	movem 4,p%59
	jumpe 4,%L811
	move 3,4
	tlc 3,113300
%L811:
	movem 3,vp_sink
	popj 17,

cmpshort_char:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffshort_char:
	jumpe 1,%L815
	move 3,1
	tlc 3,3300
	tlz 3,110000
%L815:
	move 4,3
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-1
	popj 17,

loadshort_char:
	jumpe 1,%L818
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L818:
	ldb 1,4
	hrre 1,1
	popj 17,

storeshort_char:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L820
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L820:
	dpb 2,4	; movhi
	popj 17,

argshort_int:
	jumpe 1,%L822
	move 4,1
	tlo 4,222200
%L822:
	move 1,4
	jrst barshort_int

stackshort_int:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,222200
	pushj 17,barshort_int
	add 17,[-1,,-1]
	popj 17,

	.bss
x%60:
	.space	4

globalshort_int:
	move 1,[POINT 18,x%60,17]
	jrst barshort_int

retshort_int:
	jumpe 1,%L835
	move 4,1
	tlo 4,222200
%L835:
	move 1,4
	popj 17,

roundshort_int:
	popj 17,

voidretshort_int:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L839
	move 11,1
	tlo 11,331100
%L839:
	pushj 17,clobber
	jumpe 11,%L840
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L840:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%61:
	.space	4

saveshort_int:
	jumpe 1,%L842
	move 4,1
	tlo 4,222200
%L842:
	movem 4,p%61
	jumpe 4,%L843
	move 3,4
	tlc 3,113300
%L843:
	movem 3,vp_sink
	popj 17,

cmpshort_int:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffshort_int:
	jumpe 1,%L847
	move 4,1
	tlo 4,222200
%L847:
	sub 4,2
	ash 4,1
	move 1,4
	popj 17,

loadshort_int:
	jumpe 1,%L850
	move 4,1
	tlo 4,222200
%L850:
	ldb 1,4
	hrre 1,1
	popj 17,

storeshort_int:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L852
	move 4,1
	tlo 4,222200
%L852:
	dpb 2,4	; movhi
	popj 17,

argint_char:
	hrrz 1,1
	jrst barint_char

stackint_char:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barint_char
	add 17,[-1,,-1]
	popj 17,

	.bss
x%62:
	.space	4

globalint_char:
	movei 1,x%62
	jrst barint_char

retint_char:
	hrrz 1,1
	popj 17,

roundint_char:
	hrrz 1,1
	jumpe 1,%L869
	move 4,1
	tlo 4,331100
%L869:
	move 1,4
	popj 17,

voidretint_char:
	push 17,10
	move 10,1
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%63:
	.space	4

saveint_char:
	hrrz 1,1
	movem 1,p%63
	jumpe 1,%L876
	move 4,1
	tlo 4,331100
%L876:
	movem 4,vp_sink
	popj 17,

cmpint_char:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffint_char:
	hrrz 1,1
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-2
	popj 17,

loadint_char:
	hrrz 1,1
	move 1,(1)
	popj 17,

storeint_char:
	hrrz 1,1
	movem 2,(1)
	popj 17,

argint_short:
	hrrz 1,1
	jrst barint_short

stackint_short:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barint_short
	add 17,[-1,,-1]
	popj 17,

	.bss
x%64:
	.space	4

globalint_short:
	movei 1,x%64
	jrst barint_short

retint_short:
	hrrz 1,1
	popj 17,

roundint_short:
	hrrz 1,1
	jumpe 1,%L902
	move 4,1
	tlo 4,222200
%L902:
	move 1,4
	popj 17,

voidretint_short:
	push 17,10
	jumpe 1,%L905
	move 10,1
	tlc 10,113300
%L905:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%65:
	.space	4

saveint_short:
	hrrz 1,1
	movem 1,p%65
	jumpe 1,%L909
	move 4,1
	tlo 4,331100
%L909:
	movem 4,vp_sink
	popj 17,

cmpint_short:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffint_short:
	hrrz 1,1
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,-1
	popj 17,

loadint_short:
	hrrz 1,1
	move 1,(1)
	popj 17,

storeint_short:
	hrrz 1,1
	movem 2,(1)
	popj 17,

arguchar_uint:
	jumpe 1,%L920
	move 4,1
	tlo 4,331100
%L920:
	move 1,4
	jrst baruchar_uint

stackuchar_uint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,331100
	pushj 17,baruchar_uint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%66:
	.space	4

globaluchar_uint:
	move 1,[POINT 9,x%66,8]
	jrst baruchar_uint

retuchar_uint:
	jumpe 1,%L933
	move 4,1
	tlo 4,331100
%L933:
	move 1,4
	popj 17,

rounduchar_uint:
	popj 17,

voidretuchar_uint:
	push 17,10
	jumpe 1,%L937
	move 10,1
	tlo 10,331100
%L937:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%67:
	.space	4

saveuchar_uint:
	jumpe 1,%L940
	move 4,1
	tlo 4,331100
%L940:
	movem 4,p%67
	movem 4,vp_sink
	popj 17,

cmpuchar_uint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuchar_uint:
	jumpe 1,%L945
	move 4,1
	tlo 4,331100
%L945:
	sub 4,2
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

loaduchar_uint:
	jumpe 1,%L948
	move 4,1
	tlo 4,331100
%L948:
	ldb 1,4
	popj 17,

storeuchar_uint:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L950
	move 4,1
	tlo 4,331100
%L950:
	dpb 2,4
	popj 17,

arguint_uchar:
	hrrz 1,1
	jrst baruint_uchar

stackuint_uchar:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,baruint_uchar
	add 17,[-1,,-1]
	popj 17,

	.bss
x%68:
	.space	4

globaluint_uchar:
	movei 1,x%68
	jrst baruint_uchar

retuint_uchar:
	hrrz 1,1
	popj 17,

rounduint_uchar:
	hrrz 1,1
	jumpe 1,%L967
	move 4,1
	tlo 4,331100
%L967:
	move 1,4
	popj 17,

voidretuint_uchar:
	push 17,10
	move 10,1
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%69:
	.space	4

saveuint_uchar:
	hrrz 1,1
	movem 1,p%69
	jumpe 1,%L974
	move 4,1
	tlo 4,331100
%L974:
	movem 4,vp_sink
	popj 17,

cmpuint_uchar:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuint_uchar:
	hrrz 1,1
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-2
	popj 17,

loaduint_uchar:
	hrrz 1,1
	move 1,(1)
	popj 17,

storeuint_uchar:
	hrrz 1,1
	movem 2,(1)
	popj 17,

argschar_sint:
	jumpe 1,%L985
	move 4,1
	tlo 4,331100
%L985:
	move 1,4
	jrst barschar_sint

stackschar_sint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,331100
	pushj 17,barschar_sint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%70:
	.space	4

globalschar_sint:
	move 1,[POINT 9,x%70,8]
	jrst barschar_sint

retschar_sint:
	jumpe 1,%L998
	move 4,1
	tlo 4,331100
%L998:
	move 1,4
	popj 17,

roundschar_sint:
	popj 17,

voidretschar_sint:
	push 17,10
	jumpe 1,%L1002
	move 10,1
	tlo 10,331100
%L1002:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%71:
	.space	4

saveschar_sint:
	jumpe 1,%L1005
	move 4,1
	tlo 4,331100
%L1005:
	movem 4,p%71
	movem 4,vp_sink
	popj 17,

cmpschar_sint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffschar_sint:
	jumpe 1,%L1010
	move 4,1
	tlo 4,331100
%L1010:
	sub 4,2
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

loadschar_sint:
	jumpe 1,%L1013
	move 4,1
	tlo 4,331100
%L1013:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

storeschar_sint:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L1015
	move 4,1
	tlo 4,331100
%L1015:
	dpb 2,4
	popj 17,

argsint_schar:
	hrrz 1,1
	jrst barsint_schar

stacksint_schar:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barsint_schar
	add 17,[-1,,-1]
	popj 17,

	.bss
x%72:
	.space	4

globalsint_schar:
	movei 1,x%72
	jrst barsint_schar

retsint_schar:
	hrrz 1,1
	popj 17,

roundsint_schar:
	hrrz 1,1
	jumpe 1,%L1032
	move 4,1
	tlo 4,331100
%L1032:
	move 1,4
	popj 17,

voidretsint_schar:
	push 17,10
	move 10,1
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%73:
	.space	4

savesint_schar:
	hrrz 1,1
	movem 1,p%73
	jumpe 1,%L1039
	move 4,1
	tlo 4,331100
%L1039:
	movem 4,vp_sink
	popj 17,

cmpsint_schar:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffsint_schar:
	hrrz 1,1
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-2
	popj 17,

loadsint_schar:
	hrrz 1,1
	move 1,(1)
	popj 17,

storesint_schar:
	hrrz 1,1
	movem 2,(1)
	popj 17,

argqint_hint:
	jumpe 1,%L1050
	move 4,1
	tlc 4,113300
%L1050:
	move 1,4
	jrst barqint_hint

stackqint_hint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	tlc 1,113300
	pushj 17,barqint_hint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%74:
	.space	4

globalqint_hint:
	move 1,[POINT 9,x%74,26]
	jrst barqint_hint

retqint_hint:
	jumpe 1,%L1063
	move 4,1
	tlc 4,113300
%L1063:
	move 1,4
	popj 17,

roundqint_hint:
	jumpe 1,%L1066
	move 3,1
	tlc 3,113300
%L1066:
	jumpe 3,%L1065
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L1065:
	move 1,4
	popj 17,

voidretqint_hint:
	push 17,10
	jumpe 1,%L1068
	move 10,1
	tlc 10,113300
%L1068:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%75:
	.space	4

saveqint_hint:
	jumpe 1,%L1071
	move 4,1
	tlc 4,113300
%L1071:
	movem 4,p%75
	movem 4,vp_sink
	popj 17,

cmpqint_hint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffqint_hint:
	jumpe 1,%L1076
	move 3,1
	tlc 3,113300
%L1076:
	move 4,3
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

loadqint_hint:
	jumpe 1,%L1079
	move 4,1
	tlc 4,113300
%L1079:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

storeqint_hint:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L1081
	move 4,1
	tlc 4,113300
%L1081:
	dpb 2,4
	popj 17,

argqint_sint:
	jumpe 1,%L1083
	move 4,1
	tlo 4,331100
%L1083:
	move 1,4
	jrst barqint_sint

stackqint_sint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,331100
	pushj 17,barqint_sint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%76:
	.space	4

globalqint_sint:
	move 1,[POINT 9,x%76,8]
	jrst barqint_sint

retqint_sint:
	jumpe 1,%L1096
	move 4,1
	tlo 4,331100
%L1096:
	move 1,4
	popj 17,

roundqint_sint:
	popj 17,

voidretqint_sint:
	push 17,10
	jumpe 1,%L1100
	move 10,1
	tlo 10,331100
%L1100:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%77:
	.space	4

saveqint_sint:
	jumpe 1,%L1103
	move 4,1
	tlo 4,331100
%L1103:
	movem 4,p%77
	movem 4,vp_sink
	popj 17,

cmpqint_sint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffqint_sint:
	jumpe 1,%L1108
	move 4,1
	tlo 4,331100
%L1108:
	sub 4,2
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

loadqint_sint:
	jumpe 1,%L1111
	move 4,1
	tlo 4,331100
%L1111:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

storeqint_sint:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L1113
	move 4,1
	tlo 4,331100
%L1113:
	dpb 2,4
	popj 17,

arghint_qint:
	jumpe 1,%L1115
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1115:
	move 1,4
	jrst barhint_qint

stackhint_qint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	tlc 1,3300
	pushj 17,barhint_qint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%78:
	.space	4

globalhint_qint:
	move 1,[POINT 18,x%78,35]
	jrst barhint_qint

rethint_qint:
	jumpe 1,%L1128
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1128:
	move 1,4
	popj 17,

roundhint_qint:
	jumpe 1,%L1131
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1131:
	jumpe 4,%L1130
	move 3,4
	tlc 3,113300
%L1130:
	move 1,3
	popj 17,

voidrethint_qint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,clobber
	jumpe 11,%L1134
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L1134:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%79:
	.space	4

savehint_qint:
	jumpe 1,%L1136
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1136:
	movem 4,p%79
	jumpe 4,%L1137
	move 3,4
	tlc 3,113300
%L1137:
	movem 3,vp_sink
	popj 17,

cmphint_qint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffhint_qint:
	jumpe 1,%L1141
	move 3,1
	tlc 3,3300
	tlz 3,110000
%L1141:
	move 4,3
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-1
	popj 17,

loadhint_qint:
	jumpe 1,%L1144
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1144:
	ldb 1,4
	hrre 1,1
	popj 17,

storehint_qint:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L1146
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1146:
	dpb 2,4	; movhi
	popj 17,

arghint_sint:
	jumpe 1,%L1148
	move 4,1
	tlo 4,222200
%L1148:
	move 1,4
	jrst barhint_sint

stackhint_sint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,222200
	pushj 17,barhint_sint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%80:
	.space	4

globalhint_sint:
	move 1,[POINT 18,x%80,17]
	jrst barhint_sint

rethint_sint:
	jumpe 1,%L1161
	move 4,1
	tlo 4,222200
%L1161:
	move 1,4
	popj 17,

roundhint_sint:
	popj 17,

voidrethint_sint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L1165
	move 11,1
	tlo 11,331100
%L1165:
	pushj 17,clobber
	jumpe 11,%L1166
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L1166:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%81:
	.space	4

savehint_sint:
	jumpe 1,%L1168
	move 4,1
	tlo 4,222200
%L1168:
	movem 4,p%81
	jumpe 4,%L1169
	move 3,4
	tlc 3,113300
%L1169:
	movem 3,vp_sink
	popj 17,

cmphint_sint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffhint_sint:
	jumpe 1,%L1173
	move 4,1
	tlo 4,222200
%L1173:
	sub 4,2
	ash 4,1
	move 1,4
	popj 17,

loadhint_sint:
	jumpe 1,%L1176
	move 4,1
	tlo 4,222200
%L1176:
	ldb 1,4
	hrre 1,1
	popj 17,

storehint_sint:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L1178
	move 4,1
	tlo 4,222200
%L1178:
	dpb 2,4	; movhi
	popj 17,

argsint_qint:
	hrrz 1,1
	jrst barsint_qint

stacksint_qint:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barsint_qint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%82:
	.space	4

globalsint_qint:
	movei 1,x%82
	jrst barsint_qint

retsint_qint:
	hrrz 1,1
	popj 17,

roundsint_qint:
	hrrz 1,1
	jumpe 1,%L1195
	move 4,1
	tlo 4,331100
%L1195:
	move 1,4
	popj 17,

voidretsint_qint:
	push 17,10
	move 10,1
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%83:
	.space	4

savesint_qint:
	hrrz 1,1
	movem 1,p%83
	jumpe 1,%L1202
	move 4,1
	tlo 4,331100
%L1202:
	movem 4,vp_sink
	popj 17,

cmpsint_qint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffsint_qint:
	hrrz 1,1
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-2
	popj 17,

loadsint_qint:
	hrrz 1,1
	move 1,(1)
	popj 17,

storesint_qint:
	hrrz 1,1
	movem 2,(1)
	popj 17,

argsint_hint:
	hrrz 1,1
	jrst barsint_hint

stacksint_hint:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barsint_hint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%84:
	.space	4

globalsint_hint:
	movei 1,x%84
	jrst barsint_hint

retsint_hint:
	hrrz 1,1
	popj 17,

roundsint_hint:
	hrrz 1,1
	jumpe 1,%L1228
	move 4,1
	tlo 4,222200
%L1228:
	move 1,4
	popj 17,

voidretsint_hint:
	push 17,10
	jumpe 1,%L1231
	move 10,1
	tlc 10,113300
%L1231:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%85:
	.space	4

savesint_hint:
	hrrz 1,1
	movem 1,p%85
	jumpe 1,%L1235
	move 4,1
	tlo 4,331100
%L1235:
	movem 4,vp_sink
	popj 17,

cmpsint_hint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffsint_hint:
	hrrz 1,1
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,-1
	popj 17,

loadsint_hint:
	hrrz 1,1
	move 1,(1)
	popj 17,

storesint_hint:
	hrrz 1,1
	movem 2,(1)
	popj 17,

arguqint_uhint:
	jumpe 1,%L1246
	move 4,1
	tlc 4,113300
%L1246:
	move 1,4
	jrst baruqint_uhint

stackuqint_uhint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	tlc 1,113300
	pushj 17,baruqint_uhint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%86:
	.space	4

globaluqint_uhint:
	move 1,[POINT 9,x%86,26]
	jrst baruqint_uhint

retuqint_uhint:
	jumpe 1,%L1259
	move 4,1
	tlc 4,113300
%L1259:
	move 1,4
	popj 17,

rounduqint_uhint:
	jumpe 1,%L1262
	move 3,1
	tlc 3,113300
%L1262:
	jumpe 3,%L1261
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L1261:
	move 1,4
	popj 17,

voidretuqint_uhint:
	push 17,10
	jumpe 1,%L1264
	move 10,1
	tlc 10,113300
%L1264:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%87:
	.space	4

saveuqint_uhint:
	jumpe 1,%L1267
	move 4,1
	tlc 4,113300
%L1267:
	movem 4,p%87
	movem 4,vp_sink
	popj 17,

cmpuqint_uhint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuqint_uhint:
	jumpe 1,%L1272
	move 3,1
	tlc 3,113300
%L1272:
	move 4,3
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

loaduqint_uhint:
	jumpe 1,%L1275
	move 4,1
	tlc 4,113300
%L1275:
	ldb 1,4
	popj 17,

storeuqint_uhint:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L1277
	move 4,1
	tlc 4,113300
%L1277:
	dpb 2,4
	popj 17,

arguqint_usint:
	jumpe 1,%L1279
	move 4,1
	tlo 4,331100
%L1279:
	move 1,4
	jrst baruqint_usint

stackuqint_usint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,331100
	pushj 17,baruqint_usint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%88:
	.space	4

globaluqint_usint:
	move 1,[POINT 9,x%88,8]
	jrst baruqint_usint

retuqint_usint:
	jumpe 1,%L1292
	move 4,1
	tlo 4,331100
%L1292:
	move 1,4
	popj 17,

rounduqint_usint:
	popj 17,

voidretuqint_usint:
	push 17,10
	jumpe 1,%L1296
	move 10,1
	tlo 10,331100
%L1296:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%89:
	.space	4

saveuqint_usint:
	jumpe 1,%L1299
	move 4,1
	tlo 4,331100
%L1299:
	movem 4,p%89
	movem 4,vp_sink
	popj 17,

cmpuqint_usint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuqint_usint:
	jumpe 1,%L1304
	move 4,1
	tlo 4,331100
%L1304:
	sub 4,2
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

loaduqint_usint:
	jumpe 1,%L1307
	move 4,1
	tlo 4,331100
%L1307:
	ldb 1,4
	popj 17,

storeuqint_usint:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L1309
	move 4,1
	tlo 4,331100
%L1309:
	dpb 2,4
	popj 17,

arguhint_uqint:
	jumpe 1,%L1311
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1311:
	move 1,4
	jrst baruhint_uqint

stackuhint_uqint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	tlc 1,3300
	pushj 17,baruhint_uqint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%90:
	.space	4

globaluhint_uqint:
	move 1,[POINT 18,x%90,35]
	jrst baruhint_uqint

retuhint_uqint:
	jumpe 1,%L1324
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1324:
	move 1,4
	popj 17,

rounduhint_uqint:
	jumpe 1,%L1327
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1327:
	jumpe 4,%L1326
	move 3,4
	tlc 3,113300
%L1326:
	move 1,3
	popj 17,

voidretuhint_uqint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,clobber
	jumpe 11,%L1330
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L1330:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%91:
	.space	4

saveuhint_uqint:
	jumpe 1,%L1332
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1332:
	movem 4,p%91
	jumpe 4,%L1333
	move 3,4
	tlc 3,113300
%L1333:
	movem 3,vp_sink
	popj 17,

cmpuhint_uqint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuhint_uqint:
	jumpe 1,%L1337
	move 3,1
	tlc 3,3300
	tlz 3,110000
%L1337:
	move 4,3
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-1
	popj 17,

loaduhint_uqint:
	jumpe 1,%L1340
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1340:
	ldb 1,4
	popj 17,

storeuhint_uqint:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L1342
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1342:
	dpb 2,4	; movhi
	popj 17,

arguhint_usint:
	jumpe 1,%L1344
	move 4,1
	tlo 4,222200
%L1344:
	move 1,4
	jrst baruhint_usint

stackuhint_usint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,222200
	pushj 17,baruhint_usint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%92:
	.space	4

globaluhint_usint:
	move 1,[POINT 18,x%92,17]
	jrst baruhint_usint

retuhint_usint:
	jumpe 1,%L1357
	move 4,1
	tlo 4,222200
%L1357:
	move 1,4
	popj 17,

rounduhint_usint:
	popj 17,

voidretuhint_usint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L1361
	move 11,1
	tlo 11,331100
%L1361:
	pushj 17,clobber
	jumpe 11,%L1362
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L1362:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%93:
	.space	4

saveuhint_usint:
	jumpe 1,%L1364
	move 4,1
	tlo 4,222200
%L1364:
	movem 4,p%93
	jumpe 4,%L1365
	move 3,4
	tlc 3,113300
%L1365:
	movem 3,vp_sink
	popj 17,

cmpuhint_usint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuhint_usint:
	jumpe 1,%L1369
	move 4,1
	tlo 4,222200
%L1369:
	sub 4,2
	ash 4,1
	move 1,4
	popj 17,

loaduhint_usint:
	jumpe 1,%L1372
	move 4,1
	tlo 4,222200
%L1372:
	ldb 1,4
	popj 17,

storeuhint_usint:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L1374
	move 4,1
	tlo 4,222200
%L1374:
	dpb 2,4	; movhi
	popj 17,

argusint_uqint:
	hrrz 1,1
	jrst barusint_uqint

stackusint_uqint:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barusint_uqint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%94:
	.space	4

globalusint_uqint:
	movei 1,x%94
	jrst barusint_uqint

retusint_uqint:
	hrrz 1,1
	popj 17,

roundusint_uqint:
	hrrz 1,1
	jumpe 1,%L1391
	move 4,1
	tlo 4,331100
%L1391:
	move 1,4
	popj 17,

voidretusint_uqint:
	push 17,10
	move 10,1
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%95:
	.space	4

saveusint_uqint:
	hrrz 1,1
	movem 1,p%95
	jumpe 1,%L1398
	move 4,1
	tlo 4,331100
%L1398:
	movem 4,vp_sink
	popj 17,

cmpusint_uqint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffusint_uqint:
	hrrz 1,1
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-2
	popj 17,

loadusint_uqint:
	hrrz 1,1
	move 1,(1)
	popj 17,

storeusint_uqint:
	hrrz 1,1
	movem 2,(1)
	popj 17,

argusint_uhint:
	hrrz 1,1
	jrst barusint_uhint

stackusint_uhint:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barusint_uhint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%96:
	.space	4

globalusint_uhint:
	movei 1,x%96
	jrst barusint_uhint

retusint_uhint:
	hrrz 1,1
	popj 17,

roundusint_uhint:
	hrrz 1,1
	jumpe 1,%L1424
	move 4,1
	tlo 4,222200
%L1424:
	move 1,4
	popj 17,

voidretusint_uhint:
	push 17,10
	jumpe 1,%L1427
	move 10,1
	tlc 10,113300
%L1427:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%97:
	.space	4

saveusint_uhint:
	hrrz 1,1
	movem 1,p%97
	jumpe 1,%L1431
	move 4,1
	tlo 4,331100
%L1431:
	movem 4,vp_sink
	popj 17,

cmpusint_uhint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffusint_uhint:
	hrrz 1,1
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,-1
	popj 17,

loadusint_uhint:
	hrrz 1,1
	move 1,(1)
	popj 17,

storeusint_uhint:
	hrrz 1,1
	movem 2,(1)
	popj 17,

argc6_c7:
	jrst barc6_c7

stackc6_c7:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc6_c7
	add 17,[-1,,-1]
	popj 17,

	.bss
x%98:
	.space	4

globalc6_c7:
	move 1,[POINT 18,x%98,35]
	jrst barc6_c7

retc6_c7:
	popj 17,

roundc6_c7:
	popj 17,

voidretc6_c7:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%99:
	.space	4

savec6_c7:
	movem 1,p%99
	movem 1,vp_sink
	popj 17,

cmpc6_c7:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc6_c7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

loadc6_c7:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

storec6_c7:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

argc6_c8:
	jrst barc6_c8

stackc6_c8:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc6_c8
	add 17,[-1,,-1]
	popj 17,

	.bss
x%100:
	.space	4

globalc6_c8:
	move 1,[POINT 18,x%100,35]
	jrst barc6_c8

retc6_c8:
	popj 17,

roundc6_c8:
	popj 17,

voidretc6_c8:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%101:
	.space	4

savec6_c8:
	movem 1,p%101
	movem 1,vp_sink
	popj 17,

cmpc6_c8:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc6_c8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

loadc6_c8:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

storec6_c8:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

argc6_c9:
	jrst barc6_c9

stackc6_c9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc6_c9
	add 17,[-1,,-1]
	popj 17,

	.bss
x%102:
	.space	4

globalc6_c9:
	move 1,[POINT 18,x%102,35]
	jrst barc6_c9

retc6_c9:
	popj 17,

roundc6_c9:
	popj 17,

voidretc6_c9:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%103:
	.space	4

savec6_c9:
	movem 1,p%103
	movem 1,vp_sink
	popj 17,

cmpc6_c9:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc6_c9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loadc6_c9:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

storec6_c9:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

argc6_ch:
	jrst barc6_ch

stackc6_ch:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc6_ch
	add 17,[-1,,-1]
	popj 17,

	.bss
x%104:
	.space	4

globalc6_ch:
	move 1,[POINT 18,x%104,35]
	jrst barc6_ch

retc6_ch:
	popj 17,

roundc6_ch:
	popj 17,

voidretc6_ch:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%105:
	.space	4

savec6_ch:
	movem 1,p%105
	movem 1,vp_sink
	popj 17,

cmpc6_ch:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc6_ch:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loadc6_ch:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

storec6_ch:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

argc7_c6:
	jrst barc7_c6

stackc7_c6:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc7_c6
	add 17,[-1,,-1]
	popj 17,

	.bss
x%106:
	.space	4

globalc7_c6:
	move 1,[POINT 18,x%106,35]
	jrst barc7_c6

retc7_c6:
	popj 17,

roundc7_c6:
	popj 17,

voidretc7_c6:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%107:
	.space	4

savec7_c6:
	movem 1,p%107
	movem 1,vp_sink
	popj 17,

cmpc7_c6:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc7_c6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

loadc7_c6:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

storec7_c6:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

argc7_c8:
	jrst barc7_c8

stackc7_c8:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc7_c8
	add 17,[-1,,-1]
	popj 17,

	.bss
x%108:
	.space	4

globalc7_c8:
	move 1,[POINT 18,x%108,35]
	jrst barc7_c8

retc7_c8:
	popj 17,

roundc7_c8:
	popj 17,

voidretc7_c8:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%109:
	.space	4

savec7_c8:
	movem 1,p%109
	movem 1,vp_sink
	popj 17,

cmpc7_c8:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc7_c8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

loadc7_c8:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

storec7_c8:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

argc7_c9:
	jrst barc7_c9

stackc7_c9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc7_c9
	add 17,[-1,,-1]
	popj 17,

	.bss
x%110:
	.space	4

globalc7_c9:
	move 1,[POINT 18,x%110,35]
	jrst barc7_c9

retc7_c9:
	popj 17,

roundc7_c9:
	popj 17,

voidretc7_c9:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%111:
	.space	4

savec7_c9:
	movem 1,p%111
	movem 1,vp_sink
	popj 17,

cmpc7_c9:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc7_c9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loadc7_c9:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

storec7_c9:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

argc7_ch:
	jrst barc7_ch

stackc7_ch:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc7_ch
	add 17,[-1,,-1]
	popj 17,

	.bss
x%112:
	.space	4

globalc7_ch:
	move 1,[POINT 18,x%112,35]
	jrst barc7_ch

retc7_ch:
	popj 17,

roundc7_ch:
	popj 17,

voidretc7_ch:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%113:
	.space	4

savec7_ch:
	movem 1,p%113
	movem 1,vp_sink
	popj 17,

cmpc7_ch:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc7_ch:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loadc7_ch:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

storec7_ch:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

argc8_c6:
	jrst barc8_c6

stackc8_c6:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc8_c6
	add 17,[-1,,-1]
	popj 17,

	.bss
x%114:
	.space	4

globalc8_c6:
	move 1,[POINT 18,x%114,35]
	jrst barc8_c6

retc8_c6:
	popj 17,

roundc8_c6:
	popj 17,

voidretc8_c6:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%115:
	.space	4

savec8_c6:
	movem 1,p%115
	movem 1,vp_sink
	popj 17,

cmpc8_c6:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc8_c6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

loadc8_c6:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

storec8_c6:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	popj 17,

argc8_c7:
	jrst barc8_c7

stackc8_c7:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc8_c7
	add 17,[-1,,-1]
	popj 17,

	.bss
x%116:
	.space	4

globalc8_c7:
	move 1,[POINT 18,x%116,35]
	jrst barc8_c7

retc8_c7:
	popj 17,

roundc8_c7:
	popj 17,

voidretc8_c7:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%117:
	.space	4

savec8_c7:
	movem 1,p%117
	movem 1,vp_sink
	popj 17,

cmpc8_c7:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc8_c7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

loadc8_c7:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

storec8_c7:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	popj 17,

argc8_c9:
	jrst barc8_c9

stackc8_c9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc8_c9
	add 17,[-1,,-1]
	popj 17,

	.bss
x%118:
	.space	4

globalc8_c9:
	move 1,[POINT 18,x%118,35]
	jrst barc8_c9

retc8_c9:
	popj 17,

roundc8_c9:
	popj 17,

voidretc8_c9:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%119:
	.space	4

savec8_c9:
	movem 1,p%119
	movem 1,vp_sink
	popj 17,

cmpc8_c9:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc8_c9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loadc8_c9:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

storec8_c9:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	popj 17,

argc8_ch:
	jrst barc8_ch

stackc8_ch:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc8_ch
	add 17,[-1,,-1]
	popj 17,

	.bss
x%120:
	.space	4

globalc8_ch:
	move 1,[POINT 18,x%120,35]
	jrst barc8_ch

retc8_ch:
	popj 17,

roundc8_ch:
	popj 17,

voidretc8_ch:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%121:
	.space	4

savec8_ch:
	movem 1,p%121
	movem 1,vp_sink
	popj 17,

cmpc8_ch:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc8_ch:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loadc8_ch:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

storec8_ch:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	popj 17,

argc9_c6:
	jrst barc9_c6

stackc9_c6:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc9_c6
	add 17,[-1,,-1]
	popj 17,

	.bss
x%122:
	.space	4

globalc9_c6:
	move 1,[POINT 18,x%122,35]
	jrst barc9_c6

retc9_c6:
	popj 17,

roundc9_c6:
	popj 17,

voidretc9_c6:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%123:
	.space	4

savec9_c6:
	movem 1,p%123
	movem 1,vp_sink
	popj 17,

cmpc9_c6:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc9_c6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

loadc9_c6:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

storec9_c6:
	dpb 2,1
	popj 17,

argc9_c7:
	jrst barc9_c7

stackc9_c7:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc9_c7
	add 17,[-1,,-1]
	popj 17,

	.bss
x%124:
	.space	4

globalc9_c7:
	move 1,[POINT 18,x%124,35]
	jrst barc9_c7

retc9_c7:
	popj 17,

roundc9_c7:
	popj 17,

voidretc9_c7:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%125:
	.space	4

savec9_c7:
	movem 1,p%125
	movem 1,vp_sink
	popj 17,

cmpc9_c7:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc9_c7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

loadc9_c7:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

storec9_c7:
	dpb 2,1
	popj 17,

argc9_c8:
	jrst barc9_c8

stackc9_c8:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc9_c8
	add 17,[-1,,-1]
	popj 17,

	.bss
x%126:
	.space	4

globalc9_c8:
	move 1,[POINT 18,x%126,35]
	jrst barc9_c8

retc9_c8:
	popj 17,

roundc9_c8:
	popj 17,

voidretc9_c8:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%127:
	.space	4

savec9_c8:
	movem 1,p%127
	movem 1,vp_sink
	popj 17,

cmpc9_c8:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc9_c8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

loadc9_c8:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

storec9_c8:
	dpb 2,1
	popj 17,

argc9_ch:
	jrst barc9_ch

stackc9_ch:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barc9_ch
	add 17,[-1,,-1]
	popj 17,

	.bss
x%128:
	.space	4

globalc9_ch:
	move 1,[POINT 18,x%128,35]
	jrst barc9_ch

retc9_ch:
	popj 17,

roundc9_ch:
	popj 17,

voidretc9_ch:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%129:
	.space	4

savec9_ch:
	movem 1,p%129
	movem 1,vp_sink
	popj 17,

cmpc9_ch:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffc9_ch:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loadc9_ch:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

storec9_ch:
	dpb 2,1
	popj 17,

argch_c6:
	jrst barch_c6

stackch_c6:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barch_c6
	add 17,[-1,,-1]
	popj 17,

	.bss
x%130:
	.space	4

globalch_c6:
	move 1,[POINT 18,x%130,35]
	jrst barch_c6

retch_c6:
	popj 17,

roundch_c6:
	popj 17,

voidretch_c6:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%131:
	.space	4

savech_c6:
	movem 1,p%131
	movem 1,vp_sink
	popj 17,

cmpch_c6:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffch_c6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

loadch_c6:
	ldb 1,1
	popj 17,

storech_c6:
	dpb 2,1
	popj 17,

argch_c7:
	jrst barch_c7

stackch_c7:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barch_c7
	add 17,[-1,,-1]
	popj 17,

	.bss
x%132:
	.space	4

globalch_c7:
	move 1,[POINT 18,x%132,35]
	jrst barch_c7

retch_c7:
	popj 17,

roundch_c7:
	popj 17,

voidretch_c7:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%133:
	.space	4

savech_c7:
	movem 1,p%133
	movem 1,vp_sink
	popj 17,

cmpch_c7:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffch_c7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

loadch_c7:
	ldb 1,1
	popj 17,

storech_c7:
	dpb 2,1
	popj 17,

argch_c8:
	jrst barch_c8

stackch_c8:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barch_c8
	add 17,[-1,,-1]
	popj 17,

	.bss
x%134:
	.space	4

globalch_c8:
	move 1,[POINT 18,x%134,35]
	jrst barch_c8

retch_c8:
	popj 17,

roundch_c8:
	popj 17,

voidretch_c8:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%135:
	.space	4

savech_c8:
	movem 1,p%135
	movem 1,vp_sink
	popj 17,

cmpch_c8:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffch_c8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

loadch_c8:
	ldb 1,1
	popj 17,

storech_c8:
	dpb 2,1
	popj 17,

argch_c9:
	jrst barch_c9

stackch_c9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barch_c9
	add 17,[-1,,-1]
	popj 17,

	.bss
x%136:
	.space	4

globalch_c9:
	move 1,[POINT 18,x%136,35]
	jrst barch_c9

retch_c9:
	popj 17,

roundch_c9:
	popj 17,

voidretch_c9:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%137:
	.space	4

savech_c9:
	movem 1,p%137
	movem 1,vp_sink
	popj 17,

cmpch_c9:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffch_c9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loadch_c9:
	ldb 1,1
	popj 17,

storech_c9:
	dpb 2,1
	popj 17,

arguc6_uc7:
	jrst baruc6_uc7

stackuc6_uc7:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc6_uc7
	add 17,[-1,,-1]
	popj 17,

	.bss
x%138:
	.space	4

globaluc6_uc7:
	move 1,[POINT 18,x%138,35]
	jrst baruc6_uc7

retuc6_uc7:
	popj 17,

rounduc6_uc7:
	popj 17,

voidretuc6_uc7:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%139:
	.space	4

saveuc6_uc7:
	movem 1,p%139
	movem 1,vp_sink
	popj 17,

cmpuc6_uc7:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc6_uc7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

loaduc6_uc7:
	ldb 1,1
	popj 17,

storeuc6_uc7:
	andi 2,77
	dpb 2,1
	popj 17,

arguc6_uc8:
	jrst baruc6_uc8

stackuc6_uc8:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc6_uc8
	add 17,[-1,,-1]
	popj 17,

	.bss
x%140:
	.space	4

globaluc6_uc8:
	move 1,[POINT 18,x%140,35]
	jrst baruc6_uc8

retuc6_uc8:
	popj 17,

rounduc6_uc8:
	popj 17,

voidretuc6_uc8:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%141:
	.space	4

saveuc6_uc8:
	movem 1,p%141
	movem 1,vp_sink
	popj 17,

cmpuc6_uc8:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc6_uc8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

loaduc6_uc8:
	ldb 1,1
	popj 17,

storeuc6_uc8:
	andi 2,77
	dpb 2,1
	popj 17,

arguc6_uc9:
	jrst baruc6_uc9

stackuc6_uc9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc6_uc9
	add 17,[-1,,-1]
	popj 17,

	.bss
x%142:
	.space	4

globaluc6_uc9:
	move 1,[POINT 18,x%142,35]
	jrst baruc6_uc9

retuc6_uc9:
	popj 17,

rounduc6_uc9:
	popj 17,

voidretuc6_uc9:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%143:
	.space	4

saveuc6_uc9:
	movem 1,p%143
	movem 1,vp_sink
	popj 17,

cmpuc6_uc9:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc6_uc9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loaduc6_uc9:
	ldb 1,1
	popj 17,

storeuc6_uc9:
	andi 2,77
	dpb 2,1
	popj 17,

arguc6_uch:
	jrst baruc6_uch

stackuc6_uch:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc6_uch
	add 17,[-1,,-1]
	popj 17,

	.bss
x%144:
	.space	4

globaluc6_uch:
	move 1,[POINT 18,x%144,35]
	jrst baruc6_uch

retuc6_uch:
	popj 17,

rounduc6_uch:
	popj 17,

voidretuc6_uch:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%145:
	.space	4

saveuc6_uch:
	movem 1,p%145
	movem 1,vp_sink
	popj 17,

cmpuc6_uch:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc6_uch:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loaduc6_uch:
	ldb 1,1
	popj 17,

storeuc6_uch:
	andi 2,77
	dpb 2,1
	popj 17,

arguc7_uc6:
	jrst baruc7_uc6

stackuc7_uc6:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc7_uc6
	add 17,[-1,,-1]
	popj 17,

	.bss
x%146:
	.space	4

globaluc7_uc6:
	move 1,[POINT 18,x%146,35]
	jrst baruc7_uc6

retuc7_uc6:
	popj 17,

rounduc7_uc6:
	popj 17,

voidretuc7_uc6:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%147:
	.space	4

saveuc7_uc6:
	movem 1,p%147
	movem 1,vp_sink
	popj 17,

cmpuc7_uc6:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc7_uc6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

loaduc7_uc6:
	ldb 1,1
	popj 17,

storeuc7_uc6:
	andi 2,177
	dpb 2,1
	popj 17,

arguc7_uc8:
	jrst baruc7_uc8

stackuc7_uc8:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc7_uc8
	add 17,[-1,,-1]
	popj 17,

	.bss
x%148:
	.space	4

globaluc7_uc8:
	move 1,[POINT 18,x%148,35]
	jrst baruc7_uc8

retuc7_uc8:
	popj 17,

rounduc7_uc8:
	popj 17,

voidretuc7_uc8:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%149:
	.space	4

saveuc7_uc8:
	movem 1,p%149
	movem 1,vp_sink
	popj 17,

cmpuc7_uc8:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc7_uc8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

loaduc7_uc8:
	ldb 1,1
	popj 17,

storeuc7_uc8:
	andi 2,177
	dpb 2,1
	popj 17,

arguc7_uc9:
	jrst baruc7_uc9

stackuc7_uc9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc7_uc9
	add 17,[-1,,-1]
	popj 17,

	.bss
x%150:
	.space	4

globaluc7_uc9:
	move 1,[POINT 18,x%150,35]
	jrst baruc7_uc9

retuc7_uc9:
	popj 17,

rounduc7_uc9:
	popj 17,

voidretuc7_uc9:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%151:
	.space	4

saveuc7_uc9:
	movem 1,p%151
	movem 1,vp_sink
	popj 17,

cmpuc7_uc9:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc7_uc9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loaduc7_uc9:
	ldb 1,1
	popj 17,

storeuc7_uc9:
	andi 2,177
	dpb 2,1
	popj 17,

arguc7_uch:
	jrst baruc7_uch

stackuc7_uch:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc7_uch
	add 17,[-1,,-1]
	popj 17,

	.bss
x%152:
	.space	4

globaluc7_uch:
	move 1,[POINT 18,x%152,35]
	jrst baruc7_uch

retuc7_uch:
	popj 17,

rounduc7_uch:
	popj 17,

voidretuc7_uch:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%153:
	.space	4

saveuc7_uch:
	movem 1,p%153
	movem 1,vp_sink
	popj 17,

cmpuc7_uch:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc7_uch:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loaduc7_uch:
	ldb 1,1
	popj 17,

storeuc7_uch:
	andi 2,177
	dpb 2,1
	popj 17,

arguc8_uc6:
	jrst baruc8_uc6

stackuc8_uc6:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc8_uc6
	add 17,[-1,,-1]
	popj 17,

	.bss
x%154:
	.space	4

globaluc8_uc6:
	move 1,[POINT 18,x%154,35]
	jrst baruc8_uc6

retuc8_uc6:
	popj 17,

rounduc8_uc6:
	popj 17,

voidretuc8_uc6:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%155:
	.space	4

saveuc8_uc6:
	movem 1,p%155
	movem 1,vp_sink
	popj 17,

cmpuc8_uc6:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc8_uc6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

loaduc8_uc6:
	ldb 1,1
	popj 17,

storeuc8_uc6:
	andi 2,377
	dpb 2,1
	popj 17,

arguc8_uc7:
	jrst baruc8_uc7

stackuc8_uc7:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc8_uc7
	add 17,[-1,,-1]
	popj 17,

	.bss
x%156:
	.space	4

globaluc8_uc7:
	move 1,[POINT 18,x%156,35]
	jrst baruc8_uc7

retuc8_uc7:
	popj 17,

rounduc8_uc7:
	popj 17,

voidretuc8_uc7:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%157:
	.space	4

saveuc8_uc7:
	movem 1,p%157
	movem 1,vp_sink
	popj 17,

cmpuc8_uc7:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc8_uc7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

loaduc8_uc7:
	ldb 1,1
	popj 17,

storeuc8_uc7:
	andi 2,377
	dpb 2,1
	popj 17,

arguc8_uc9:
	jrst baruc8_uc9

stackuc8_uc9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc8_uc9
	add 17,[-1,,-1]
	popj 17,

	.bss
x%158:
	.space	4

globaluc8_uc9:
	move 1,[POINT 18,x%158,35]
	jrst baruc8_uc9

retuc8_uc9:
	popj 17,

rounduc8_uc9:
	popj 17,

voidretuc8_uc9:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%159:
	.space	4

saveuc8_uc9:
	movem 1,p%159
	movem 1,vp_sink
	popj 17,

cmpuc8_uc9:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc8_uc9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loaduc8_uc9:
	ldb 1,1
	popj 17,

storeuc8_uc9:
	andi 2,377
	dpb 2,1
	popj 17,

arguc8_uch:
	jrst baruc8_uch

stackuc8_uch:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc8_uch
	add 17,[-1,,-1]
	popj 17,

	.bss
x%160:
	.space	4

globaluc8_uch:
	move 1,[POINT 18,x%160,35]
	jrst baruc8_uch

retuc8_uch:
	popj 17,

rounduc8_uch:
	popj 17,

voidretuc8_uch:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%161:
	.space	4

saveuc8_uch:
	movem 1,p%161
	movem 1,vp_sink
	popj 17,

cmpuc8_uch:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc8_uch:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loaduc8_uch:
	ldb 1,1
	popj 17,

storeuc8_uch:
	andi 2,377
	dpb 2,1
	popj 17,

arguc9_uc6:
	jrst baruc9_uc6

stackuc9_uc6:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc9_uc6
	add 17,[-1,,-1]
	popj 17,

	.bss
x%162:
	.space	4

globaluc9_uc6:
	move 1,[POINT 18,x%162,35]
	jrst baruc9_uc6

retuc9_uc6:
	popj 17,

rounduc9_uc6:
	popj 17,

voidretuc9_uc6:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%163:
	.space	4

saveuc9_uc6:
	movem 1,p%163
	movem 1,vp_sink
	popj 17,

cmpuc9_uc6:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc9_uc6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

loaduc9_uc6:
	ldb 1,1
	popj 17,

storeuc9_uc6:
	dpb 2,1
	popj 17,

arguc9_uc7:
	jrst baruc9_uc7

stackuc9_uc7:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc9_uc7
	add 17,[-1,,-1]
	popj 17,

	.bss
x%164:
	.space	4

globaluc9_uc7:
	move 1,[POINT 18,x%164,35]
	jrst baruc9_uc7

retuc9_uc7:
	popj 17,

rounduc9_uc7:
	popj 17,

voidretuc9_uc7:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%165:
	.space	4

saveuc9_uc7:
	movem 1,p%165
	movem 1,vp_sink
	popj 17,

cmpuc9_uc7:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc9_uc7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

loaduc9_uc7:
	ldb 1,1
	popj 17,

storeuc9_uc7:
	dpb 2,1
	popj 17,

arguc9_uc8:
	jrst baruc9_uc8

stackuc9_uc8:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc9_uc8
	add 17,[-1,,-1]
	popj 17,

	.bss
x%166:
	.space	4

globaluc9_uc8:
	move 1,[POINT 18,x%166,35]
	jrst baruc9_uc8

retuc9_uc8:
	popj 17,

rounduc9_uc8:
	popj 17,

voidretuc9_uc8:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%167:
	.space	4

saveuc9_uc8:
	movem 1,p%167
	movem 1,vp_sink
	popj 17,

cmpuc9_uc8:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc9_uc8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

loaduc9_uc8:
	ldb 1,1
	popj 17,

storeuc9_uc8:
	dpb 2,1
	popj 17,

arguc9_uch:
	jrst baruc9_uch

stackuc9_uch:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruc9_uch
	add 17,[-1,,-1]
	popj 17,

	.bss
x%168:
	.space	4

globaluc9_uch:
	move 1,[POINT 18,x%168,35]
	jrst baruc9_uch

retuc9_uch:
	popj 17,

rounduc9_uch:
	popj 17,

voidretuc9_uch:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%169:
	.space	4

saveuc9_uch:
	movem 1,p%169
	movem 1,vp_sink
	popj 17,

cmpuc9_uch:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuc9_uch:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loaduc9_uch:
	ldb 1,1
	popj 17,

storeuc9_uch:
	dpb 2,1
	popj 17,

arguch_uc6:
	jrst baruch_uc6

stackuch_uc6:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruch_uc6
	add 17,[-1,,-1]
	popj 17,

	.bss
x%170:
	.space	4

globaluch_uc6:
	move 1,[POINT 18,x%170,35]
	jrst baruch_uc6

retuch_uc6:
	popj 17,

rounduch_uc6:
	popj 17,

voidretuch_uc6:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%171:
	.space	4

saveuch_uc6:
	movem 1,p%171
	movem 1,vp_sink
	popj 17,

cmpuch_uc6:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuch_uc6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

loaduch_uc6:
	ldb 1,1
	popj 17,

storeuch_uc6:
	dpb 2,1
	popj 17,

arguch_uc7:
	jrst baruch_uc7

stackuch_uc7:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruch_uc7
	add 17,[-1,,-1]
	popj 17,

	.bss
x%172:
	.space	4

globaluch_uc7:
	move 1,[POINT 18,x%172,35]
	jrst baruch_uc7

retuch_uc7:
	popj 17,

rounduch_uc7:
	popj 17,

voidretuch_uc7:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%173:
	.space	4

saveuch_uc7:
	movem 1,p%173
	movem 1,vp_sink
	popj 17,

cmpuch_uc7:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuch_uc7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

loaduch_uc7:
	ldb 1,1
	popj 17,

storeuch_uc7:
	dpb 2,1
	popj 17,

arguch_uc8:
	jrst baruch_uc8

stackuch_uc8:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruch_uc8
	add 17,[-1,,-1]
	popj 17,

	.bss
x%174:
	.space	4

globaluch_uc8:
	move 1,[POINT 18,x%174,35]
	jrst baruch_uc8

retuch_uc8:
	popj 17,

rounduch_uc8:
	popj 17,

voidretuch_uc8:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%175:
	.space	4

saveuch_uc8:
	movem 1,p%175
	movem 1,vp_sink
	popj 17,

cmpuch_uc8:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuch_uc8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

loaduch_uc8:
	ldb 1,1
	popj 17,

storeuch_uc8:
	dpb 2,1
	popj 17,

arguch_uc9:
	jrst baruch_uc9

stackuch_uc9:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,baruch_uc9
	add 17,[-1,,-1]
	popj 17,

	.bss
x%176:
	.space	4

globaluch_uc9:
	move 1,[POINT 18,x%176,35]
	jrst baruch_uc9

retuch_uc9:
	popj 17,

rounduch_uc9:
	popj 17,

voidretuch_uc9:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

	.bss
p%177:
	.space	4

saveuch_uc9:
	movem 1,p%177
	movem 1,vp_sink
	popj 17,

cmpuch_uc9:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffuch_uc9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

loaduch_uc9:
	ldb 1,1
	popj 17,

storeuch_uc9:
	dpb 2,1
	popj 17,

args16_s18:
	jrst bars16_s18

stacks16_s18:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bars16_s18
	add 17,[-1,,-1]
	popj 17,

	.bss
x%178:
	.space	4

globals16_s18:
	move 1,[POINT 18,x%178,35]
	jrst bars16_s18

rets16_s18:
	popj 17,

rounds16_s18:
	popj 17,

voidrets16_s18:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L2780
	move 11,1
	tlc 11,113300
%L2780:
	pushj 17,clobber
	jumpe 11,%L2781
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L2781:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%179:
	.space	4

saves16_s18:
	movem 1,p%179
	jumpe 1,%L2784
	move 4,1
	tlc 4,113300
%L2784:
	movem 4,vp_sink
	popj 17,

cmps16_s18:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffs16_s18:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

loads16_s18:
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

stores16_s18:
	lsh 2,24
	ash 2,-24
	dpb 2,1	; movhi
	popj 17,

args18_s16:
	jrst bars18_s16

stacks18_s16:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bars18_s16
	add 17,[-1,,-1]
	popj 17,

	.bss
x%180:
	.space	4

globals18_s16:
	move 1,[POINT 18,x%180,35]
	jrst bars18_s16

rets18_s16:
	popj 17,

rounds18_s16:
	popj 17,

voidrets18_s16:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L2813
	move 11,1
	tlc 11,113300
%L2813:
	pushj 17,clobber
	jumpe 11,%L2814
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L2814:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%181:
	.space	4

saves18_s16:
	movem 1,p%181
	jumpe 1,%L2817
	move 4,1
	tlc 4,113300
%L2817:
	movem 4,vp_sink
	popj 17,

cmps18_s16:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffs18_s16:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

loads18_s16:
	ldb 1,1
	hrre 1,1
	popj 17,

stores18_s16:
	dpb 2,1	; movhi
	popj 17,

args16_hint:
	jrst bars16_hint

stacks16_hint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bars16_hint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%182:
	.space	4

globals16_hint:
	move 1,[POINT 18,x%182,35]
	jrst bars16_hint

rets16_hint:
	popj 17,

rounds16_hint:
	popj 17,

voidrets16_hint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L2846
	move 11,1
	tlc 11,113300
%L2846:
	pushj 17,clobber
	jumpe 11,%L2847
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L2847:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%183:
	.space	4

saves16_hint:
	movem 1,p%183
	jumpe 1,%L2850
	move 4,1
	tlc 4,113300
%L2850:
	movem 4,vp_sink
	popj 17,

cmps16_hint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffs16_hint:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

loads16_hint:
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

stores16_hint:
	lsh 2,24
	ash 2,-24
	dpb 2,1	; movhi
	popj 17,

arghint_s16:
	jrst barhint_s16

stackhint_s16:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barhint_s16
	add 17,[-1,,-1]
	popj 17,

	.bss
x%184:
	.space	4

globalhint_s16:
	move 1,[POINT 18,x%184,35]
	jrst barhint_s16

rethint_s16:
	popj 17,

roundhint_s16:
	popj 17,

voidrethint_s16:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L2879
	move 11,1
	tlc 11,113300
%L2879:
	pushj 17,clobber
	jumpe 11,%L2880
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L2880:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%185:
	.space	4

savehint_s16:
	movem 1,p%185
	jumpe 1,%L2883
	move 4,1
	tlc 4,113300
%L2883:
	movem 4,vp_sink
	popj 17,

cmphint_s16:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffhint_s16:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

loadhint_s16:
	ldb 1,1
	hrre 1,1
	popj 17,

storehint_s16:
	dpb 2,1	; movhi
	popj 17,

args18_hint:
	jrst bars18_hint

stacks18_hint:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,bars18_hint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%186:
	.space	4

globals18_hint:
	move 1,[POINT 18,x%186,35]
	jrst bars18_hint

rets18_hint:
	popj 17,

rounds18_hint:
	popj 17,

voidrets18_hint:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L2912
	move 11,1
	tlc 11,113300
%L2912:
	pushj 17,clobber
	jumpe 11,%L2913
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L2913:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%187:
	.space	4

saves18_hint:
	movem 1,p%187
	jumpe 1,%L2916
	move 4,1
	tlc 4,113300
%L2916:
	movem 4,vp_sink
	popj 17,

cmps18_hint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffs18_hint:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

loads18_hint:
	ldb 1,1
	hrre 1,1
	popj 17,

stores18_hint:
	dpb 2,1	; movhi
	popj 17,

arghint_s18:
	jrst barhint_s18

stackhint_s18:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barhint_s18
	add 17,[-1,,-1]
	popj 17,

	.bss
x%188:
	.space	4

globalhint_s18:
	move 1,[POINT 18,x%188,35]
	jrst barhint_s18

rethint_s18:
	popj 17,

roundhint_s18:
	popj 17,

voidrethint_s18:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L2945
	move 11,1
	tlc 11,113300
%L2945:
	pushj 17,clobber
	jumpe 11,%L2946
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L2946:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%189:
	.space	4

savehint_s18:
	movem 1,p%189
	jumpe 1,%L2949
	move 4,1
	tlc 4,113300
%L2949:
	movem 4,vp_sink
	popj 17,

cmphint_s18:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffhint_s18:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

loadhint_s18:
	ldb 1,1
	hrre 1,1
	popj 17,

storehint_s18:
	dpb 2,1	; movhi
	popj 17,

argus16_us18:
	jrst barus16_us18

stackus16_us18:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barus16_us18
	add 17,[-1,,-1]
	popj 17,

	.bss
x%190:
	.space	4

globalus16_us18:
	move 1,[POINT 18,x%190,35]
	jrst barus16_us18

retus16_us18:
	popj 17,

roundus16_us18:
	popj 17,

voidretus16_us18:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L2978
	move 11,1
	tlc 11,113300
%L2978:
	pushj 17,clobber
	jumpe 11,%L2979
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L2979:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%191:
	.space	4

saveus16_us18:
	movem 1,p%191
	jumpe 1,%L2982
	move 4,1
	tlc 4,113300
%L2982:
	movem 4,vp_sink
	popj 17,

cmpus16_us18:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffus16_us18:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

loadus16_us18:
	ldb 1,1
	andi 1,177777
	popj 17,

storeus16_us18:
	andi 2,177777
	dpb 2,1	; movhi
	popj 17,

argus18_us16:
	jrst barus18_us16

stackus18_us16:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	pushj 17,barus18_us16
	add 17,[-1,,-1]
	popj 17,

	.bss
x%192:
	.space	4

globalus18_us16:
	move 1,[POINT 18,x%192,35]
	jrst barus18_us16

retus18_us16:
	popj 17,

roundus18_us16:
	popj 17,

voidretus18_us16:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	jumpe 1,%L3011
	move 11,1
	tlc 11,113300
%L3011:
	pushj 17,clobber
	jumpe 11,%L3012
	move 10,11
	tlc 10,3300
	tlz 10,110000
%L3012:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
p%193:
	.space	4

saveus18_us16:
	movem 1,p%193
	jumpe 1,%L3015
	move 4,1
	tlc 4,113300
%L3015:
	movem 4,vp_sink
	popj 17,

cmpus18_us16:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffus18_us16:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

loadus18_us16:
	ldb 1,1
	popj 17,

storeus18_us16:
	dpb 2,1	; movhi
	popj 17,

argi32_sint:
	jrst bari32_sint

stacki32_sint:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,bari32_sint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%194:
	.space	4

globali32_sint:
	movei 1,x%194
	jrst bari32_sint

reti32_sint:
	popj 17,

roundi32_sint:
	popj 17,

voidreti32_sint:
	push 17,10
	jumpe 1,%L3044
	move 10,1
	tlo 10,331100
%L3044:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%195:
	.space	4

savei32_sint:
	movem 1,p%195
	jumpe 1,%L3048
	move 4,1
	tlo 4,331100
%L3048:
	movem 4,vp_sink
	popj 17,

cmpi32_sint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffi32_sint:
	sub 1,2
	popj 17,

loadi32_sint:
	move 1,(1)
	popj 17,

storei32_sint:
	movem 2,(1)
	popj 17,

argsint_i32:
	jrst barsint_i32

stacksint_i32:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barsint_i32
	add 17,[-1,,-1]
	popj 17,

	.bss
x%196:
	.space	4

globalsint_i32:
	movei 1,x%196
	jrst barsint_i32

retsint_i32:
	popj 17,

roundsint_i32:
	popj 17,

voidretsint_i32:
	push 17,10
	jumpe 1,%L3077
	move 10,1
	tlo 10,331100
%L3077:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%197:
	.space	4

savesint_i32:
	movem 1,p%197
	jumpe 1,%L3081
	move 4,1
	tlo 4,331100
%L3081:
	movem 4,vp_sink
	popj 17,

cmpsint_i32:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffsint_i32:
	sub 1,2
	popj 17,

loadsint_i32:
	move 1,(1)
	popj 17,

storesint_i32:
	movem 2,(1)
	popj 17,

argui32_usint:
	jrst barui32_usint

stackui32_usint:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barui32_usint
	add 17,[-1,,-1]
	popj 17,

	.bss
x%198:
	.space	4

globalui32_usint:
	movei 1,x%198
	jrst barui32_usint

retui32_usint:
	popj 17,

roundui32_usint:
	popj 17,

voidretui32_usint:
	push 17,10
	jumpe 1,%L3110
	move 10,1
	tlo 10,331100
%L3110:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%199:
	.space	4

saveui32_usint:
	movem 1,p%199
	jumpe 1,%L3114
	move 4,1
	tlo 4,331100
%L3114:
	movem 4,vp_sink
	popj 17,

cmpui32_usint:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffui32_usint:
	sub 1,2
	popj 17,

loadui32_usint:
	move 1,(1)
	popj 17,

storeui32_usint:
	movem 2,(1)
	popj 17,

argusint_ui32:
	jrst barusint_ui32

stackusint_ui32:
	add 17,[1,,1]
	movei 1,(17)
	pushj 17,barusint_ui32
	add 17,[-1,,-1]
	popj 17,

	.bss
x%200:
	.space	4

globalusint_ui32:
	movei 1,x%200
	jrst barusint_ui32

retusint_ui32:
	popj 17,

roundusint_ui32:
	popj 17,

voidretusint_ui32:
	push 17,10
	jumpe 1,%L3143
	move 10,1
	tlo 10,331100
%L3143:
	pushj 17,clobber
	hrrz 1,10
	pop 17,10
	popj 17,

	.bss
p%201:
	.space	4

saveusint_ui32:
	movem 1,p%201
	jumpe 1,%L3147
	move 4,1
	tlo 4,331100
%L3147:
	movem 4,vp_sink
	popj 17,

cmpusint_ui32:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

diffusint_ui32:
	sub 1,2
	popj 17,

loadusint_ui32:
	move 1,(1)
	popj 17,

storeusint_ui32:
	movem 2,(1)
	popj 17,

use_globals:
	move 1,[POINT 18,g_char,35]
	pushj 17,arg1__
	move 1,[POINT 18,g_char,35]
	pushj 17,arg1s_
	move 1,[POINT 18,g_char,35]
	pushj 17,arg1u_
	move 1,[POINT 18,g_schar,35]
	pushj 17,arg1_s
	move 1,[POINT 18,g_uchar,35]
	pushj 17,arg1_u
	move 1,[POINT 18,g_short,35]
	pushj 17,arg2__
	move 1,[POINT 18,g_ushort,35]
	pushj 17,arg2_u
	movei 1,g_int
	pushj 17,arg3__
	movei 1,g_uint
	pushj 17,arg3_u
	move 1,[POINT 18,g_hint,35]
	pushj 17,argqint_hint
	move 1,[POINT 18,g_uhint,35]
	pushj 17,arguqint_uhint
	move 1,[POINT 18,g_char7,35]
	pushj 17,argc6_c7
	move 1,[POINT 18,g_char9,35]
	pushj 17,argc8_c9
	move 1,[POINT 18,g_uchar7,35]
	pushj 17,arguc6_uc7
	move 1,[POINT 18,g_uchar9,35]
	pushj 17,arguc8_uc9
	move 1,[POINT 18,g_short18,35]
	pushj 17,args16_s18
	move 1,[POINT 18,g_ushort18,35]
	pushj 17,argus16_us18
	movei 1,g_sint
	pushj 17,argi32_sint
	movei 1,g_usint
	jrst argui32_usint

use_returns:
	add 17,[12,,12]
	movem 16,-11(17)
	movei 0,-10(17)
	hrli 0,10
	blt 0,-3(17)
	movem 1,-2(17)
	move 1,[POINT 18,g_char9,35]
	pushj 17,retch_c9
	move 10,1
	move 1,[POINT 18,g_char,35]
	pushj 17,retshort_char
	move 11,1
	move 1,[POINT 18,g_short,35]
	pushj 17,retint_short
	move 12,1
	move 1,[POINT 18,g_char9,35]
	pushj 17,retc6_c9
	move 13,1
	move 1,[POINT 18,g_char6,35]
	pushj 17,retc7_c6
	move 14,1
	move 1,[POINT 18,g_char9,35]
	pushj 17,retc8_c9
	move 15,1
	move 1,[POINT 18,g_char8,35]
	pushj 17,retc9_c8
	move 16,1
	move 1,[POINT 18,g_short16,35]
	pushj 17,rets18_s16
	movem 1,-1(17)
	movei 1,g_sint
	pushj 17,reti32_sint
	movem 1,(17)
	move 1,[POINT 18,g_char9,35]
	move 2,10
	pushj 17,cmpch_c9
	move 10,1
	move 1,[POINT 18,g_char,35]
	move 2,11
	pushj 17,cmpshort_char
	add 10,1
	move 1,[POINT 18,g_short,35]
	move 2,12
	pushj 17,cmpint_short
	add 10,1
	move 1,[POINT 18,g_char9,35]
	move 2,13
	pushj 17,cmpc6_c9
	add 10,1
	move 1,[POINT 18,g_char6,35]
	move 2,14
	pushj 17,cmpc7_c6
	add 10,1
	move 1,[POINT 18,g_char9,35]
	move 2,15
	pushj 17,cmpc8_c9
	add 10,1
	move 1,[POINT 18,g_char8,35]
	move 2,16
	pushj 17,cmpc9_c8
	add 10,1
	move 1,[POINT 18,g_short16,35]
	move 2,-1(17)
	pushj 17,cmps18_s16
	add 10,1
	movei 1,g_sint
	move 2,(17)
	pushj 17,cmpi32_sint
	add 1,10
	movem 1,cmp_sink
	add 1,-2(17)
	move 16,-11(17)
	movei 0,10
	hrli 0,-10(17)
	blt 0,15
	add 17,[-12,,-12]
	popj 17,

use_load_store:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 2,1
	andi 2,777	; zero_extendqisi2
	move 1,[POINT 18,g_char,35]
	pushj 17,store1__
	hrre 10,11	; extendhisi2
	move 1,[POINT 18,g_short,35]
	move 2,10
	pushj 17,store2__
	movei 1,g_int
	move 2,11
	pushj 17,store3__
	move 12,11
	lsh 12,33
	ash 12,-33
	move 1,[POINT 18,g_hint,35]
	move 2,12
	pushj 17,storeqint_hint
	movei 1,g_sint
	move 2,10
	pushj 17,storehint_sint
	move 1,[POINT 18,g_hint,35]
	move 2,11
	pushj 17,storesint_hint
	move 10,11
	move 2,11
	lsh 2,36
	ash 2,-36
	move 1,[POINT 18,g_char9,35]
	pushj 17,storec6_c9
	move 2,11
	lsh 2,35
	ash 2,-35
	move 1,[POINT 18,g_char6,35]
	pushj 17,storec7_c6
	move 2,11
	lsh 2,34
	ash 2,-34
	move 1,[POINT 18,g_char9,35]
	pushj 17,storec8_c9
	move 1,[POINT 18,g_char8,35]
	move 2,12
	pushj 17,storec9_c8
	move 2,11
	andi 2,77
	move 1,[POINT 18,g_uchar9,35]
	pushj 17,storeuc6_uc9
	andi 10,377
	move 1,[POINT 18,g_uchar7,35]
	move 2,10
	pushj 17,storeuc8_uc7
	move 10,11
	move 2,11
	lsh 2,24
	ash 2,-24
	move 1,[POINT 18,g_short18,35]
	pushj 17,stores16_s18
	andi 10,177777
	move 1,[POINT 18,g_ushort18,35]
	move 2,10
	pushj 17,storeus16_us18
	movei 1,g_sint
	move 2,11
	pushj 17,storei32_sint
	move 1,[POINT 18,g_char,35]
	pushj 17,load1__
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,[POINT 18,g_short,35]
	pushj 17,load2__
	hrre 1,1	; extendhisi2
	add 10,1
	movei 1,g_int
	pushj 17,load3__
	add 10,1
	move 1,[POINT 18,g_hint,35]
	pushj 17,loadqint_hint
	lsh 1,33
	ash 1,-33
	add 10,1
	movei 1,g_sint
	pushj 17,loadhint_sint
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,[POINT 18,g_hint,35]
	pushj 17,loadsint_hint
	add 10,1
	move 1,[POINT 18,g_char9,35]
	pushj 17,loadc6_c9
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,[POINT 18,g_char6,35]
	pushj 17,loadc7_c6
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,[POINT 18,g_char9,35]
	pushj 17,loadc8_c9
	lsh 1,34
	ash 1,-34
	add 10,1
	move 1,[POINT 18,g_char8,35]
	pushj 17,loadc9_c8
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,[POINT 18,g_uchar9,35]
	pushj 17,loaduc6_uc9
	andi 1,77
	add 10,1
	move 1,[POINT 18,g_uchar7,35]
	pushj 17,loaduc8_uc7
	andi 1,377
	add 10,1
	move 1,[POINT 18,g_short18,35]
	pushj 17,loads16_s18
	lsh 1,24
	ash 1,-24
	add 10,1
	move 1,[POINT 18,g_ushort18,35]
	pushj 17,loadus16_us18
	andi 1,177777
	add 10,1
	movei 1,g_sint
	pushj 17,loadi32_sint
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

use_diffs:
	push 17,10
	move 1,[POINT 18,g_char,35]
	move 2,1
	pushj 17,diff1__
	move 10,1
	move 1,[POINT 18,g_short,35]
	move 2,1
	pushj 17,diff2__
	add 10,1
	movei 1,g_int
	move 2,1
	pushj 17,diff3__
	add 10,1
	move 1,[POINT 18,g_char9,35]
	move 2,1
	pushj 17,diffc6_c9
	add 10,1
	move 1,[POINT 18,g_char6,35]
	move 2,1
	pushj 17,diffc7_c6
	add 10,1
	move 1,[POINT 18,g_char9,35]
	move 2,1
	pushj 17,diffc8_c9
	add 10,1
	move 1,[POINT 18,g_char8,35]
	move 2,1
	pushj 17,diffc9_c8
	add 10,1
	move 1,[POINT 18,g_short18,35]
	move 2,1
	pushj 17,diffs16_s18
	add 10,1
	movei 1,g_sint
	move 2,1
	pushj 17,diffi32_sint
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

use_convert_pointer:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,use_globals
	move 1,[POINT 18,g_char,35]
	pushj 17,save1__
	move 1,[POINT 18,g_short,35]
	pushj 17,save2__
	movei 1,g_int
	pushj 17,save3__
	move 1,[POINT 18,g_char9,35]
	pushj 17,savec6_c9
	move 1,[POINT 18,g_char6,35]
	pushj 17,savec7_c6
	move 1,[POINT 18,g_char9,35]
	pushj 17,savec8_c9
	move 1,[POINT 18,g_char8,35]
	pushj 17,savec9_c8
	move 1,[POINT 18,g_short18,35]
	pushj 17,saves16_s18
	movei 1,g_sint
	pushj 17,savei32_sint
	move 1,11
	pushj 17,use_returns
	move 10,1
	move 1,11
	pushj 17,use_load_store
	add 10,1
	pushj 17,use_diffs
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
g_char:
	.space	4
g_schar:
	.space	4
g_uchar:
	.space	4
g_short:
	.space	4
g_ushort:
	.space	4
g_int:
	.space	4
g_uint:
	.space	4
g_qint:
	.space	4
g_uqint:
	.space	4
g_hint:
	.space	4
g_uhint:
	.space	4
g_sint:
	.space	4
g_usint:
	.space	4
g_char6:
	.space	4
g_uchar6:
	.space	4
g_char7:
	.space	4
g_uchar7:
	.space	4
g_char8:
	.space	4
g_uchar8:
	.space	4
g_char9:
	.space	4
g_uchar9:
	.space	4
g_short16:
	.space	4
g_ushort16:
	.space	4
g_short18:
	.space	4
g_ushort18:
	.space	4
g_int32:
	.space	4
g_uint32:
	.space	4
vp_sink:
	.space	4
cmp_sink:
	.space	4
