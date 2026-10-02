	.data
	.align	2
gc_a:
	.long	0
	.long	11219468956
	.align	2
vgc_a:
	.long	0
	.long	1402433620
	.align	2
guc_a:
	.long	0
	.long	11219468956
	.align	2
vguc_a:
	.long	68719476735
	.long	68719476735
	.align	2
gc_pair:
	.long	0
	.long	342391
	.long	68719476735
	.long	68717422383
	.align	2
guc_pair:
	.long	0
	.long	262143
	.long	68719476735
	.long	68719476735
	.align	2
gc_arr:
	.long	0
	.long	0
	.long	0
	.long	1
	.long	68719476735
	.long	68719476735
	.long	0
	.long	11219468956
	.align	2
guc_arr:
	.long	0
	.long	0
	.long	0
	.long	1
	.long	68719476735
	.long	68719476735
	.long	0
	.long	11219468956

onecmpldi_reg:
	setca 1,
	setca 2,
	popj 17,

uonecmpldi_reg:
	setca 1,
	setca 2,
	popj 17,

onecmpldi_mem:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	move 1,4
	move 2,5
	popj 17,

uonecmpldi_mem:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	move 1,4
	move 2,5
	popj 17,

onecmpldi_global:
	move 1,gc_a
	move 2,gc_a+1
	setca 1,
	setca 2,
	popj 17,

uonecmpldi_global:
	move 1,guc_a
	move 2,guc_a+1
	setca 1,
	setca 2,
	popj 17,

onecmpldi_volatile:
	move 1,vgc_a
	move 2,vgc_a+1
	setca 1,
	setca 2,
	popj 17,

uonecmpldi_volatile:
	move 1,vguc_a
	move 2,vguc_a+1
	setca 1,
	setca 2,
	popj 17,

onecmpldi_const_zero:
	seto 1,
	movni 2,1
	popj 17,

onecmpldi_const_one:
	seto 1,
	movni 2,2
	popj 17,

onecmpldi_const_minus_one:
	setzb 1,2
	popj 17,

onecmpldi_store:
	setca 2,
	setca 3,
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	popj 17,

uonecmpldi_store:
	setca 2,
	setca 3,
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	popj 17,

onecmpldi_store_mem:
	move 4,(2)
	move 5,1(2)
	setca 4,
	setca 5,
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

uonecmpldi_store_mem:
	move 4,(2)
	move 5,1(2)
	setca 4,
	setca 5,
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

onecmpldi_update:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

uonecmpldi_update:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

onecmpldi_update_void:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	movem 4,(1)
	movem 5,1(1)
	popj 17,

uonecmpldi_update_void:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	movem 4,(1)
	movem 5,1(1)
	popj 17,

onecmpldi_struct:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	move 1,4
	move 2,5
	popj 17,

uonecmpldi_struct:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	move 1,4
	move 2,5
	popj 17,

onecmpldi_struct_store:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	movem 4,2(1)
	movem 5,3(1)
	move 2,2(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

uonecmpldi_struct_store:
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	movem 4,2(1)
	movem 5,3(1)
	move 2,2(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

onecmpldi_array:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	setca 4,
	setca 5,
	move 1,4
	move 2,5
	popj 17,

uonecmpldi_array:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	setca 4,
	setca 5,
	move 1,4
	move 2,5
	popj 17,

onecmpldi_array_store:
	lsh 2,1
	add 2,1
	move 4,2(2)
	move 5,3(2)
	setca 4,
	setca 5,
	movem 4,(2)
	movem 5,1(2)
	popj 17,

uonecmpldi_array_store:
	lsh 2,1
	add 2,1
	move 4,2(2)
	move 5,3(2)
	setca 4,
	setca 5,
	movem 4,(2)
	movem 5,1(2)
	popj 17,

onecmpldi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	setca 10,
	setca 11,
	move 1,10
	move 2,11
	pushj 17,sink_dint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

uonecmpldi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	setca 10,
	setca 11,
	move 1,10
	move 2,11
	pushj 17,sink_udint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

onecmpldi_double_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	move 10,(2)
	move 11,1(2)
	setca 10,
	setca 11,
	move 1,4
	move 2,5
	pushj 17,sink_dint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

uonecmpldi_double_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 4,(1)
	move 5,1(1)
	setca 4,
	setca 5,
	move 10,(2)
	move 11,1(2)
	setca 10,
	setca 11,
	move 1,4
	move 2,5
	pushj 17,sink_udint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.globl	use_one_cmpldi2
use_one_cmpldi2:
	add 17,[14,,14]
	movei 0,-13(17)
	hrli 0,10
	blt 0,-6(17)
	move 10,1
	move 11,2
	move 12,3
	move 13,4
	move 15,-15(17)
	movem 1,-5(17)
	movem 11,-4(17)
	movem 3,-3(17)
	movem 13,-2(17)
	hrloi 6,1777
	movem 6,-1(17)
	hrroi 6,777763
	movem 6,(17)
	pushj 17,onecmpldi_reg
	pushj 17,sink_dint
	movei 14,-5(17)
	move 1,14
	pushj 17,onecmpldi_mem
	pushj 17,sink_dint
	pushj 17,onecmpldi_global
	pushj 17,sink_dint
	pushj 17,onecmpldi_volatile
	movem 1,vgc_b
	movem 2,vgc_b+1
	pushj 17,sink_dint
	pushj 17,onecmpldi_const_zero
	pushj 17,sink_dint
	pushj 17,onecmpldi_const_one
	pushj 17,sink_dint
	pushj 17,onecmpldi_const_minus_one
	pushj 17,sink_dint
	movei 1,gc_b
	move 2,10
	move 3,11
	pushj 17,onecmpldi_store
	pushj 17,sink_dint
	move 11,14
	addi 11,4
	move 10,14
	addi 10,2
	move 1,11
	move 2,10
	pushj 17,onecmpldi_store_mem
	pushj 17,sink_dint
	move 1,14
	pushj 17,onecmpldi_update
	pushj 17,sink_dint
	move 1,10
	pushj 17,onecmpldi_update_void
	movei 1,gc_pair
	pushj 17,onecmpldi_struct
	pushj 17,sink_dint
	movei 1,gc_pair
	pushj 17,onecmpldi_struct_store
	pushj 17,sink_dint
	move 2,15
	andi 2,1
	move 1,14
	pushj 17,onecmpldi_array_store
	andi 15,3
	movei 1,gc_arr
	move 2,15
	pushj 17,onecmpldi_array
	pushj 17,sink_dint
	move 1,12
	move 2,13
	pushj 17,onecmpldi_call_arg
	pushj 17,sink_dint
	move 1,14
	move 2,11
	pushj 17,onecmpldi_double_mem
	movei 0,10
	hrli 0,-13(17)
	blt 0,15
	add 17,[-14,,-14]
	popj 17,

	.globl	use_uone_cmpldi2
use_uone_cmpldi2:
	add 17,[14,,14]
	movei 0,-13(17)
	hrli 0,10
	blt 0,-6(17)
	move 10,1
	move 11,2
	move 13,3
	move 14,4
	move 15,-15(17)
	movem 1,-5(17)
	movem 11,-4(17)
	movem 3,-3(17)
	movem 14,-2(17)
	setom -1(17)
	hrroi 6,777763
	movem 6,(17)
	pushj 17,uonecmpldi_reg
	pushj 17,sink_udint
	movei 12,-5(17)
	move 1,12
	pushj 17,uonecmpldi_mem
	pushj 17,sink_udint
	pushj 17,uonecmpldi_global
	pushj 17,sink_udint
	pushj 17,uonecmpldi_volatile
	movem 1,vguc_b
	movem 2,vguc_b+1
	pushj 17,sink_udint
	movei 1,guc_b
	move 2,10
	move 3,11
	pushj 17,uonecmpldi_store
	pushj 17,sink_udint
	move 11,12
	addi 11,4
	move 10,12
	addi 10,2
	move 1,11
	move 2,10
	pushj 17,uonecmpldi_store_mem
	pushj 17,sink_udint
	move 1,12
	pushj 17,uonecmpldi_update
	pushj 17,sink_udint
	move 1,10
	pushj 17,uonecmpldi_update_void
	movei 1,guc_pair
	pushj 17,uonecmpldi_struct
	pushj 17,sink_udint
	movei 1,guc_pair
	pushj 17,uonecmpldi_struct_store
	pushj 17,sink_udint
	move 2,15
	andi 2,1
	move 1,12
	pushj 17,uonecmpldi_array_store
	andi 15,3
	movei 1,guc_arr
	move 2,15
	pushj 17,uonecmpldi_array
	pushj 17,sink_udint
	move 1,13
	move 2,14
	pushj 17,uonecmpldi_call_arg
	pushj 17,sink_udint
	move 1,12
	move 2,11
	pushj 17,uonecmpldi_double_mem
	movei 0,10
	hrli 0,-13(17)
	blt 0,15
	add 17,[-14,,-14]
	popj 17,

	.bss
gc_b:
	.space	8
vgc_b:
	.space	8
guc_b:
	.space	8
vguc_b:
	.space	8
