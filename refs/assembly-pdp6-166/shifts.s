	.data
	.align	2
gs:
	.word	777777747707
	.align	2
gus:
	.word	777777777777
	.align	2
gd:
	.word	777777777777
	.word	777773224571
	.align	2
gud:
	.word	777777777777
	.word	777777777777
	.align	2
vgs:
	.word	777777777663
	.align	2
vgus:
	.word	777777
	.align	2
vgd:
	.word	777777777777
	.word	777775020717
	.align	2
vgud:
	.word	777777777777
	.word	777777777777
	.align	2
gs_slot:
	.word	777777777635
	.word	777777
	.word	3
	.align	2
gd_slot:
	.word	777777777777
	.word	777777474541
	.word	777777777777
	.word	777777777777
	.word	5

ashl1:
	lsh 1,1
	popj 17,

lshl1:
	lsh 1,1
	popj 17,

ashl2:
	lsh 1,2
	popj 17,

lshl2:
	lsh 1,2
	popj 17,

ashl3:
	lsh 1,3
	popj 17,

lshl3:
	lsh 1,3
	popj 17,

ashl4:
	lsh 1,4
	popj 17,

lshl4:
	lsh 1,4
	popj 17,

ashl8:
	lsh 1,10
	popj 17,

lshl8:
	lsh 1,10
	popj 17,

ashl18:
	hrlz 1,1
	popj 17,

lshl18:
	hrlz 1,1
	popj 17,

smul2:
	lsh 1,1
	popj 17,

umul2:
	lsh 1,1
	popj 17,

smul4:
	lsh 1,2
	popj 17,

umul4:
	lsh 1,2
	popj 17,

smul8:
	lsh 1,3
	popj 17,

umul8:
	lsh 1,3
	popj 17,

ashr1:
	ash 1,-1
	popj 17,

lshr1:
	lsh 1,-1
	popj 17,

ashr2:
	ash 1,-2
	popj 17,

lshr2:
	lsh 1,-2
	popj 17,

ashr3:
	ash 1,-3
	popj 17,

lshr3:
	lsh 1,-3
	popj 17,

ashr4:
	ash 1,-4
	popj 17,

lshr4:
	lsh 1,-4
	popj 17,

ashr8:
	ash 1,-10
	popj 17,

lshr8:
	lsh 1,-10
	popj 17,

ashr18:
	hlre 1,1
	popj 17,

lshr18:
	hlrz 1,1
	popj 17,

ashr35:
	ash 1,-43
	popj 17,

lshr35:
	lsh 1,-43
	popj 17,

sdiv2:
	move 4,1
	lsh 4,-43
	add 1,4
	ash 1,-1
	popj 17,

udiv2:
	lsh 1,-1
	popj 17,

sdiv4:
	jumpl 1,%L37
%L36:
	ash 1,-2
	popj 17,
%L37:
	addi 1,3
	jrst %L36

udiv4:
	lsh 1,-2
	popj 17,

sdiv8:
	jumpl 1,%L41
%L40:
	ash 1,-3
	popj 17,
%L41:
	addi 1,7
	jrst %L40

udiv8:
	lsh 1,-3
	popj 17,

sdiv16:
	jumpl 1,%L45
%L44:
	ash 1,-4
	popj 17,
%L45:
	addi 1,17
	jrst %L44

udiv16:
	lsh 1,-4
	popj 17,

smod2:
	move 4,1
	lsh 4,-43
	add 4,1
	andcmi 4,1
	sub 1,4
	popj 17,

umod2:
	andi 1,1
	popj 17,

smod4:
	move 4,1
	jumpl 1,%L51
%L50:
	andcmi 4,3
	sub 1,4
	popj 17,
%L51:
	addi 4,3
	jrst %L50

umod4:
	andi 1,3
	popj 17,

smod8:
	move 4,1
	jumpl 1,%L55
%L54:
	andcmi 4,7
	sub 1,4
	popj 17,
%L55:
	addi 4,7
	jrst %L54

umod8:
	andi 1,7
	popj 17,

smod16:
	move 4,1
	jumpl 1,%L59
%L58:
	andcmi 4,17
	sub 1,4
	popj 17,
%L59:
	addi 4,17
	jrst %L58

umod16:
	andi 1,17
	popj 17,

dashl1:
	lshc 1,1
	popj 17,

dlshl1:
	lshc 1,1
	popj 17,

dashl2:
	lshc 1,2
	popj 17,

dlshl2:
	lshc 1,2
	popj 17,

dashl3:
	lshc 1,3
	popj 17,

dlshl3:
	lshc 1,3
	popj 17,

dashl4:
	lshc 1,4
	popj 17,

dlshl4:
	lshc 1,4
	popj 17,

dashl8:
	lshc 1,10
	popj 17,

dlshl8:
	lshc 1,10
	popj 17,

dashl18:
	lshc 1,22
	popj 17,

dlshl18:
	lshc 1,22
	popj 17,

dashl35:
	lshc 1,43
	popj 17,

dlshl35:
	lshc 1,43
	popj 17,

dashl36:
	lshc 1,44
	popj 17,

dlshl36:
	lshc 1,44
	popj 17,

dsmul2:
	lshc 1,1
	popj 17,

dumul2:
	lshc 1,1
	popj 17,

dsmul4:
	lshc 1,2
	popj 17,

dumul4:
	lshc 1,2
	popj 17,

dsmul8:
	lshc 1,3
	popj 17,

dumul8:
	lshc 1,3
	popj 17,

dashr1:
	lshc 1,-1
	tlne 1,200000
	tlo 1,400000
	popj 17,

dlshr1:
	lshc 1,-1
	popj 17,

dashr2:
	lshc 1,-2
	tlne 1,100000
	tlo 1,600000
	popj 17,

dlshr2:
	lshc 1,-2
	popj 17,

dashr3:
	lshc 1,-3
	tlne 1,40000
	tlo 1,700000
	popj 17,

dlshr3:
	lshc 1,-3
	popj 17,

dashr4:
	lshc 1,-4
	tlne 1,20000
	tlo 1,740000
	popj 17,

dlshr4:
	lshc 1,-4
	popj 17,

dashr8:
	lshc 1,-10
	tlne 1,1000
	tlo 1,776000
	popj 17,

dlshr8:
	lshc 1,-10
	popj 17,

dashr18:
	lshc 1,-22
	trne 1,400000
	hrro 1,1
	popj 17,

dlshr18:
	lshc 1,-22
	popj 17,

dashr35:
	lshc 1,-43
	trne 1,1
	seto 1,
	popj 17,

dlshr35:
	lshc 1,-43
	popj 17,

dashr36:
	move 2,1
	ash 1,-43
	popj 17,

dlshr36:
	lshc 1,-44
	popj 17,

dashr37:
	ashc 1,-44
	popj 17,

dlshr37:
	lshc 1,-45
	popj 17,

dashr63:
	ashc 1,-76
	popj 17,

dlshr63:
	lshc 1,-77
	popj 17,

dashr70:
	ashc 1,-105
	popj 17,

dlshr70:
	lshc 1,-106
	popj 17,

dsdiv2:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,1
	jcry0 [aoja 1,.+1]
	lshc 1,-1
	tlne 1,200000
	tlo 1,400000
	popj 17,

dudiv2:
	lshc 1,-1
	popj 17,

dsdiv4:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,3
	jcry0 [aoja 1,.+1]
	lshc 1,-2
	tlne 1,100000
	tlo 1,600000
	popj 17,

dudiv4:
	lshc 1,-2
	popj 17,

dsdiv8:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,7
	jcry0 [aoja 1,.+1]
	lshc 1,-3
	tlne 1,40000
	tlo 1,700000
	popj 17,

dudiv8:
	lshc 1,-3
	popj 17,

dsdiv16:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,17
	jcry0 [aoja 1,.+1]
	lshc 1,-4
	tlne 1,20000
	tlo 1,740000
	popj 17,

dudiv16:
	lshc 1,-4
	popj 17,

dsdiv32:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,37
	jcry0 [aoja 1,.+1]
	lshc 1,-5
	tlne 1,10000
	tlo 1,760000
	popj 17,

dudiv32:
	lshc 1,-5
	popj 17,

dsdiv64:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,77
	jcry0 [aoja 1,.+1]
	lshc 1,-6
	tlne 1,4000
	tlo 1,770000
	popj 17,

dudiv64:
	lshc 1,-6
	popj 17,

dsmod2:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 6,1
	move 7,2
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,1
	jcry0 [aoja 6,.+1]
	lshc 6,-1
	tlne 6,200000
	tlo 6,400000
	lshc 6,1
	move 2,11
	sub 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	camg 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	sub 1,6
	sub 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dumod2:
	movei 1,0
	andi 2,1
	popj 17,

dsmod4:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 6,1
	move 7,2
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,3
	jcry0 [aoja 6,.+1]
	lshc 6,-2
	tlne 6,100000
	tlo 6,600000
	lshc 6,2
	move 2,11
	sub 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	camg 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	sub 1,6
	sub 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dumod4:
	movei 1,0
	andi 2,3
	popj 17,

dsmod8:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 6,1
	move 7,2
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,7
	jcry0 [aoja 6,.+1]
	lshc 6,-3
	tlne 6,40000
	tlo 6,700000
	lshc 6,3
	move 2,11
	sub 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	camg 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	sub 1,6
	sub 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dumod8:
	movei 1,0
	andi 2,7
	popj 17,

dsmod16:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 6,1
	move 7,2
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,17
	jcry0 [aoja 6,.+1]
	lshc 6,-4
	tlne 6,20000
	tlo 6,740000
	lshc 6,4
	move 2,11
	sub 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	camg 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	sub 1,6
	sub 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dumod16:
	movei 1,0
	andi 2,17
	popj 17,

dsmod32:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 6,1
	move 7,2
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,37
	jcry0 [aoja 6,.+1]
	lshc 6,-5
	tlne 6,10000
	tlo 6,760000
	lshc 6,5
	move 2,11
	sub 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	camg 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	sub 1,6
	sub 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dumod32:
	movei 1,0
	andi 2,37
	popj 17,

dsmod64:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 6,1
	move 7,2
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,77
	jcry0 [aoja 6,.+1]
	lshc 6,-6
	tlne 6,4000
	tlo 6,770000
	lshc 6,6
	move 2,11
	sub 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	camg 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	sub 1,6
	sub 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

dumod64:
	movei 1,0
	andi 2,77
	popj 17,

sashl_var:
	lsh 1,(2)
	popj 17,

ulshl_var:
	lsh 1,(2)
	popj 17,

sashr_var:
	movn 2,2
	ash 1,(2)
	popj 17,

ulshr_var:
	movn 2,2
	lsh 1,(2)
	popj 17,

dashl_var:
	lshc 1,(3)
	popj 17,

dlshl_var:
	lshc 1,(3)
	popj 17,

dashr_var:
	move 4,1
	ash 4,-43
	xor 1,4
	xor 2,4
	movn 3,3
	lshc 1,(3)
	xor 1,4
	xor 2,4
	popj 17,

dlshr_var:
	movn 3,3
	lshc 1,(3)
	popj 17,

sdiv_pow2_neg_bias:
	move 4,1
	lsh 4,-43
	add 4,1
	ash 4,-1
	trnn 2,1
	jrst %L157
	move 3,1
	jumpl 1,%L162
%L158:
	ash 3,-2
%L161:
	add 4,3
	move 1,4
	popj 17,
%L162:
	addi 3,3
	jrst %L158
%L157:
	skipge 3,1
	jrst %L163
%L160:
	ash 3,-3
	jrst %L161
%L163:
	addi 3,7
	jrst %L160

div_pow2_neg_bias:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,1
	move 7,2
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,1
	jcry0 [aoja 6,.+1]
	lshc 6,-1
	tlne 6,200000
	tlo 6,400000
	trnn 3,1
	jrst %L166
	move 10,1
	move 11,2
	jumpge 10,.+4
	jfcl 17,.+1
	addi 11,3
	jcry0 [aoja 10,.+1]
	lshc 10,-2
	tlne 10,100000
	tlo 10,600000
%L169:
	move 5,7
	add 5,11
	move 3,5
	tlc 3,400000
	move 2,7
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,6
	add 4,10
	add 4,3
	move 6,4
	move 7,5
	move 1,6
	move 2,7
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L166:
	move 10,1
	move 11,2
	jumpge 10,.+4
	jfcl 17,.+1
	addi 11,7
	jcry0 [aoja 10,.+1]
	lshc 10,-3
	tlnn 10,40000
	jrst %L169
	tlo 10,700000
	jrst %L169

smod_pow2_neg:
	move 4,1
	lsh 4,-43
	add 4,1
	andcmi 4,1
	move 6,1
	sub 6,4
	move 4,6
	trnn 2,1
	jrst %L171
	move 3,1
	jumpl 1,%L176
%L172:
	andcmi 3,3
%L175:
	sub 1,3
	add 4,1
	move 1,4
	popj 17,
%L176:
	addi 3,3
	jrst %L172
%L171:
	move 3,1
	jumpl 1,%L177
%L174:
	andcmi 3,7
	jrst %L175
%L177:
	addi 3,7
	jrst %L174

dmod_pow2_neg:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,2
	move 6,3
	move 2,1
	move 3,2
	jumpge 2,.+4
	jfcl 17,.+1
	addi 3,1
	jcry0 [aoja 2,.+1]
	lshc 2,-1
	tlne 2,200000
	tlo 2,400000
	lshc 2,1
	move 11,13
	sub 11,3
	move 4,11
	tlc 4,400000
	move 1,13
	tlc 1,400000
	camg 4,1
	tdza 4,4
	movei 4,1
	move 10,12
	sub 10,2
	sub 10,4
	trnn 6,1
	jrst %L180
	move 6,12
	move 7,13
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,3
	jcry0 [aoja 6,.+1]
	lshc 6,-2
	tlne 6,100000
	tlo 6,600000
	lshc 6,2
%L184:
	move 3,13
	sub 3,7
	move 4,3
	tlc 4,400000
	camg 4,1
	tdza 4,4
	movei 4,1
	move 2,12
	sub 2,6
	sub 2,4
	move 5,11
	add 5,3
	move 1,5
	tlc 1,400000
	move 6,11
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	move 4,10
	add 4,2
	add 4,1
	move 10,4
	move 11,5
	move 1,10
	move 2,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L180:
	move 6,12
	move 7,13
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,7
	jcry0 [aoja 6,.+1]
	lshc 6,-3
	tlne 6,40000
	tlo 6,700000
	lshc 6,3
	jrst %L184

shift_s_mem:
	move 5,1
	move 3,(1)
	move 6,3
	lsh 6,1
	move 4,3
	ash 4,-1
	add 6,4
	move 1,3
	jumpl 3,%L188
%L186:
	move 7,1
	ash 7,-2
	add 7,6
	move 4,3
	jumpl 3,%L189
%L187:
	andcmi 4,7
	move 1,3
	sub 1,4
	add 1,7
	lsh 3,(2)
	add 1,3
	movem 1,(5)
	popj 17,
%L189:
	addi 4,7
	jrst %L187
%L188:
	addi 1,3
	jrst %L186

shift_us_mem:
	move 6,1
	move 4,(1)
	move 1,4
	lsh 1,1
	move 3,4
	lsh 3,-1
	add 1,3
	move 3,4
	lsh 3,-2
	add 1,3
	move 3,4
	andi 3,7
	add 1,3
	movn 2,2
	lsh 4,(2)
	add 1,4
	movem 1,(6)
	popj 17,

shift_d_mem:
	add 17,[10,,10]
	movem 16,-7(17)
	movei 0,-6(17)
	hrli 0,10
	blt 0,-1(17)
	move 14,1
	movem 2,(17)
	move 12,(1)
	move 13,1(1)
	move 10,12
	move 11,13
	lshc 10,1
	move 6,12
	move 7,13
	lshc 6,-1
	tlne 6,200000
	tlo 6,400000
	move 2,11
	add 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	add 1,6
	add 1,4
	move 6,12
	move 7,13
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,3
	jcry0 [aoja 6,.+1]
	lshc 6,-2
	tlne 6,100000
	tlo 6,600000
	move 11,2
	add 11,7
	move 4,11
	tlc 4,400000
	move 3,2
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,1
	add 10,6
	add 10,4
	move 6,12
	move 7,13
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,7
	jcry0 [aoja 6,.+1]
	lshc 6,-3
	tlne 6,40000
	tlo 6,700000
	lshc 6,3
	move 5,13
	sub 5,7
	move 3,5
	tlc 3,400000
	move 2,13
	tlc 2,400000
	camg 3,2
	tdza 3,3
	movei 3,1
	move 4,12
	sub 4,6
	sub 4,3
	move 3,11
	add 3,5
	move 1,3
	tlc 1,400000
	move 6,11
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	move 2,10
	add 2,4
	add 2,1
	move 7,12
	move 10,13
	lshc 7,@(17)
	move 5,3
	add 5,10
	move 1,5
	tlc 1,400000
	move 6,3
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	move 4,2
	add 4,7
	add 1,4
	movem 1,(14)
	movem 5,1(14)
	move 15,(14)
	move 16,5
	move 1,15
	move 2,16
	move 16,-7(17)
	movei 0,10
	hrli 0,-6(17)
	blt 0,15
	add 17,[-10,,-10]
	popj 17,

shift_ud_mem:
	add 17,[11,,11]
	movem 16,-10(17)
	movei 0,-7(17)
	hrli 0,10
	blt 0,-2(17)
	setzm -1(17)
	setzm (17)
	move 13,(1)
	move 14,1(1)
	move 6,13
	move 7,14
	lshc 6,1
	move 11,13
	move 12,14
	lshc 11,-1
	move 5,7
	add 5,12
	move 3,5
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 4,6
	add 4,11
	add 4,3
	move 15,13
	move 16,14
	lshc 15,-2
	move 11,5
	add 11,16
	move 3,11
	tlc 3,400000
	move 6,5
	tlc 6,400000
	caml 3,6
	tdza 3,3
	movei 3,1
	move 10,4
	add 10,15
	add 10,3
	movei 4,0
	move 5,14
	andi 5,7
	move 7,11
	add 7,5
	move 3,7
	tlc 3,400000
	move 12,11
	tlc 12,400000
	caml 3,12
	tdza 3,3
	movei 3,1
	move 6,10
	add 6,4
	add 6,3
	movn 2,2
	lshc 13,(2)
	move 5,7
	add 5,14
	move 2,5
	tlc 2,400000
	move 3,7
	tlc 3,400000
	caml 2,3
	tdza 2,2
	movei 2,1
	move 4,6
	add 4,13
	add 2,4
	movem 2,(1)
	movem 5,1(1)
	move 1,(1)
	movem 1,-1(17)
	movem 5,(17)
	move 1,-1(17)
	move 2,(17)
	move 16,-10(17)
	movei 0,10
	hrli 0,-7(17)
	blt 0,15
	add 17,[-11,,-11]
	popj 17,

shift_s_struct:
	move 6,1
	move 1,(1)
	move 3,1
	lsh 3,1
	move 4,1
	ash 4,-2
	add 3,4
	move 4,1
	jumpl 1,%L199
%L197:
	move 2,4
	ash 2,-3
	add 2,3
	move 4,1
	jumpl 1,%L200
%L198:
	andcmi 4,3
	sub 1,4
	add 1,2
	movem 1,(6)
	move 3,1(6)
	move 4,3
	lsh 4,2
	move 2,3
	lsh 2,-3
	add 4,2
	add 4,2
	andi 3,3
	add 4,3
	movem 4,1(6)
	add 1,4
	popj 17,
%L200:
	addi 4,3
	jrst %L198
%L199:
	addi 4,7
	jrst %L197

shift_d_struct:
	add 17,[25,,25]
	movem 16,-24(17)
	movei 0,-23(17)
	hrli 0,10
	blt 0,-16(17)
	setzm -15(17)
	setzm -14(17)
	setzm -13(17)
	setzm -12(17)
	setzm -11(17)
	setzm -10(17)
	setzm -7(17)
	setzm -6(17)
	setzm -5(17)
	setzm -4(17)
	setzm -3(17)
	setzm -2(17)
	setzm -1(17)
	setzm (17)
	move 14,1
	move 12,(1)
	move 13,1(1)
	move 10,12
	move 11,13
	lshc 10,1
	move 4,12
	move 5,13
	move 6,4
	move 7,5
	lshc 6,-2
	tlne 6,100000
	tlo 6,600000
	move 2,11
	add 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	add 1,6
	add 1,4
	move 5,(14)
	movem 5,-15(17)
	movem 13,-14(17)
	move 6,-15(17)
	move 7,-14(17)
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,7
	jcry0 [aoja 6,.+1]
	lshc 6,-3
	tlne 6,40000
	tlo 6,700000
	move 11,2
	add 11,7
	move 4,11
	tlc 4,400000
	move 3,2
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,1
	add 10,6
	add 10,4
	move 15,(14)
	move 16,13
	move 6,15
	move 7,16
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,3
	jcry0 [aoja 6,.+1]
	lshc 6,-2
	tlne 6,100000
	tlo 6,600000
	lshc 6,2
	move 3,16
	sub 3,7
	move 4,3
	tlc 4,400000
	move 1,16
	tlc 1,400000
	camg 4,1
	tdza 4,4
	movei 4,1
	move 2,15
	sub 2,6
	sub 2,4
	move 5,11
	add 5,3
	move 1,5
	tlc 1,400000
	move 6,11
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	move 4,10
	add 4,2
	add 1,4
	movem 1,(14)
	movem 5,1(14)
	move 5,2(14)
	movem 5,-13(17)
	move 6,3(14)
	movem 6,-12(17)
	move 6,-13(17)
	move 7,-12(17)
	lshc 6,2
	move 5,-13(17)
	movem 5,-11(17)
	move 5,-12(17)
	movem 5,-10(17)
	move 10,-11(17)
	move 11,-10(17)
	lshc 10,-3
	move 5,7
	add 5,11
	move 3,5
	tlc 3,400000
	move 2,7
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,6
	add 4,10
	add 4,3
	move 6,-13(17)
	movem 6,-7(17)
	move 6,-12(17)
	movem 6,-6(17)
	move 10,-7(17)
	move 11,-6(17)
	lshc 10,-3
	move 7,5
	add 7,11
	move 3,7
	tlc 3,400000
	move 2,5
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 6,4
	add 6,10
	add 6,3
	move 5,-13(17)
	movem 5,-5(17)
	move 5,-12(17)
	movem 5,-4(17)
	movei 4,0
	andi 5,3
	move 3,7
	add 3,5
	move 1,3
	tlc 1,400000
	move 10,7
	tlc 10,400000
	caml 1,10
	tdza 1,1
	movei 1,1
	move 2,6
	add 2,4
	add 1,2
	movem 1,2(14)
	movem 3,3(14)
	move 6,(14)
	movem 6,-3(17)
	move 5,1(14)
	movem 5,-2(17)
	move 14,2(14)
	movem 14,-1(17)
	movem 3,(17)
	move 2,5
	add 2,3
	move 4,2
	tlc 4,400000
	move 3,5
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,-3(17)
	move 5,-1(17)
	add 1,5
	add 1,4
	move 16,-24(17)
	movei 0,10
	hrli 0,-23(17)
	blt 0,15
	add 17,[-25,,-25]
	popj 17,

shift_branch_s:
	move 3,1
	jumpl 1,%L210
%L206:
	ash 3,-3
	move 4,3
	lsh 4,3
	sub 1,4
	seto 4,
	jumpl 3,%L205
	skipe 4,1
	movei 4,1
%L205:
	move 1,4
	popj 17,
%L210:
	addi 3,7
	jrst %L206

shift_branch_d:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	move 12,1
	move 13,2
	jumpge 10,.+4
	jfcl 17,.+1
	addi 11,7
	jcry0 [aoja 10,.+1]
	lshc 10,-3
	tlne 10,40000
	tlo 10,700000
	move 4,12
	move 5,13
	jumpge 4,.+4
	jfcl 17,.+1
	addi 5,7
	jcry0 [aoja 4,.+1]
	lshc 4,-3
	tlne 4,40000
	tlo 4,700000
	lshc 4,3
	move 7,13
	sub 7,5
	move 3,7
	tlc 3,400000
	move 2,13
	tlc 2,400000
	camg 3,2
	tdza 3,3
	movei 3,1
	move 6,12
	sub 6,4
	sub 6,3
	jumpl 10,%L215
	jumpn 10,%L214
	cail 11,0
	cail 11,0
	jrst %L214
%L215:
	seto 1,
%L211:
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L214:
	move 4,6
	ior 4,7
	skipe 1,4
	movei 1,1
	jrst %L211

shift_call_arg:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	move 12,1
	move 13,2
	lshc 12,1
	move 6,1
	move 7,2
	lshc 6,-1
	tlne 6,200000
	tlo 6,400000
	move 2,13
	add 2,7
	move 4,2
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,12
	add 1,6
	add 1,4
	move 6,10
	move 7,11
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,3
	jcry0 [aoja 6,.+1]
	lshc 6,-2
	tlne 6,100000
	tlo 6,600000
	move 13,2
	add 13,7
	move 4,13
	tlc 4,400000
	move 3,2
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,1
	add 12,6
	add 12,4
	move 6,10
	move 7,11
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,7
	jcry0 [aoja 6,.+1]
	lshc 6,-3
	tlne 6,40000
	tlo 6,700000
	lshc 6,3
	move 5,11
	sub 5,7
	move 3,5
	tlc 3,400000
	move 2,11
	tlc 2,400000
	camg 3,2
	tdza 3,3
	movei 3,1
	move 4,10
	sub 4,6
	sub 4,3
	move 11,13
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,12
	add 10,4
	add 10,3
	move 1,10
	move 2,11
	pushj 17,use_dint
	move 1,10
	move 2,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.globl	use_shifts
use_shifts:
	add 17,[56,,56]
	movem 16,-55(17)
	movei 0,-54(17)
	hrli 0,10
	blt 0,-47(17)
	setzm -37(17)
	setzm -36(17)
	setzm -35(17)
	setzm -34(17)
	setzm -33(17)
	setzm -32(17)
	setzm -31(17)
	setzm -30(17)
	setzm -27(17)
	setzm -26(17)
	setzm -25(17)
	setzm -24(17)
	setzm -23(17)
	setzm -22(17)
	setzm -21(17)
	setzm -20(17)
	setzm -17(17)
	setzm -16(17)
	setzm -15(17)
	setzm -14(17)
	setzm -13(17)
	setzm -12(17)
	setzm -11(17)
	setzm -10(17)
	setzm -7(17)
	setzm -6(17)
	setzm -5(17)
	setzm -4(17)
	setzm -3(17)
	setzm -2(17)
	move 13,-60(17)
	move 14,-57(17)
	move 6,vgs
	add 6,gs
	add 6,1
	movem 6,-42(17)
	move 1,vgus
	add 1,gus
	add 1,2
	movem 1,-41(17)
	move 6,gd
	move 7,gd+1
	move 11,vgd
	move 12,vgd+1
	move 2,7
	add 2,12
	move 5,2
	tlc 5,400000
	move 10,7
	tlc 10,400000
	caml 5,10
	tdza 5,5
	movei 5,1
	move 1,6
	add 1,11
	add 1,5
	move 7,2
	add 7,4
	move 10,7
	tlc 10,400000
	move 5,2
	tlc 5,400000
	caml 10,5
	tdza 10,10
	movei 10,1
	move 6,1
	add 6,3
	add 10,6
	movem 10,-46(17)
	movei 16,-46(17)
	movem 7,1(16)
	move 2,gud
	move 3,gud+1
	move 7,vgud
	move 10,vgud+1
	move 5,3
	add 5,10
	move 1,5
	tlc 1,400000
	move 6,3
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	move 4,2
	add 4,7
	add 4,1
	move 3,5
	add 3,14
	move 6,3
	tlc 6,400000
	move 1,5
	tlc 1,400000
	caml 6,1
	tdza 6,6
	movei 6,1
	move 2,4
	add 2,13
	add 6,2
	movem 6,-44(17)
	movei 10,-44(17)
	movem 3,1(10)
	movei 1,-42(17)
	move 2,-61(17)
	pushj 17,shift_s_mem
	movem 1,gs
	movei 1,-41(17)
	move 2,-61(17)
	pushj 17,shift_us_mem
	movem 1,gus
	movei 1,-46(17)
	move 2,-61(17)
	pushj 17,shift_d_mem
	movem 1,gd
	movem 2,gd+1
	move 1,10
	move 2,-61(17)
	pushj 17,shift_ud_mem
	movem 1,gud
	movem 2,gud+1
	movei 6,-42(17)
	movem 6,-1(17)
	move 6,(6)
	movem 6,(17)
	move 1,6
	pushj 17,ashl1
	move 13,1
	ash 1,-43
	move 12,1
	move 1,(17)
	pushj 17,ashl18
	move 5,1
	ash 1,-43
	move 11,13
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,12
	add 10,1
	add 10,3
	movei 4,-41(17)
	move 4,(4)
	movem 4,-40(17)
	move 1,4
	pushj 17,lshl18
	movei 4,0
	move 13,11
	add 13,1
	move 3,13
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 12,10
	add 12,4
	add 12,3
	move 1,(17)
	pushj 17,ashr35
	move 5,1
	ash 1,-43
	move 11,13
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,12
	add 10,1
	add 10,3
	move 1,-40(17)
	pushj 17,lshr35
	movei 4,0
	move 13,11
	add 13,1
	move 3,13
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 12,10
	add 12,4
	add 12,3
	move 1,(17)
	pushj 17,sdiv2
	move 5,1
	ash 1,-43
	move 15,13
	add 15,5
	move 3,15
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 14,12
	add 14,1
	add 14,3
	move 1,(17)
	pushj 17,sdiv8
	move 5,1
	ash 1,-43
	move 11,15
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,15
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,14
	add 10,1
	add 10,3
	move 1,-40(17)
	pushj 17,udiv8
	movei 4,0
	move 15,11
	add 15,1
	move 3,15
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 14,10
	add 14,4
	add 14,3
	move 1,(17)
	pushj 17,smod8
	move 5,1
	ash 1,-43
	move 13,15
	add 13,5
	move 3,13
	tlc 3,400000
	move 2,15
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 12,14
	add 12,1
	add 12,3
	move 1,-40(17)
	pushj 17,umod8
	movei 4,0
	move 11,13
	add 11,1
	move 3,11
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,12
	add 10,4
	add 10,3
	move 6,(16)
	movem 6,-37(17)
	move 6,1(16)
	movem 6,-36(17)
	move 1,-37(17)
	move 2,-36(17)
	pushj 17,dashl36
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 6,-44(17)
	movem 6,-35(17)
	move 6,-43(17)
	movem 6,-34(17)
	move 1,-35(17)
	move 2,-34(17)
	pushj 17,dlshl36
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	move 6,(16)
	movem 6,-33(17)
	move 6,1(16)
	movem 6,-32(17)
	move 1,-33(17)
	move 2,-32(17)
	pushj 17,dashr70
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 6,-44(17)
	movem 6,-31(17)
	move 6,-43(17)
	movem 6,-30(17)
	move 1,-31(17)
	move 2,-30(17)
	pushj 17,dlshr70
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	move 6,(16)
	movem 6,-27(17)
	move 6,1(16)
	movem 6,-26(17)
	move 1,-27(17)
	move 2,-26(17)
	pushj 17,dsdiv2
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 6,(16)
	movem 6,-25(17)
	move 6,1(16)
	movem 6,-24(17)
	move 1,-25(17)
	move 2,-24(17)
	pushj 17,dsdiv8
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	move 6,-44(17)
	movem 6,-23(17)
	move 6,-43(17)
	movem 6,-22(17)
	move 1,-23(17)
	move 2,-22(17)
	pushj 17,dudiv8
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 6,(16)
	movem 6,-21(17)
	move 6,1(16)
	movem 6,-20(17)
	move 1,-21(17)
	move 2,-20(17)
	pushj 17,dsmod8
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	move 6,-44(17)
	movem 6,-17(17)
	move 6,-43(17)
	movem 6,-16(17)
	move 1,-17(17)
	move 2,-16(17)
	pushj 17,dumod8
	move 15,11
	add 15,2
	move 4,15
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 14,10
	add 14,1
	add 14,4
	move 1,(17)
	move 2,-61(17)
	pushj 17,sashl_var
	move 5,1
	ash 1,-43
	move 13,15
	add 13,5
	move 3,13
	tlc 3,400000
	move 2,15
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 12,14
	add 12,1
	add 12,3
	move 1,-40(17)
	move 2,-61(17)
	pushj 17,ulshr_var
	movei 4,0
	move 11,13
	add 11,1
	move 3,11
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,12
	add 10,4
	add 10,3
	move 6,(16)
	movem 6,-15(17)
	move 6,1(16)
	movem 6,-14(17)
	move 1,-15(17)
	move 2,-14(17)
	move 3,-61(17)
	pushj 17,dashl_var
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 6,-44(17)
	movem 6,-13(17)
	move 6,-43(17)
	movem 6,-12(17)
	move 1,-13(17)
	move 2,-12(17)
	move 3,-61(17)
	pushj 17,dlshr_var
	move 15,13
	add 15,2
	move 4,15
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 14,12
	add 14,1
	add 14,4
	move 1,(17)
	move 2,-61(17)
	pushj 17,sdiv_pow2_neg_bias
	move 5,1
	ash 1,-43
	move 11,15
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,15
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,14
	add 10,1
	add 10,3
	move 6,(16)
	movem 6,-11(17)
	move 6,1(16)
	movem 6,-10(17)
	move 1,-11(17)
	move 2,-10(17)
	move 3,-61(17)
	pushj 17,div_pow2_neg_bias
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 1,(17)
	move 2,-61(17)
	pushj 17,smod_pow2_neg
	move 5,1
	ash 1,-43
	move 11,13
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,12
	add 10,1
	add 10,3
	move 6,(16)
	movem 6,-7(17)
	move 6,1(16)
	movem 6,-6(17)
	move 1,-7(17)
	move 2,-6(17)
	move 3,-61(17)
	pushj 17,dmod_pow2_neg
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	movei 1,gs_slot
	pushj 17,shift_s_struct
	move 5,1
	ash 1,-43
	move 11,13
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,12
	add 10,1
	add 10,3
	movei 1,gd_slot
	pushj 17,shift_d_struct
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 6,-1(17)
	move 1,(6)
	pushj 17,shift_branch_s
	move 5,1
	ash 1,-43
	move 15,13
	add 15,5
	move 3,15
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 14,12
	add 14,1
	add 14,3
	move 6,(16)
	movem 6,-5(17)
	move 6,1(16)
	movem 6,-4(17)
	move 1,-5(17)
	move 2,-4(17)
	pushj 17,shift_branch_d
	move 5,1
	ash 1,-43
	move 11,15
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,15
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,14
	add 10,1
	add 10,3
	move 6,(16)
	movem 6,-3(17)
	move 16,1(16)
	movem 16,-2(17)
	move 1,-3(17)
	move 2,-2(17)
	pushj 17,shift_call_arg
	move 6,1
	move 7,2
	move 2,11
	add 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	add 1,6
	add 1,4
	move 16,-55(17)
	movei 0,10
	hrli 0,-54(17)
	blt 0,15
	add 17,[-56,,-56]
	popj 17,

