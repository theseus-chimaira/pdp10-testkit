	.data
	.align	2
gs_a:
	.word	12345
	.align	2
gs_b:
	.word	777777777001
	.align	2
vgs_a:
	.word	777777777655
	.align	2
gf_a:
	.word	10064000000
	.align	2
gf_b:
	.word	27654000000
	.align	2
vgf_a:
	.word	27642000000
	.align	2
gi_slot:
	.word	10
	.word	777777777760
	.align	2
gf_slot:
	.word	10162000000
	.word	27607000000

movn_reg:
	movn 2,2
	move 1,2
	popj 17,

movn_mem:
	movn 1,(2)
	popj 17,

movni_small:
	setca 1,
	popj 17,

movnm_store:
	movn 1,1
	movem 1,(2)
	popj 17,

movns_self:
	movns 4,(1)
	move 1,4
	popj 17,

movn_global:
	movn 1,gs_a
	sub 1,gs_b
	popj 17,

movn_volatile:
	move 1,vgs_a
	movn 1,1
	popj 17,

movn_struct:
	movns 3,(1)
	movns 4,1(1)
	add 3,4
	move 1,3
	popj 17,

movn_branch:
	movn 1,1
	seto 4,
	jumpl 1,%L9
	skipe 4,1
	movei 4,1
%L9:
	move 1,4
	popj 17,

fmovn_reg:
			; truncdfsf2
	movn 3,3
	move 1,3	; movsf
	popj 17,

fmovn_mem:
	movn 1,(3)
	popj 17,

fmovnm_store:
			; truncdfsf2
	movn 1,1
	movem 1,(3)	; movsf
	popj 17,

fmovns_self:
	movns 4,(1)
	move 1,4	; movsf
	popj 17,

fmovn_global:
	movn 1,gf_a
	fsbr 1,gf_b
	popj 17,

fmovn_volatile:
	move 1,vgf_a	; movsf
	movn 1,1
	popj 17,

fmovn_struct:
	movns 3,(1)
	movns 4,1(1)
	fadr 3,4
	move 1,3	; movsf
	popj 17,

movns_both_intaa:
	movns 1,(2)
	popj 17,

movns_both_intab:
	movns 1,(2)
	popj 17,

movns_both_intba:
	movns 1,(2)
	popj 17,

movns_both_intbb:
	movns 1,(2)
	popj 17,

movns_both_floataa:
	movns 1,(2)
	popj 17,

movns_both_floatab:
	movns 1,(2)
	popj 17,

movns_both_floatba:
	movns 1,(2)
	popj 17,

movns_both_floatbb:
	movns 1,(2)
	popj 17,

	.globl	use_movn_int
use_movn_int:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	move 11,1
	move 10,2
	movem 2,(17)
	movei 2,gs_a
	pushj 17,movnm_store
	movem 1,gs_a
	movei 1,(17)
	pushj 17,movns_self
	move 1,11
	move 2,10
	pushj 17,movn_reg
	move 10,1
	move 1,11
	move 2,17
	pushj 17,movn_mem
	add 10,1
	move 1,11
	pushj 17,movni_small
	add 10,1
	pushj 17,movn_global
	add 10,1
	pushj 17,movn_volatile
	add 10,1
	movei 1,gi_slot
	pushj 17,movn_struct
	add 10,1
	move 1,11
	pushj 17,movn_branch
	add 10,1
	move 1,11
	move 2,17
	pushj 17,movns_both_intaa
	add 10,1
	move 1,11
	move 2,17
	pushj 17,movns_both_intbb
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	umvflt
umvflt:
	add 17,[7,,7]
	movei 0,-6(17)
	hrli 0,10
	blt 0,-1(17)
	move 14,1	; movdf
	move 15,2	; movdf
	move 10,3	; movdf
	move 11,4	; movdf
			; truncdfsf2
			; truncdfsf2
	movem 10,(17)	; movsf
	move 12,14	; extendsfdf2
	movei 13,0	; extendsfdf2
	move 1,12	; movdf
	move 2,13	; movdf
	movei 3,gf_a
	pushj 17,fmovnm_store
	movem 1,gf_a	; movsf
	movei 1,(17)
	pushj 17,fmovns_self
	move 3,10	; extendsfdf2
	movei 4,0	; extendsfdf2
	move 1,12	; movdf
	move 2,13	; movdf
	pushj 17,fmovn_reg
	move 10,1	; movsf
	move 1,12	; movdf
	move 2,13	; movdf
	move 3,17
	pushj 17,fmovn_mem
	fadr 10,1
	pushj 17,fmovn_global
	fadr 10,1
	pushj 17,fmovn_volatile
	fadr 10,1
	movei 1,gf_slot
	pushj 17,fmovn_struct
	fadr 10,1
	move 1,14	; movsf
	move 2,17
	pushj 17,movns_both_floataa
	fadr 10,1
	move 1,14	; movsf
	move 2,17
	pushj 17,movns_both_floatbb
	fadr 10,1
	move 1,10	; movsf
	movei 0,10
	hrli 0,-6(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

