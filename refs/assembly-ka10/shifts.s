	.data
	.align	2
gs:
	.long	68719464391
	.align	2
gus:
	.long	68719476735
	.align	2
gd:
	.long	68719476735
	.long	68718242169
	.align	2
gud:
	.long	68719476735
	.long	68719476735
	.align	2
vgs:
	.long	68719476659
	.align	2
vgus:
	.long	262143
	.align	2
vgd:
	.long	68719476735
	.long	68718698959
	.align	2
vgud:
	.long	68719476735
	.long	68719476735
	.align	2
gs_slot:
	.long	68719476637
	.long	262143
	.long	3
	.align	2
gd_slot:
	.long	68719476735
	.long	68719376737
	.long	68719476735
	.long	68719476735
	.long	5

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
	tlne 1,200000
	tloa 1,400000
	tlz 1,400000
	ashc 1,1
	popj 17,

dlshl1:
	tlne 1,200000
	tloa 1,400000
	tlz 1,400000
	ashc 1,1
	popj 17,

dashl2:
	tlne 1,100000
	tloa 1,400000
	tlz 1,400000
	ashc 1,2
	popj 17,

dlshl2:
	tlne 1,100000
	tloa 1,400000
	tlz 1,400000
	ashc 1,2
	popj 17,

dashl3:
	tlne 1,40000
	tloa 1,400000
	tlz 1,400000
	ashc 1,3
	popj 17,

dlshl3:
	tlne 1,40000
	tloa 1,400000
	tlz 1,400000
	ashc 1,3
	popj 17,

dashl4:
	tlne 1,20000
	tloa 1,400000
	tlz 1,400000
	ashc 1,4
	popj 17,

dlshl4:
	tlne 1,20000
	tloa 1,400000
	tlz 1,400000
	ashc 1,4
	popj 17,

dashl8:
	tlne 1,1000
	tloa 1,400000
	tlz 1,400000
	ashc 1,10
	popj 17,

dlshl8:
	tlne 1,1000
	tloa 1,400000
	tlz 1,400000
	ashc 1,10
	popj 17,

dashl18:
	trne 1,400000
	tloa 1,400000
	tlz 1,400000
	ashc 1,22
	popj 17,

dlshl18:
	trne 1,400000
	tloa 1,400000
	tlz 1,400000
	ashc 1,22
	popj 17,

dashl35:
	trne 1,1
	tloa 1,400000
	tlz 1,400000
	ashc 1,43
	popj 17,

dlshl35:
	trne 1,1
	tloa 1,400000
	tlz 1,400000
	ashc 1,43
	popj 17,

dashl36:
	lshc 1,45
	tlne 1,400000
	tlo 2,400000
	popj 17,

dlshl36:
	lshc 1,45
	tlne 1,400000
	tlo 2,400000
	popj 17,

dsmul2:
	tlne 1,200000
	tloa 1,400000
	tlz 1,400000
	ashc 1,1
	popj 17,

dumul2:
	tlne 1,200000
	tloa 1,400000
	tlz 1,400000
	ashc 1,1
	popj 17,

dsmul4:
	tlne 1,100000
	tloa 1,400000
	tlz 1,400000
	ashc 1,2
	popj 17,

dumul4:
	tlne 1,100000
	tloa 1,400000
	tlz 1,400000
	ashc 1,2
	popj 17,

dsmul8:
	tlne 1,40000
	tloa 1,400000
	tlz 1,400000
	ashc 1,3
	popj 17,

dumul8:
	tlne 1,40000
	tloa 1,400000
	tlz 1,400000
	ashc 1,3
	popj 17,

dashr1:
	ashc 1,-1
	popj 17,

dlshr1:
	ashc 1,-1
	tlze 1,400000
	tlz 2,400000
	popj 17,

dashr2:
	ashc 1,-2
	popj 17,

dlshr2:
	ashc 1,-2
	tlze 1,600000
	tlz 2,400000
	popj 17,

dashr3:
	ashc 1,-3
	popj 17,

dlshr3:
	ashc 1,-3
	tlze 1,700000
	tlz 2,400000
	popj 17,

dashr4:
	ashc 1,-4
	popj 17,

dlshr4:
	ashc 1,-4
	tlze 1,740000
	tlz 2,400000
	popj 17,

dashr8:
	ashc 1,-10
	popj 17,

dlshr8:
	ashc 1,-10
	tlze 1,776000
	tlz 2,400000
	popj 17,

dashr18:
	ashc 1,-22
	popj 17,

dlshr18:
	ashc 1,-22
	tlze 1,777777
	tlz 2,400000
	popj 17,

dashr35:
	ashc 1,-43
	popj 17,

dlshr35:
	lshc 1,-44
	popj 17,

dashr36:
	ashc 1,-44
	popj 17,

dlshr36:
	lshc 1,-45
	popj 17,

dashr37:
	ashc 1,-45
	popj 17,

dlshr37:
	lshc 1,-46
	popj 17,

dashr63:
	ashc 1,-77
	popj 17,

dlshr63:
	lshc 1,-100
	popj 17,

dashr70:
	ashc 1,-106
	popj 17,

dlshr70:
	lshc 1,-107
	popj 17,

dsdiv2:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,2]
	move 1,4
	move 2,5
	popj 17,

dudiv2:
	ashc 1,-1
	tlze 1,400000
	tlz 2,400000
	popj 17,

dsdiv4:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,4]
	move 1,4
	move 2,5
	popj 17,

dudiv4:
	ashc 1,-2
	tlze 1,600000
	tlz 2,400000
	popj 17,

dsdiv8:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,10]
	move 1,4
	move 2,5
	popj 17,

dudiv8:
	ashc 1,-3
	tlze 1,700000
	tlz 2,400000
	popj 17,

dsdiv16:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,20]
	move 1,4
	move 2,5
	popj 17,

dudiv16:
	ashc 1,-4
	tlze 1,740000
	tlz 2,400000
	popj 17,

dsdiv32:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,40]
	move 1,4
	move 2,5
	popj 17,

dudiv32:
	ashc 1,-5
	tlze 1,760000
	tlz 2,400000
	popj 17,

dsdiv64:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,100]
	move 1,4
	move 2,5
	popj 17,

dudiv64:
	ashc 1,-6
	tlze 1,770000
	tlz 2,400000
	popj 17,

dsmod2:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,2]
	move 1,6
	move 2,7
	popj 17,

dumod2:
	movei 1,0
	andi 2,1
	popj 17,

dsmod4:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,4]
	move 1,6
	move 2,7
	popj 17,

dumod4:
	movei 1,0
	andi 2,3
	popj 17,

dsmod8:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,10]
	move 1,6
	move 2,7
	popj 17,

dumod8:
	movei 1,0
	andi 2,7
	popj 17,

dsmod16:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,20]
	move 1,6
	move 2,7
	popj 17,

dumod16:
	movei 1,0
	andi 2,17
	popj 17,

dsmod32:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,40]
	move 1,6
	move 2,7
	popj 17,

dumod32:
	movei 1,0
	andi 2,37
	popj 17,

dsmod64:
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,100]
	move 1,6
	move 2,7
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
	lsh 2,1
	lshc 1,(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

dlshl_var:
	lsh 2,1
	lshc 1,(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

dashr_var:
	movn 3,3
	ashc 1,(3)
	popj 17,

dlshr_var:
	movn 3,3
	lsh 2,1
	lshc 1,(3)
	lsh 2,-1
	popj 17,

sdiv_pow2_neg_bias:
	move 4,1
	lsh 4,-43
	add 4,1
	ash 4,-1
	trnn 2,1
	jrst %L138
	move 3,1
	jumpl 1,%L143
%L139:
	ash 3,-2
%L142:
	add 4,3
	move 1,4
	popj 17,
%L143:
	addi 3,3
	jrst %L139
%L138:
	skipge 3,1
	jrst %L144
%L141:
	ash 3,-3
	jrst %L142
%L144:
	addi 3,7
	jrst %L141

div_pow2_neg_bias:
	add 17,[12,,12]
	movei 0,-11(17)
	hrli 0,10
	blt 0,-4(17)
	movei 7,0
	movem 7,-3(17)
	movem 7,-2(17)
	movem 7,-1(17)
	movem 7,(17)
	setzb 12,13
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,2]
	move 14,4
	move 15,5
	trnn 3,1
	jrst %L146
	movem 1,-3(17)
	move 7,1
	ash 7,-43
	movem 7,-3(17)
	movem 7,-2(17)
	movem 1,-1(17)
	movem 2,(17)
	move 6,-3(17)
	move 7,-2(17)
	move 10,-1(17)
	move 11,(17)
	ddiv 6,[0,4]
	movem 6,-3(17)
	movem 7,-2(17)
	movem 10,-1(17)
	movem 11,(17)
	move 6,-3(17)
	move 7,-2(17)
%L148:
	move 5,15
	add 5,7
	move 3,5
	tlc 3,400000
	move 2,15
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,14
	add 4,6
	add 4,3
	move 14,4
	move 15,5
	move 1,14
	move 2,15
	movei 0,10
	hrli 0,-11(17)
	blt 0,15
	add 17,[-12,,-12]
	popj 17,
%L146:
	move 10,1
	ash 10,-43
	move 11,10
	move 12,1
	move 13,2
	ddiv 10,[0,10]
	move 6,10
	move 7,11
	jrst %L148

smod_pow2_neg:
	move 4,1
	lsh 4,-43
	add 4,1
	andcmi 4,1
	move 6,1
	sub 6,4
	move 4,6
	trnn 2,1
	jrst %L150
	move 3,1
	jumpl 1,%L155
%L151:
	andcmi 3,3
%L154:
	sub 1,3
	add 4,1
	move 1,4
	popj 17,
%L155:
	addi 3,3
	jrst %L151
%L150:
	move 3,1
	jumpl 1,%L156
%L153:
	andcmi 3,7
	jrst %L154
%L156:
	addi 3,7
	jrst %L153

dmod_pow2_neg:
	add 17,[12,,12]
	movei 0,-11(17)
	hrli 0,10
	blt 0,-4(17)
	movei 7,0
	movem 7,-3(17)
	movem 7,-2(17)
	movem 7,-1(17)
	movem 7,(17)
	setzb 12,13
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,2]
	move 14,6
	move 15,7
	trnn 3,1
	jrst %L158
	movem 1,-3(17)
	move 7,1
	ash 7,-43
	movem 7,-3(17)
	movem 7,-2(17)
	movem 1,-1(17)
	movem 2,(17)
	move 6,-3(17)
	move 7,-2(17)
	move 10,-1(17)
	move 11,(17)
	ddiv 6,[0,4]
	movem 6,-3(17)
	movem 7,-2(17)
	movem 10,-1(17)
	movem 11,(17)
	move 6,10
	move 7,11
%L160:
	move 5,15
	add 5,7
	move 3,5
	tlc 3,400000
	move 2,15
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,14
	add 4,6
	add 4,3
	move 14,4
	move 15,5
	move 1,14
	move 2,15
	movei 0,10
	hrli 0,-11(17)
	blt 0,15
	add 17,[-12,,-12]
	popj 17,
%L158:
	move 10,1
	ash 10,-43
	move 11,10
	move 12,1
	move 13,2
	ddiv 10,[0,10]
	move 6,12
	move 7,13
	jrst %L160

shift_s_mem:
	move 5,1
	move 3,(1)
	move 6,3
	lsh 6,1
	move 4,3
	ash 4,-1
	add 6,4
	move 1,3
	jumpl 3,%L164
%L162:
	move 7,1
	ash 7,-2
	add 7,6
	move 4,3
	jumpl 3,%L165
%L163:
	andcmi 4,7
	move 1,3
	sub 1,4
	add 1,7
	lsh 3,(2)
	add 1,3
	movem 1,(5)
	popj 17,
%L165:
	addi 4,7
	jrst %L163
%L164:
	addi 1,3
	jrst %L162

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
	add 17,[21,,21]
	movem 16,-20(17)
	movei 0,-17(17)
	hrli 0,10
	blt 0,-12(17)
	setzm -11(17)
	setzm -10(17)
	setzm -1(17)
	setzm (17)
	move 3,(1)
	movem 3,-11(17)
	move 14,1(1)
	movem 14,-10(17)
	move 15,-11(17)
	move 16,-10(17)
	tlne 15,200000
	tloa 15,400000
	tlz 15,400000
	ashc 15,1
	movem 15,-7(17)
	movem 16,-6(17)
	move 14,-11(17)
	move 15,-10(17)
	ashc 14,-1
	movem 14,-5(17)
	movem 15,-4(17)
	move 15,-6(17)
	move 16,-4(17)
	add 15,16
	move 3,15
	tlc 3,400000
	move 16,-6(17)
	tlc 16,400000
	caml 3,16
	tdza 3,3
	movei 3,1
	move 14,-7(17)
	move 16,-5(17)
	add 14,16
	add 14,3
	move 4,(1)
	ash 4,-43
	move 5,4
	move 6,-11(17)
	move 7,-10(17)
	ddiv 4,[0,4]
	move 3,15
	add 3,5
	movem 3,-2(17)
	tlc 3,400000
	move 6,15
	tlc 6,400000
	caml 3,6
	tdza 3,3
	movei 3,1
	add 14,4
	movem 14,-3(17)
	move 6,14
	add 6,3
	movem 6,-3(17)
	move 10,(1)
	ash 10,-43
	move 11,10
	move 12,-11(17)
	move 13,-10(17)
	ddiv 10,[0,10]
	move 10,12
	move 11,13
	move 7,-2(17)
	add 7,11
	move 4,7
	tlc 4,400000
	move 3,-2(17)
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	add 6,12
	add 6,4
	move 10,-11(17)
	move 11,-10(17)
	lsh 11,1
	lshc 10,(2)
	lsh 11,-1
	tlne 10,400000
	tlo 11,400000
	move 5,7
	add 5,11
	move 2,5
	tlc 2,400000
	move 3,7
	tlc 3,400000
	caml 2,3
	tdza 2,2
	movei 2,1
	move 4,6
	add 4,10
	add 2,4
	movem 2,(1)
	movem 5,1(1)
	move 1,(1)
	movem 1,-1(17)
	movem 5,(17)
	move 1,-1(17)
	move 2,(17)
	move 16,-20(17)
	movei 0,10
	hrli 0,-17(17)
	blt 0,15
	add 17,[-21,,-21]
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
	tlne 6,200000
	tloa 6,400000
	tlz 6,400000
	ashc 6,1
	move 11,13
	move 12,14
	ashc 11,-1
	tlze 11,400000
	tlz 12,400000
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
	ashc 15,-2
	tlze 15,600000
	tlz 16,400000
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
	lsh 14,1
	lshc 13,(2)
	lsh 14,-1
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
	jumpl 1,%L172
%L170:
	move 2,4
	ash 2,-3
	add 2,3
	move 4,1
	jumpl 1,%L173
%L171:
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
%L173:
	addi 4,3
	jrst %L171
%L172:
	addi 4,7
	jrst %L170

shift_d_struct:
	add 17,[34,,34]
	movei 0,-33(17)
	hrli 0,10
	blt 0,-26(17)
	setzm -25(17)
	setzm -24(17)
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
	setzm -1(17)
	setzm (17)
	move 14,(1)
	movem 14,-25(17)
	move 15,1(1)
	movem 15,-24(17)
	move 14,-25(17)
	move 15,-24(17)
	tlne 14,200000
	tloa 14,400000
	tlz 14,400000
	ashc 14,1
	movem 14,-23(17)
	movem 15,-22(17)
	move 2,(1)
	move 15,-24(17)
	move 3,15
	ashc 2,-2
	movem 2,-21(17)
	movem 3,-20(17)
	move 3,-22(17)
	move 14,-20(17)
	add 3,14
	move 14,3
	tlc 14,400000
	move 15,-22(17)
	tlc 15,400000
	caml 14,15
	tdza 14,14
	movei 14,1
	move 2,-23(17)
	move 15,-21(17)
	add 2,15
	add 2,14
	move 14,(1)
	movem 14,-17(17)
	move 15,-24(17)
	movem 15,-16(17)
	move 4,(1)
	ash 4,-43
	move 5,4
	move 6,-17(17)
	move 7,-16(17)
	ddiv 4,[0,10]
	move 15,3
	add 15,5
	move 7,15
	tlc 7,400000
	move 6,3
	tlc 6,400000
	caml 7,6
	tdza 6,6
	movei 6,1
	move 14,2
	add 14,4
	add 14,6
	move 5,(1)
	movem 5,-15(17)
	move 6,-24(17)
	movem 6,-14(17)
	move 10,(1)
	ash 10,-43
	move 11,10
	move 12,-15(17)
	move 13,-14(17)
	ddiv 10,[0,4]
	move 6,12
	move 7,13
	move 5,15
	add 5,7
	move 2,5
	tlc 2,400000
	move 3,15
	tlc 3,400000
	caml 2,3
	tdza 2,2
	movei 2,1
	move 4,14
	add 4,12
	add 2,4
	movem 2,(1)
	movem 5,1(1)
	move 14,2(1)
	movem 14,-13(17)
	move 15,3(1)
	movem 15,-12(17)
	move 6,-13(17)
	move 7,-12(17)
	tlne 6,100000
	tloa 6,400000
	tlz 6,400000
	ashc 6,2
	move 5,-13(17)
	movem 5,-11(17)
	movem 15,-10(17)
	move 14,-11(17)
	move 15,-10(17)
	ashc 14,-3
	tlze 14,700000
	tlz 15,400000
	move 5,7
	add 5,15
	move 3,5
	tlc 3,400000
	move 2,7
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,6
	add 4,14
	add 4,3
	move 15,-13(17)
	movem 15,-7(17)
	move 6,-12(17)
	movem 6,-6(17)
	move 14,-7(17)
	move 15,-6(17)
	ashc 14,-3
	tlze 14,700000
	tlz 15,400000
	move 3,5
	add 3,15
	move 6,3
	tlc 6,400000
	move 7,5
	tlc 7,400000
	caml 6,7
	tdza 6,6
	movei 6,1
	move 2,4
	add 2,14
	add 2,6
	move 14,-13(17)
	movem 14,-5(17)
	move 15,-12(17)
	movem 15,-4(17)
	movei 14,0
	andi 15,3
	move 5,3
	add 5,15
	move 7,5
	tlc 7,400000
	move 6,3
	tlc 6,400000
	caml 7,6
	tdza 7,7
	movei 7,1
	move 4,2
	add 4,14
	add 7,4
	movem 7,2(1)
	movem 5,3(1)
	move 6,(1)
	movem 6,-3(17)
	move 14,1(1)
	movem 14,-2(17)
	move 1,2(1)
	movem 1,-1(17)
	movem 5,(17)
	move 2,14
	move 15,5
	add 2,5
	move 4,2
	tlc 4,400000
	move 3,14
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,-3(17)
	move 5,-1(17)
	add 1,5
	add 1,4
	movei 0,10
	hrli 0,-33(17)
	blt 0,15
	add 17,[-34,,-34]
	popj 17,

shift_branch_s:
	move 3,1
	jumpl 1,%L180
%L176:
	ash 3,-3
	move 4,3
	lsh 4,3
	sub 1,4
	seto 4,
	jumpl 3,%L175
	skipe 4,1
	movei 4,1
%L175:
	move 1,4
	popj 17,
%L180:
	addi 3,7
	jrst %L176

shift_branch_d:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,10]
	move 10,1
	ash 10,-43
	move 11,10
	move 12,1
	move 13,2
	ddiv 10,[0,10]
	move 2,12
	move 3,13
	jumpl 4,%L183
	jumpn 4,%L182
	cail 5,0
	cail 5,0
	jrst %L182
%L183:
	seto 1,
%L181:
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L182:
	move 4,2
	ior 4,3
	skipe 1,4
	movei 1,1
	jrst %L181

shift_call_arg:
	add 17,[13,,13]
	movem 16,-12(17)
	movei 0,-11(17)
	hrli 0,10
	blt 0,-4(17)
	move 14,1
	move 15,2
	tlne 14,200000
	tloa 14,400000
	tlz 14,400000
	ashc 14,1
	movem 14,-3(17)
	movem 15,-2(17)
	move 15,1
	move 16,2
	ashc 15,-1
	movem 15,-1(17)
	movem 16,(17)
	move 15,-2(17)
	add 15,16
	move 3,15
	tlc 3,400000
	move 16,-2(17)
	tlc 16,400000
	caml 3,16
	tdza 3,3
	movei 3,1
	move 14,-3(17)
	move 16,-1(17)
	add 14,16
	add 14,3
	move 4,1
	ash 4,-43
	move 5,4
	move 6,1
	move 7,2
	ddiv 4,[0,4]
	move 7,15
	add 7,5
	move 3,7
	tlc 3,400000
	move 16,15
	tlc 16,400000
	caml 3,16
	tdza 3,3
	movei 3,1
	move 6,14
	add 6,4
	add 6,3
	move 10,1
	ash 10,-43
	move 11,10
	move 12,1
	move 13,2
	ddiv 10,[0,10]
	move 1,12
	move 2,13
	move 11,7
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,7
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,6
	add 10,12
	add 10,4
	move 1,10
	move 2,11
	pushj 17,use_dint
	move 1,10
	move 2,11
	move 16,-12(17)
	movei 0,10
	hrli 0,-11(17)
	blt 0,15
	add 17,[-13,,-13]
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

