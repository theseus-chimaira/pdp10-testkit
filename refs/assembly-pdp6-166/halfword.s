	.data
	.align	2
gh1:
	.word	123456
	.align	2
guh1:
	.word	654321
	.align	2
gw1:
	.word	123456000001
	.align	2
gw2:
	.word	765432123456
	.align	2
gsh:
	.word	123456777655
	.align	2
guh:
	.word	123456654321
	.align	2
gsb:
	.word	777777123456
	.align	2
gub:
	.word	777777123456
	.align	2
gmix:
	.word	777777123456
	.word	123456000001
	.word	777776000123
	.align	2
hvec:
	.word	1
	.word	777777123456
	.word	765433377777
	.word	400000000777
	.align	2
uhvec:
	.word	1
	.word	777777123456
	.word	654321400000
	.word	377777000777
	.align	2
wvec:
	.word	0
	.word	1
	.word	777777777777
	.word	123456000001
	.word	765432123456
	.word	400000000000

half_hrr_or:
	hllz 1,1
	iori 1,(2)
	popj 17,

half_hrr_or_mem:
	hllz 1,(1)
	iori 1,(2)
	popj 17,

half_hrr_or_store:
	hrrm 2,(1)
	popj 17,

half_hrr_add:
	hllz 1,1
	iori 1,(2)
	popj 17,

half_hrr_add_mem:
	hllz 1,(1)
	iori 1,(2)
	popj 17,

half_hrr_add_store:
	hrrm 2,(1)
	popj 17,

half_hll_or:
	hllz 2,2
	iori 2,(1)
	move 1,2
	popj 17,

half_hll_or_mem:
	hrrz 1,(1)
	hllz 2,2
	ior 1,2
	popj 17,

half_hll_or_store:
	hllm 2,(1)
	popj 17,

half_hll_add:
	hllz 2,2
	iori 2,(1)
	move 1,2
	popj 17,

half_hll_add_mem:
	hrrz 1,(1)
	hllz 2,2
	add 1,2
	popj 17,

half_hll_add_store:
	hllm 2,(1)
	popj 17,

half_hrl_or:
	hrlz 2,2
	iori 2,(1)
	move 1,2
	popj 17,

half_hrl_or_mem:
	hrrz 1,(1)
	tlo 1,(2)
	popj 17,

half_hrl_or_store:
	hrlm 2,(1)
	popj 17,

half_hrl_add:
	hrlz 2,2
	iori 2,(1)
	move 1,2
	popj 17,

half_hrl_add_mem:
	hrrz 1,(1)
	hrlz 2,2
	add 1,2
	popj 17,

half_hrl_add_store:
	hrlm 2,(1)
	popj 17,

half_hlr_or:
	hllz 1,1
	hlrz 2,2
	ior 1,2
	popj 17,

half_hlr_or_mem:
	hllz 1,(1)
	hlrz 2,2
	ior 1,2
	popj 17,

half_hlr_or_store:
	hlrm 2,(1)
	popj 17,

half_hlr_add:
	hllz 1,1
	hlrz 2,2
	add 1,2
	popj 17,

half_hlr_add_mem:
	hllz 1,(1)
	hlrz 2,2
	add 1,2
	popj 17,

half_hlr_add_store:
	hlrm 2,(1)
	popj 17,

half_hrrz:
	hrrz 2,2
	move 1,2
	popj 17,

half_hrrz_mem:
	hrrz 2,2
	move 1,2
	popj 17,

half_hrrz_store:
	hrrzm 2,(1)
	popj 17,

half_hllz:
	hllz 2,2
	move 1,2
	popj 17,

half_hllz_mem:
	hllz 2,2
	move 1,2
	popj 17,

half_hllz_store:
	hllzm 2,(1)
	popj 17,

half_hrlz:
	hrlz 2,2
	move 1,2
	popj 17,

half_hrlz_mem:
	hrlz 2,2
	move 1,2
	popj 17,

half_hrlz_store:
	hrlzm 2,(1)
	popj 17,

half_hlrz:
	hlrz 2,2
	move 1,2
	popj 17,

half_hlrz_mem:
	hlrz 2,2
	move 1,2
	popj 17,

half_hlrz_store:
	hlrzm 2,(1)
	popj 17,

half_hrro:
	hrro 2,2
	move 1,2
	popj 17,

half_hrro_mem:
	hrro 2,2
	move 1,2
	popj 17,

half_hrro_store:
	hrrom 2,(1)
	popj 17,

half_hllo:
	hllo 2,2
	move 1,2
	popj 17,

half_hllo_mem:
	hllo 2,2
	move 1,2
	popj 17,

half_hllo_store:
	hllom 2,(1)
	popj 17,

half_hrlo:
	hrlo 2,2
	move 1,2
	popj 17,

half_hrlo_mem:
	hrlo 2,2
	move 1,2
	popj 17,

half_hrlo_store:
	hrlo 2,2
	movem 2,(1)
	popj 17,

half_hlro:
	hlro 2,2
	move 1,2
	popj 17,

half_hlro_mem:
	hlro 2,2
	move 1,2
	popj 17,

half_hlro_store:
	hlro 2,2
	movem 2,(1)
	popj 17,

half_hrre:
	hrre 2,2
	move 1,2
	popj 17,

half_hrre_mem:
	hrre 2,2
	move 1,2
	popj 17,

half_hrre_store:
	hrre 2,2
	movem 2,(1)
	popj 17,

half_hlre:
	hlre 2,2
	move 1,2
	popj 17,

half_hlre_mem:
	hlre 2,2
	move 1,2
	popj 17,

half_hlre_store:
	hlrem 2,(1)
	popj 17,

half_signr_masked:
	hrre 2,2
	move 1,2
	popj 17,

half_signr_masked_mem:
	hrre 2,2
	move 1,2
	popj 17,

half_signr_masked_store:
	hrre 2,2
	movem 2,(1)
	popj 17,

half_signl_masked:
	hlrz 2,2
	move 1,2
	popj 17,

half_signl_masked_mem:
	hlrz 2,2
	move 1,2
	popj 17,

half_signl_masked_store:
	hlrzm 2,(1)
	popj 17,

combine_from_halves:
	hrrz 2,2
	tlo 2,(1)
	move 1,2
	popj 17,

combine_from_uhalves:
	hrlz 1,1
	iori 1,(2)
	popj 17,

replace_right_field:
	move 4,1
	hrr 4,2
	hlre 1,4
	hrre 4,4
	move 2,4
	jrst combine_from_halves

replace_left_field:
	move 4,1
	hll 4,2
	hlre 1,4
	hrre 4,4
	move 2,4
	jrst combine_from_halves

cross_hrl_field:
	move 4,1
	hrl 4,2
	hlre 1,4
	hrre 4,4
	move 2,4
	jrst combine_from_halves

cross_hlr_field:
	move 4,1
	hlr 4,2
	hlre 1,4
	hrre 4,4
	move 2,4
	jrst combine_from_halves

replace_right_ufield:
	move 4,1
	hrr 4,2
	hlrz 1,4
	hrrz 4,4
	move 2,4
	jrst combine_from_uhalves

replace_left_ufield:
	move 4,1
	hll 4,2
	hlrz 1,4
	hrrz 4,4
	move 2,4
	jrst combine_from_uhalves

cross_hrl_ufield:
	move 4,1
	hrl 4,2
	hlrz 1,4
	hrrz 4,4
	move 2,4
	jrst combine_from_uhalves

cross_hlr_ufield:
	move 4,1
	hlr 4,2
	hlrz 1,4
	hrrz 4,4
	move 2,4
	jrst combine_from_uhalves

bit_right:
	hrr 1,2
	popj 17,

bit_left:
	hll 1,2
	popj 17,

bit_cross_hrl:
	hrl 1,2
	popj 17,

bit_cross_hlr:
	hlr 1,2
	popj 17,

ubit_right:
	hrr 1,2
	popj 17,

ubit_left:
	hll 1,2
	popj 17,

clear_right_bits:
	hllz 1,1
	popj 17,

clear_left_bits:
	hrrz 1,1
	popj 17,

ones_right_bits:
	hllo 1,1
	popj 17,

ones_left_bits:
	hrro 1,1
	popj 17,

load_hint_global:
	hrre 1,gh0
	hrre 4,gh1
	add 1,4
	hlrz 6,guh0
	add 1,6
	hlrz 6,guh1
	add 1,6
	popj 17,

store_hint_global:
	movem 1,gh0
	movem 2,guh0
	popj 17,

load_half_arrays:
	push 17,10
	move 3,[POINT 18,hvec,17]
	move 4,3
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 10,4
	hrre 10,10
	move 4,[POINT 18,uhvec,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	add 10,4
	move 4,1
	andi 4,7
	move 6,3
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	ldb 6,6
	hrre 6,6
	addi 1,1
	andi 1,7
	move 4,3
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 2,4
	hrre 2,2
	move 1,6
	pushj 17,combine_from_halves
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

store_half_arrays:
	push 17,10
	setzb 6,7
	setzb 4,5
	move 3,1
	andi 3,7
	move 10,[POINT 18,hvec,17]
	move 0,3
	jumple 0,.+3
	ibp 10
	sojg 0,.-1
	dpb 2,10	; movhi
	move 3,1
	addi 3,1
	andi 3,7
	move 10,[POINT 18,uhvec,17]
	move 0,3
	jumple 0,.+3
	ibp 10
	sojg 0,.-1
	hllm 2,(10)
	move 6,1
	addi 6,2
	idivi 6,6
	hllz 2,2
	move 4,1
	idivi 4,6
	hrrz 4,wvec(5)
	ior 2,4
	movem 2,wvec(7)
	pop 17,10
	popj 17,

volatile_half_struct:
	hlrz 4,1
	hrlm 4,vgsh
	hrrm 1,vgsh
	hrlm 4,vgub
	hrrm 1,vgub
	hlrz 1,vgsh
	hrre 1,1
	hrrz 2,vgsh
	hrre 2,2
	pushj 17,combine_from_halves
	move 3,1
	move 1,vgub
	hllz 1,1
	hrrz 4,vgub
	ior 1,4
	add 1,3
	popj 17,

pointer_half_fields:
	hllm 2,(1)
	hrrm 2,(1)
	hrrm 2,1(1)
	hrrm 2,2(1)
	hlre 4,(1)
	hrrz 3,(1)
	add 4,3
	add 4,1(1)
	hrre 3,2(1)
	add 4,3
	move 1,4
	popj 17,

select_half:
	jumpl 1,%L91
	jumpn 1,%L89
	hllz 1,3
	iori 1,(2)
%L87:
	popj 17,
%L89:
	cain 1,1
	jrst %L92
	hlrz 1,3
	hllz 4,2
	ior 1,4
	popj 17,
%L92:
	hrrz 1,2
	tlo 1,(3)
	popj 17,
%L91:
	hllz 1,2
	iori 1,(3)
	popj 17,

compare_half:
	hrrz 6,1
	hrrz 4,2
	hlre 3,1
	camn 6,4
	jrst %L93
	hrre 3,2
	camge 6,4
	jrst %L93
	hlrz 3,1
	hlrz 4,2
	sub 3,4
%L93:
	move 1,3
	popj 17,

use_halfword:
	add 17,[10,,10]
	movem 16,-7(17)
	movei 0,-6(17)
	hrli 0,10
	blt 0,-1(17)
	move 13,1
	move 11,2
	move 12,3
	move 14,gsh
	move 15,guh
	move 16,gsb
	move 6,gub
	movem 6,(17)
	hrre 1,2	; extendhisi2
	move 2,3
	hrrzi 2,(2)	; zero_extendhisi2
	pushj 17,store_hint_global
	move 1,13
	move 2,11
	pushj 17,store_half_arrays
	move 1,11
	move 2,12
	pushj 17,half_hrr_or
	move 10,1
	move 1,11
	move 2,12
	pushj 17,half_hll_or
	add 10,1
	move 1,11
	move 2,12
	pushj 17,half_hrl_or
	add 10,1
	move 1,11
	move 2,12
	pushj 17,half_hlr_or
	add 10,1
	move 1,11
	move 2,12
	pushj 17,half_hrrz
	add 10,1
	move 1,11
	move 2,12
	pushj 17,half_hllz
	add 10,1
	move 1,11
	move 2,12
	pushj 17,half_hrre
	add 10,1
	move 1,11
	move 2,12
	pushj 17,half_hlre
	add 10,1
	move 1,14
	move 2,gsh
	pushj 17,replace_right_field
	add 10,1
	move 1,15
	move 2,guh
	pushj 17,replace_left_ufield
	add 10,1
	move 1,16
	move 2,gsb
	pushj 17,bit_right
	add 10,1
	move 1,(17)
	move 2,gub
	pushj 17,ubit_left
	add 10,1
	pushj 17,load_hint_global
	add 10,1
	move 1,13
	pushj 17,load_half_arrays
	add 10,1
	move 1,11
	pushj 17,volatile_half_struct
	add 10,1
	movei 1,gmix
	move 2,12
	pushj 17,pointer_half_fields
	add 10,1
	move 1,13
	move 2,11
	move 3,12
	pushj 17,select_half
	add 10,1
	move 1,11
	move 2,12
	pushj 17,compare_half
	add 10,1
	add 10,gw0
	add 10,gw1
	add 10,gw2
	move 1,10
	move 16,-7(17)
	movei 0,10
	hrli 0,-6(17)
	blt 0,15
	add 17,[-10,,-10]
	popj 17,

	.bss
gh0:
	.space	4
guh0:
	.space	4
gw0:
	.space	4
vgsh:
	.space	4
vgub:
	.space	4
