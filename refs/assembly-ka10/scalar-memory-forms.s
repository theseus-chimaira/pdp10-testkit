	.data
	.align	2
ps_native_char:
	.long	s_native_char+301989888
	.align	2
pa_native_char:
	.long	a_native_char+150994944
	.align	2
vps_native_char:
	.long	vs_native_char+301989888

ls_native_char:
	move 1,s_native_char
	popj 17,

ss_native_char:
	movem 1,s_native_char
	popj 17,

ssr_native_char:
	movem 1,s_native_char
	popj 17,

lv_native_char:
	move 1,vs_native_char
	popj 17,

sv_native_char:
	movem 1,vs_native_char
	popj 17,

lst_native_char:
	move 1,st_native_char
	lsh 1,-33
	popj 17,

lsy_native_char:
	ldb 1,[POINT 9,st_native_char,17]
	popj 17,

sst_native_char:
	dpb 1,[POINT 9,st_native_char,8]
	popj 17,

sstr_native_char:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,st_native_char,17]
	andi 1,777	; zero_extendqisi2
	popj 17,

lvs_native_char:
	ldb 1,[POINT 9,vst_native_char,8]
	popj 17,

svs_native_char:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vst_native_char,17]
	popj 17,

la_native_char:
	move 1,a_native_char
	lsh 1,-33
	popj 17,

sa_native_char:
	dpb 1,[POINT 9,a_native_char,8]
	popj 17,

lai_native_char:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_native_char,8]
	jumpe 4,%L19
%L18:
	ibp 3
	sojn 4,%L18	; decrement_and_branch_until_zero
%L19:
	ldb 1,3
	popj 17,

sai_native_char:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_native_char,8]
	jumpe 4,%L22
%L21:
	ibp 3
	sojn 4,%L21	; decrement_and_branch_until_zero
%L22:
	dpb 2,3
	popj 17,

lvi_native_char:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,va_native_char,8]
	jumpe 4,%L25
%L24:
	ibp 1
	sojn 4,%L24	; decrement_and_branch_until_zero
%L25:
	ldb 1,1
	popj 17,

svi_native_char:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,va_native_char,8]
	jumpe 4,%L28
%L27:
	ibp 3
	sojn 4,%L27	; decrement_and_branch_until_zero
%L28:
	dpb 2,3
	popj 17,

lp_native_char:
	ldb 1,1
	popj 17,

sp_native_char:
	dpb 2,1
	popj 17,

spr_native_char:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	move 1,2
	popj 17,

lpi_native_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L35
%L34:
	ibp 1
	sojn 4,%L34	; decrement_and_branch_until_zero
%L35:
	ldb 1,1
	popj 17,

spi_native_char:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L39
%L38:
	ibp 1
	sojn 4,%L38	; decrement_and_branch_until_zero
%L39:
	dpb 3,1
	popj 17,

lgp_native_char:
	ldb 1,ps_native_char
	popj 17,

lgap_native_char:
	ldb 1,pa_native_char
	popj 17,

lgvp_native_char:
	ldb 1,vps_native_char
	popj 17,

sgp_native_char:
	dpb 1,ps_native_char
	popj 17,

prp_native_char:
	ildb 1,1
	popj 17,

pip_native_char:
	ldb 4,1
	ildb 1,1
	add 4,1
	andi 4,777	; zero_extendqisi2
	move 1,4
	popj 17,

us_native_char:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,s_native_char,35]
	add 1,6
	movem 1,s_native_char
	andi 1,777
	popj 17,

ust_native_char:
	andi 1,777	; zero_extendqisi2
	ldb 4,[POINT 9,st_native_char,8]
	add 4,1
	dpb 4,[POINT 9,st_native_char,8]
	ldb 4,[POINT 9,st_native_char,17]
	sub 4,1
	dpb 4,[POINT 9,st_native_char,17]
	ldb 1,[POINT 9,st_native_char,8]
	ldb 4,[POINT 9,st_native_char,17]
	add 1,4
	andi 1,777	; zero_extendqisi2
	popj 17,

use_native_char:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	andi 11,7
	move 1,10
	pushj 17,ss_native_char
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sv_native_char
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sst_native_char
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,svs_native_char
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sa_native_char
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,11
	pushj 17,sai_native_char
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,11
	pushj 17,svi_native_char
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_char,17]
	pushj 17,sp_native_char
	addi 10,1
	move 3,10
	andi 3,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_char,8]
	move 2,11
	pushj 17,spi_native_char
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	subi 10,11
	pushj 17,sgp_native_char
	move 1,10
	pushj 17,ssr_native_char
	move 12,1
	andi 12,777	; zero_extendqisi2
	addi 10,12
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sstr_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	subi 10,13
	move 1,[POINT 9,a_native_char,26]
	pushj 17,spr_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,ls_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lv_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lst_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lsy_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lvs_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,la_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,11
	pushj 17,lai_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,11
	pushj 17,lvi_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_char,17]
	pushj 17,lp_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_char,8]
	move 2,11
	pushj 17,lpi_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgp_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgap_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgvp_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_char,8]
	pushj 17,prp_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_char,8]
	pushj 17,pip_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,10
	pushj 17,us_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,10
	pushj 17,ust_native_char
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_native_schar:
	.long	s_native_schar+301989888
	.align	2
pa_native_schar:
	.long	a_native_schar+150994944
	.align	2
vps_native_schar:
	.long	vs_native_schar+301989888

ls_native_schar:
	hrre 1,s_native_schar
	popj 17,

ss_native_schar:
	movem 1,s_native_schar
	popj 17,

ssr_native_schar:
	movem 1,s_native_schar
	lsh 1,33
	ash 1,-33
	popj 17,

lv_native_schar:
	hrre 1,vs_native_schar
	popj 17,

sv_native_schar:
	movem 1,vs_native_schar
	popj 17,

lst_native_schar:
	move 1,st_native_schar
	ash 1,-33
	popj 17,

lsy_native_schar:
	move 1,st_native_schar
	lsh 1,11
	ash 1,-33
	popj 17,

sst_native_schar:
	dpb 1,[POINT 9,st_native_schar,8]
	popj 17,

sstr_native_schar:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,st_native_schar,17]
	lsh 1,33
	ash 1,-33
	popj 17,

lvs_native_schar:
	ldb 1,[POINT 9,vst_native_schar,8]
	lsh 1,33
	ash 1,-33
	popj 17,

svs_native_schar:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vst_native_schar,17]
	popj 17,

la_native_schar:
	move 1,a_native_schar
	ash 1,-33
	popj 17,

sa_native_schar:
	dpb 1,[POINT 9,a_native_schar,8]
	popj 17,

lai_native_schar:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_native_schar,8]
	jumpe 4,%L81
%L80:
	ibp 3
	sojn 4,%L80	; decrement_and_branch_until_zero
%L81:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

sai_native_schar:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_native_schar,8]
	jumpe 4,%L84
%L83:
	ibp 3
	sojn 4,%L83	; decrement_and_branch_until_zero
%L84:
	dpb 2,3
	popj 17,

lvi_native_schar:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,va_native_schar,8]
	jumpe 4,%L87
%L86:
	ibp 1
	sojn 4,%L86	; decrement_and_branch_until_zero
%L87:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

svi_native_schar:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,va_native_schar,8]
	jumpe 4,%L90
%L89:
	ibp 3
	sojn 4,%L89	; decrement_and_branch_until_zero
%L90:
	dpb 2,3
	popj 17,

lp_native_schar:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

sp_native_schar:
	dpb 2,1
	popj 17,

spr_native_schar:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

lpi_native_schar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L97
%L96:
	ibp 1
	sojn 4,%L96	; decrement_and_branch_until_zero
%L97:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

spi_native_schar:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L101
%L100:
	ibp 1
	sojn 4,%L100	; decrement_and_branch_until_zero
%L101:
	dpb 3,1
	popj 17,

lgp_native_schar:
	ldb 1,ps_native_schar
	trne 1,400
	orcmi 1,777
	popj 17,

lgap_native_schar:
	ldb 1,pa_native_schar
	trne 1,400
	orcmi 1,777
	popj 17,

lgvp_native_schar:
	ldb 1,vps_native_schar
	trne 1,400
	orcmi 1,777
	popj 17,

sgp_native_schar:
	dpb 1,ps_native_schar
	popj 17,

prp_native_schar:
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

pip_native_schar:
	ldb 4,1
	ildb 1,1
	add 4,1
	lsh 4,33
	ash 4,-33
	move 1,4
	popj 17,

us_native_schar:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,s_native_schar,35]
	add 1,6
	movem 1,s_native_schar
	lsh 1,33
	ash 1,-33
	popj 17,

ust_native_schar:
	andi 1,777	; zero_extendqisi2
	ldb 4,[POINT 9,st_native_schar,8]
	add 4,1
	dpb 4,[POINT 9,st_native_schar,8]
	ldb 4,[POINT 9,st_native_schar,17]
	sub 4,1
	dpb 4,[POINT 9,st_native_schar,17]
	ldb 1,[POINT 9,st_native_schar,8]
	ldb 4,[POINT 9,st_native_schar,17]
	add 1,4
	lsh 1,33
	ash 1,-33
	popj 17,

use_native_schar:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	andi 11,7
	move 12,10
	lsh 12,33
	ash 12,-33
	move 1,12
	pushj 17,ss_native_schar
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sv_native_schar
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sst_native_schar
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,svs_native_schar
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sa_native_schar
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,11
	pushj 17,sai_native_schar
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,11
	pushj 17,svi_native_schar
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,[POINT 9,a_native_schar,17]
	pushj 17,sp_native_schar
	addi 10,1
	move 3,10
	lsh 3,33
	ash 3,-33
	move 1,[POINT 9,a_native_schar,8]
	move 2,11
	pushj 17,spi_native_schar
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sgp_native_schar
	move 1,12
	pushj 17,ssr_native_schar
	move 13,1
	andi 13,777	; zero_extendqisi2
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sstr_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	addi 10,1
	lsh 10,33
	ash 10,-33
	move 1,[POINT 9,a_native_schar,26]
	move 2,10
	pushj 17,spr_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,ls_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lv_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lst_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lsy_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lvs_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,la_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,11
	pushj 17,lai_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,11
	pushj 17,lvi_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_schar,17]
	pushj 17,lp_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_schar,8]
	move 2,11
	pushj 17,lpi_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgp_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgap_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgvp_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_schar,8]
	pushj 17,prp_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_schar,8]
	pushj 17,pip_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,12
	pushj 17,us_native_schar
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,12
	pushj 17,ust_native_schar
	add 13,1
	move 1,13
	lsh 1,33
	ash 1,-33
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_native_uchar:
	.long	s_native_uchar+301989888
	.align	2
pa_native_uchar:
	.long	a_native_uchar+150994944
	.align	2
vps_native_uchar:
	.long	vs_native_uchar+301989888

ls_native_uchar:
	move 1,s_native_uchar
	popj 17,

ss_native_uchar:
	movem 1,s_native_uchar
	popj 17,

ssr_native_uchar:
	movem 1,s_native_uchar
	popj 17,

lv_native_uchar:
	move 1,vs_native_uchar
	popj 17,

sv_native_uchar:
	movem 1,vs_native_uchar
	popj 17,

lst_native_uchar:
	move 1,st_native_uchar
	lsh 1,-33
	popj 17,

lsy_native_uchar:
	ldb 1,[POINT 9,st_native_uchar,17]
	popj 17,

sst_native_uchar:
	dpb 1,[POINT 9,st_native_uchar,8]
	popj 17,

sstr_native_uchar:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,st_native_uchar,17]
	andi 1,777	; zero_extendqisi2
	popj 17,

lvs_native_uchar:
	ldb 1,[POINT 9,vst_native_uchar,8]
	popj 17,

svs_native_uchar:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vst_native_uchar,17]
	popj 17,

la_native_uchar:
	move 1,a_native_uchar
	lsh 1,-33
	popj 17,

sa_native_uchar:
	dpb 1,[POINT 9,a_native_uchar,8]
	popj 17,

lai_native_uchar:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_native_uchar,8]
	jumpe 4,%L143
%L142:
	ibp 3
	sojn 4,%L142	; decrement_and_branch_until_zero
%L143:
	ldb 1,3
	popj 17,

sai_native_uchar:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_native_uchar,8]
	jumpe 4,%L146
%L145:
	ibp 3
	sojn 4,%L145	; decrement_and_branch_until_zero
%L146:
	dpb 2,3
	popj 17,

lvi_native_uchar:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,va_native_uchar,8]
	jumpe 4,%L149
%L148:
	ibp 1
	sojn 4,%L148	; decrement_and_branch_until_zero
%L149:
	ldb 1,1
	popj 17,

svi_native_uchar:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,va_native_uchar,8]
	jumpe 4,%L152
%L151:
	ibp 3
	sojn 4,%L151	; decrement_and_branch_until_zero
%L152:
	dpb 2,3
	popj 17,

lp_native_uchar:
	ldb 1,1
	popj 17,

sp_native_uchar:
	dpb 2,1
	popj 17,

spr_native_uchar:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	move 1,2
	popj 17,

lpi_native_uchar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L159
%L158:
	ibp 1
	sojn 4,%L158	; decrement_and_branch_until_zero
%L159:
	ldb 1,1
	popj 17,

spi_native_uchar:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L163
%L162:
	ibp 1
	sojn 4,%L162	; decrement_and_branch_until_zero
%L163:
	dpb 3,1
	popj 17,

lgp_native_uchar:
	ldb 1,ps_native_uchar
	popj 17,

lgap_native_uchar:
	ldb 1,pa_native_uchar
	popj 17,

lgvp_native_uchar:
	ldb 1,vps_native_uchar
	popj 17,

sgp_native_uchar:
	dpb 1,ps_native_uchar
	popj 17,

prp_native_uchar:
	ildb 1,1
	popj 17,

pip_native_uchar:
	ldb 4,1
	ildb 1,1
	add 4,1
	andi 4,777	; zero_extendqisi2
	move 1,4
	popj 17,

us_native_uchar:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,s_native_uchar,35]
	add 1,6
	movem 1,s_native_uchar
	andi 1,777
	popj 17,

ust_native_uchar:
	andi 1,777	; zero_extendqisi2
	ldb 4,[POINT 9,st_native_uchar,8]
	add 4,1
	dpb 4,[POINT 9,st_native_uchar,8]
	ldb 4,[POINT 9,st_native_uchar,17]
	sub 4,1
	dpb 4,[POINT 9,st_native_uchar,17]
	ldb 1,[POINT 9,st_native_uchar,8]
	ldb 4,[POINT 9,st_native_uchar,17]
	add 1,4
	andi 1,777	; zero_extendqisi2
	popj 17,

use_native_uchar:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	andi 11,7
	move 1,10
	pushj 17,ss_native_uchar
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sv_native_uchar
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sst_native_uchar
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,svs_native_uchar
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sa_native_uchar
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,11
	pushj 17,sai_native_uchar
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,11
	pushj 17,svi_native_uchar
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_uchar,17]
	pushj 17,sp_native_uchar
	addi 10,1
	move 3,10
	andi 3,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_uchar,8]
	move 2,11
	pushj 17,spi_native_uchar
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	subi 10,11
	pushj 17,sgp_native_uchar
	move 1,10
	pushj 17,ssr_native_uchar
	move 12,1
	andi 12,777	; zero_extendqisi2
	addi 10,12
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sstr_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	subi 10,13
	move 1,[POINT 9,a_native_uchar,26]
	pushj 17,spr_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,ls_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lv_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lst_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lsy_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lvs_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,la_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,11
	pushj 17,lai_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,11
	pushj 17,lvi_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_uchar,17]
	pushj 17,lp_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_uchar,8]
	move 2,11
	pushj 17,lpi_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgp_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgap_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgvp_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_uchar,8]
	pushj 17,prp_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_native_uchar,8]
	pushj 17,pip_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,10
	pushj 17,us_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,10
	pushj 17,ust_native_uchar
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_Qint:
	.long	s_Qint+301989888
	.align	2
pa_Qint:
	.long	a_Qint+150994944
	.align	2
vps_Qint:
	.long	vs_Qint+301989888

ls_Qint:
	hrre 1,s_Qint
	popj 17,

ss_Qint:
	movem 1,s_Qint
	popj 17,

ssr_Qint:
	movem 1,s_Qint
	lsh 1,33
	ash 1,-33
	popj 17,

lv_Qint:
	hrre 1,vs_Qint
	popj 17,

sv_Qint:
	movem 1,vs_Qint
	popj 17,

lst_Qint:
	move 1,st_Qint
	ash 1,-33
	popj 17,

lsy_Qint:
	move 1,st_Qint
	lsh 1,11
	ash 1,-33
	popj 17,

sst_Qint:
	dpb 1,[POINT 9,st_Qint,8]
	popj 17,

sstr_Qint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,st_Qint,17]
	lsh 1,33
	ash 1,-33
	popj 17,

lvs_Qint:
	ldb 1,[POINT 9,vst_Qint,8]
	lsh 1,33
	ash 1,-33
	popj 17,

svs_Qint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vst_Qint,17]
	popj 17,

la_Qint:
	move 1,a_Qint
	ash 1,-33
	popj 17,

sa_Qint:
	dpb 1,[POINT 9,a_Qint,8]
	popj 17,

lai_Qint:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_Qint,8]
	jumpe 4,%L205
%L204:
	ibp 3
	sojn 4,%L204	; decrement_and_branch_until_zero
%L205:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

sai_Qint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_Qint,8]
	jumpe 4,%L208
%L207:
	ibp 3
	sojn 4,%L207	; decrement_and_branch_until_zero
%L208:
	dpb 2,3
	popj 17,

lvi_Qint:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,va_Qint,8]
	jumpe 4,%L211
%L210:
	ibp 1
	sojn 4,%L210	; decrement_and_branch_until_zero
%L211:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

svi_Qint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,va_Qint,8]
	jumpe 4,%L214
%L213:
	ibp 3
	sojn 4,%L213	; decrement_and_branch_until_zero
%L214:
	dpb 2,3
	popj 17,

lp_Qint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

sp_Qint:
	dpb 2,1
	popj 17,

spr_Qint:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

lpi_Qint:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L221
%L220:
	ibp 1
	sojn 4,%L220	; decrement_and_branch_until_zero
%L221:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

spi_Qint:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L225
%L224:
	ibp 1
	sojn 4,%L224	; decrement_and_branch_until_zero
%L225:
	dpb 3,1
	popj 17,

lgp_Qint:
	ldb 1,ps_Qint
	trne 1,400
	orcmi 1,777
	popj 17,

lgap_Qint:
	ldb 1,pa_Qint
	trne 1,400
	orcmi 1,777
	popj 17,

lgvp_Qint:
	ldb 1,vps_Qint
	trne 1,400
	orcmi 1,777
	popj 17,

sgp_Qint:
	dpb 1,ps_Qint
	popj 17,

prp_Qint:
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

pip_Qint:
	ldb 4,1
	ildb 1,1
	add 4,1
	lsh 4,33
	ash 4,-33
	move 1,4
	popj 17,

us_Qint:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,s_Qint,35]
	add 1,6
	movem 1,s_Qint
	lsh 1,33
	ash 1,-33
	popj 17,

ust_Qint:
	andi 1,777	; zero_extendqisi2
	ldb 4,[POINT 9,st_Qint,8]
	add 4,1
	dpb 4,[POINT 9,st_Qint,8]
	ldb 4,[POINT 9,st_Qint,17]
	sub 4,1
	dpb 4,[POINT 9,st_Qint,17]
	ldb 1,[POINT 9,st_Qint,8]
	ldb 4,[POINT 9,st_Qint,17]
	add 1,4
	lsh 1,33
	ash 1,-33
	popj 17,

use_Qint:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	andi 11,7
	move 12,10
	lsh 12,33
	ash 12,-33
	move 1,12
	pushj 17,ss_Qint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sv_Qint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sst_Qint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,svs_Qint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sa_Qint
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,11
	pushj 17,sai_Qint
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,11
	pushj 17,svi_Qint
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,[POINT 9,a_Qint,17]
	pushj 17,sp_Qint
	addi 10,1
	move 3,10
	lsh 3,33
	ash 3,-33
	move 1,[POINT 9,a_Qint,8]
	move 2,11
	pushj 17,spi_Qint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sgp_Qint
	move 1,12
	pushj 17,ssr_Qint
	move 13,1
	andi 13,777	; zero_extendqisi2
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sstr_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	addi 10,1
	lsh 10,33
	ash 10,-33
	move 1,[POINT 9,a_Qint,26]
	move 2,10
	pushj 17,spr_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,ls_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lv_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lst_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lsy_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lvs_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,la_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,11
	pushj 17,lai_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,11
	pushj 17,lvi_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_Qint,17]
	pushj 17,lp_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_Qint,8]
	move 2,11
	pushj 17,lpi_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgp_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgap_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgvp_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_Qint,8]
	pushj 17,prp_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_Qint,8]
	pushj 17,pip_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,12
	pushj 17,us_Qint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,12
	pushj 17,ust_Qint
	add 13,1
	move 1,13
	lsh 1,33
	ash 1,-33
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_sQint:
	.long	s_sQint+301989888
	.align	2
pa_sQint:
	.long	a_sQint+150994944
	.align	2
vps_sQint:
	.long	vs_sQint+301989888

ls_sQint:
	hrre 1,s_sQint
	popj 17,

ss_sQint:
	movem 1,s_sQint
	popj 17,

ssr_sQint:
	movem 1,s_sQint
	lsh 1,33
	ash 1,-33
	popj 17,

lv_sQint:
	hrre 1,vs_sQint
	popj 17,

sv_sQint:
	movem 1,vs_sQint
	popj 17,

lst_sQint:
	move 1,st_sQint
	ash 1,-33
	popj 17,

lsy_sQint:
	move 1,st_sQint
	lsh 1,11
	ash 1,-33
	popj 17,

sst_sQint:
	dpb 1,[POINT 9,st_sQint,8]
	popj 17,

sstr_sQint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,st_sQint,17]
	lsh 1,33
	ash 1,-33
	popj 17,

lvs_sQint:
	ldb 1,[POINT 9,vst_sQint,8]
	lsh 1,33
	ash 1,-33
	popj 17,

svs_sQint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vst_sQint,17]
	popj 17,

la_sQint:
	move 1,a_sQint
	ash 1,-33
	popj 17,

sa_sQint:
	dpb 1,[POINT 9,a_sQint,8]
	popj 17,

lai_sQint:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_sQint,8]
	jumpe 4,%L267
%L266:
	ibp 3
	sojn 4,%L266	; decrement_and_branch_until_zero
%L267:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

sai_sQint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_sQint,8]
	jumpe 4,%L270
%L269:
	ibp 3
	sojn 4,%L269	; decrement_and_branch_until_zero
%L270:
	dpb 2,3
	popj 17,

lvi_sQint:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,va_sQint,8]
	jumpe 4,%L273
%L272:
	ibp 1
	sojn 4,%L272	; decrement_and_branch_until_zero
%L273:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

svi_sQint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,va_sQint,8]
	jumpe 4,%L276
%L275:
	ibp 3
	sojn 4,%L275	; decrement_and_branch_until_zero
%L276:
	dpb 2,3
	popj 17,

lp_sQint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

sp_sQint:
	dpb 2,1
	popj 17,

spr_sQint:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

lpi_sQint:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L283
%L282:
	ibp 1
	sojn 4,%L282	; decrement_and_branch_until_zero
%L283:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

spi_sQint:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L287
%L286:
	ibp 1
	sojn 4,%L286	; decrement_and_branch_until_zero
%L287:
	dpb 3,1
	popj 17,

lgp_sQint:
	ldb 1,ps_sQint
	trne 1,400
	orcmi 1,777
	popj 17,

lgap_sQint:
	ldb 1,pa_sQint
	trne 1,400
	orcmi 1,777
	popj 17,

lgvp_sQint:
	ldb 1,vps_sQint
	trne 1,400
	orcmi 1,777
	popj 17,

sgp_sQint:
	dpb 1,ps_sQint
	popj 17,

prp_sQint:
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

pip_sQint:
	ldb 4,1
	ildb 1,1
	add 4,1
	lsh 4,33
	ash 4,-33
	move 1,4
	popj 17,

us_sQint:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,s_sQint,35]
	add 1,6
	movem 1,s_sQint
	lsh 1,33
	ash 1,-33
	popj 17,

ust_sQint:
	andi 1,777	; zero_extendqisi2
	ldb 4,[POINT 9,st_sQint,8]
	add 4,1
	dpb 4,[POINT 9,st_sQint,8]
	ldb 4,[POINT 9,st_sQint,17]
	sub 4,1
	dpb 4,[POINT 9,st_sQint,17]
	ldb 1,[POINT 9,st_sQint,8]
	ldb 4,[POINT 9,st_sQint,17]
	add 1,4
	lsh 1,33
	ash 1,-33
	popj 17,

use_sQint:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	andi 11,7
	move 12,10
	lsh 12,33
	ash 12,-33
	move 1,12
	pushj 17,ss_sQint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sv_sQint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sst_sQint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,svs_sQint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sa_sQint
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,11
	pushj 17,sai_sQint
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,11
	pushj 17,svi_sQint
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,[POINT 9,a_sQint,17]
	pushj 17,sp_sQint
	addi 10,1
	move 3,10
	lsh 3,33
	ash 3,-33
	move 1,[POINT 9,a_sQint,8]
	move 2,11
	pushj 17,spi_sQint
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sgp_sQint
	move 1,12
	pushj 17,ssr_sQint
	move 13,1
	andi 13,777	; zero_extendqisi2
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sstr_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	addi 10,1
	lsh 10,33
	ash 10,-33
	move 1,[POINT 9,a_sQint,26]
	move 2,10
	pushj 17,spr_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,ls_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lv_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lst_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lsy_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lvs_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,la_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,11
	pushj 17,lai_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,11
	pushj 17,lvi_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_sQint,17]
	pushj 17,lp_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_sQint,8]
	move 2,11
	pushj 17,lpi_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgp_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgap_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgvp_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_sQint,8]
	pushj 17,prp_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_sQint,8]
	pushj 17,pip_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,12
	pushj 17,us_sQint
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,12
	pushj 17,ust_sQint
	add 13,1
	move 1,13
	lsh 1,33
	ash 1,-33
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_uQint:
	.long	s_uQint+301989888
	.align	2
pa_uQint:
	.long	a_uQint+150994944
	.align	2
vps_uQint:
	.long	vs_uQint+301989888

ls_uQint:
	move 1,s_uQint
	popj 17,

ss_uQint:
	movem 1,s_uQint
	popj 17,

ssr_uQint:
	movem 1,s_uQint
	popj 17,

lv_uQint:
	move 1,vs_uQint
	popj 17,

sv_uQint:
	movem 1,vs_uQint
	popj 17,

lst_uQint:
	move 1,st_uQint
	lsh 1,-33
	popj 17,

lsy_uQint:
	ldb 1,[POINT 9,st_uQint,17]
	popj 17,

sst_uQint:
	dpb 1,[POINT 9,st_uQint,8]
	popj 17,

sstr_uQint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,st_uQint,17]
	andi 1,777	; zero_extendqisi2
	popj 17,

lvs_uQint:
	ldb 1,[POINT 9,vst_uQint,8]
	popj 17,

svs_uQint:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vst_uQint,17]
	popj 17,

la_uQint:
	move 1,a_uQint
	lsh 1,-33
	popj 17,

sa_uQint:
	dpb 1,[POINT 9,a_uQint,8]
	popj 17,

lai_uQint:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_uQint,8]
	jumpe 4,%L329
%L328:
	ibp 3
	sojn 4,%L328	; decrement_and_branch_until_zero
%L329:
	ldb 1,3
	popj 17,

sai_uQint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_uQint,8]
	jumpe 4,%L332
%L331:
	ibp 3
	sojn 4,%L331	; decrement_and_branch_until_zero
%L332:
	dpb 2,3
	popj 17,

lvi_uQint:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,va_uQint,8]
	jumpe 4,%L335
%L334:
	ibp 1
	sojn 4,%L334	; decrement_and_branch_until_zero
%L335:
	ldb 1,1
	popj 17,

svi_uQint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,va_uQint,8]
	jumpe 4,%L338
%L337:
	ibp 3
	sojn 4,%L337	; decrement_and_branch_until_zero
%L338:
	dpb 2,3
	popj 17,

lp_uQint:
	ldb 1,1
	popj 17,

sp_uQint:
	dpb 2,1
	popj 17,

spr_uQint:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	move 1,2
	popj 17,

lpi_uQint:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L345
%L344:
	ibp 1
	sojn 4,%L344	; decrement_and_branch_until_zero
%L345:
	ldb 1,1
	popj 17,

spi_uQint:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L349
%L348:
	ibp 1
	sojn 4,%L348	; decrement_and_branch_until_zero
%L349:
	dpb 3,1
	popj 17,

lgp_uQint:
	ldb 1,ps_uQint
	popj 17,

lgap_uQint:
	ldb 1,pa_uQint
	popj 17,

lgvp_uQint:
	ldb 1,vps_uQint
	popj 17,

sgp_uQint:
	dpb 1,ps_uQint
	popj 17,

prp_uQint:
	ildb 1,1
	popj 17,

pip_uQint:
	ldb 4,1
	ildb 1,1
	add 4,1
	andi 4,777	; zero_extendqisi2
	move 1,4
	popj 17,

us_uQint:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,s_uQint,35]
	add 1,6
	movem 1,s_uQint
	andi 1,777
	popj 17,

ust_uQint:
	andi 1,777	; zero_extendqisi2
	ldb 4,[POINT 9,st_uQint,8]
	add 4,1
	dpb 4,[POINT 9,st_uQint,8]
	ldb 4,[POINT 9,st_uQint,17]
	sub 4,1
	dpb 4,[POINT 9,st_uQint,17]
	ldb 1,[POINT 9,st_uQint,8]
	ldb 4,[POINT 9,st_uQint,17]
	add 1,4
	andi 1,777	; zero_extendqisi2
	popj 17,

use_uQint:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	andi 11,7
	move 1,10
	pushj 17,ss_uQint
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sv_uQint
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sst_uQint
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,svs_uQint
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sa_uQint
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,11
	pushj 17,sai_uQint
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,11
	pushj 17,svi_uQint
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,[POINT 9,a_uQint,17]
	pushj 17,sp_uQint
	addi 10,1
	move 3,10
	andi 3,777	; zero_extendqisi2
	move 1,[POINT 9,a_uQint,8]
	move 2,11
	pushj 17,spi_uQint
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	subi 10,11
	pushj 17,sgp_uQint
	move 1,10
	pushj 17,ssr_uQint
	move 12,1
	andi 12,777	; zero_extendqisi2
	addi 10,12
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sstr_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	subi 10,13
	move 1,[POINT 9,a_uQint,26]
	pushj 17,spr_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,ls_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lv_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lst_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lsy_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lvs_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,la_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,11
	pushj 17,lai_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,11
	pushj 17,lvi_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_uQint,17]
	pushj 17,lp_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_uQint,8]
	move 2,11
	pushj 17,lpi_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgp_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgap_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgvp_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_uQint,8]
	pushj 17,prp_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_uQint,8]
	pushj 17,pip_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,10
	pushj 17,us_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,10
	pushj 17,ust_uQint
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_Hint:
	.long	s_Hint+301989888
	.align	2
pa_Hint:
	.long	a_Hint+301989889
	.align	2
vps_Hint:
	.long	vs_Hint+301989888

ls_Hint:
	hrre 1,s_Hint
	popj 17,

ss_Hint:
	movem 1,s_Hint
	popj 17,

ssr_Hint:
	movem 1,s_Hint
	hrre 1,1
	popj 17,

lv_Hint:
	hrre 1,vs_Hint
	popj 17,

sv_Hint:
	movem 1,vs_Hint
	popj 17,

lst_Hint:
	hlre 1,st_Hint
	popj 17,

lsy_Hint:
	hrre 1,st_Hint
	popj 17,

sst_Hint:
	hrlm 1,st_Hint
	popj 17,

sstr_Hint:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,st_Hint
	hrre 1,1	; extendhisi2
	popj 17,

lvs_Hint:
	hlrz 1,vst_Hint
	hrre 1,1
	popj 17,

svs_Hint:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,vst_Hint
	popj 17,

la_Hint:
	hlre 1,a_Hint
	popj 17,

sa_Hint:
	hrlm 1,a_Hint
	popj 17,

lai_Hint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_Hint,17]
	jumpe 4,%L391
%L390:
	ibp 3
	sojn 4,%L390	; decrement_and_branch_until_zero
%L391:
	ldb 1,3
	hrre 1,1
	popj 17,

sai_Hint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_Hint,17]
	jumpe 4,%L394
%L393:
	ibp 3
	sojn 4,%L393	; decrement_and_branch_until_zero
%L394:
	dpb 2,3	; movhi
	popj 17,

lvi_Hint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,va_Hint,17]
	jumpe 4,%L397
%L396:
	ibp 3
	sojn 4,%L396	; decrement_and_branch_until_zero
%L397:
	ldb 1,3
	hrre 1,1
	popj 17,

svi_Hint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,va_Hint,17]
	jumpe 4,%L400
%L399:
	ibp 3
	sojn 4,%L399	; decrement_and_branch_until_zero
%L400:
	dpb 2,3	; movhi
	popj 17,

lp_Hint:
	ldb 1,1
	hrre 1,1
	popj 17,

sp_Hint:
	dpb 2,1	; movhi
	popj 17,

spr_Hint:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	hrre 2,2
	move 1,2
	popj 17,

lpi_Hint:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L407
%L406:
	ibp 1
	sojn 4,%L406	; decrement_and_branch_until_zero
%L407:
	ldb 1,1
	hrre 1,1
	popj 17,

spi_Hint:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L411
%L410:
	ibp 1
	sojn 4,%L410	; decrement_and_branch_until_zero
%L411:
	dpb 3,1	; movhi
	popj 17,

lgp_Hint:
	ldb 1,ps_Hint
	hrre 1,1
	popj 17,

lgap_Hint:
	ldb 1,pa_Hint
	hrre 1,1
	popj 17,

lgvp_Hint:
	ldb 1,vps_Hint
	hrre 1,1
	popj 17,

sgp_Hint:
	dpb 1,ps_Hint	; movhi
	popj 17,

prp_Hint:
	ibp 1
	ldb 1,1
	hrre 1,1
	popj 17,

pip_Hint:
	ldb 4,1
	ibp 1
	ldb 1,1
	add 4,1
	hrre 4,4	; extendhisi2
	move 1,4
	popj 17,

us_Hint:
	hlrz 6,s_Hint
	addi 6,(1)
	movem 6,s_Hint
	hrre 1,6
	popj 17,

ust_Hint:
	hrrzi 1,(1)	; zero_extendhisi2
	hlrz 4,st_Hint
	add 4,1
	hrlm 4,st_Hint
	hrrz 4,st_Hint
	sub 4,1
	hrrm 4,st_Hint
	hlrz 1,st_Hint
	hrrz 4,st_Hint
	add 1,4
	hrre 1,1	; extendhisi2
	popj 17,

use_Hint:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	hrrzi 10,(10)	; zero_extendhisi2
	andi 11,7
	hrre 12,10	; extendhisi2
	move 1,12
	pushj 17,ss_Hint
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sv_Hint
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sst_Hint
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,svs_Hint
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sa_Hint
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,11
	pushj 17,sai_Hint
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,11
	pushj 17,svi_Hint
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,[POINT 18,a_Hint,35]
	pushj 17,sp_Hint
	addi 10,1
	hrre 3,10	; extendhisi2
	move 1,[POINT 18,a_Hint,17]
	move 2,11
	pushj 17,spi_Hint
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sgp_Hint
	move 1,12
	pushj 17,ssr_Hint
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sstr_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	addi 10,1
	hrre 10,10	; extendhisi2
	move 1,[POINT 18,a_Hint+1,17]
	move 2,10
	pushj 17,spr_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,ls_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lv_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lst_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lsy_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lvs_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,la_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,11
	pushj 17,lai_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,11
	pushj 17,lvi_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,[POINT 18,a_Hint,35]
	pushj 17,lp_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,[POINT 18,a_Hint,17]
	move 2,11
	pushj 17,lpi_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lgp_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lgap_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lgvp_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,[POINT 18,a_Hint,17]
	pushj 17,prp_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,[POINT 18,a_Hint,17]
	pushj 17,pip_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,12
	pushj 17,us_Hint
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,12
	pushj 17,ust_Hint
	add 13,1
	hrre 1,13
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_uHint:
	.long	s_uHint+301989888
	.align	2
pa_uHint:
	.long	a_uHint+301989889
	.align	2
vps_uHint:
	.long	vs_uHint+301989888

ls_uHint:
	move 1,s_uHint
	popj 17,

ss_uHint:
	movem 1,s_uHint
	popj 17,

ssr_uHint:
	movem 1,s_uHint
	popj 17,

lv_uHint:
	move 1,vs_uHint
	popj 17,

sv_uHint:
	movem 1,vs_uHint
	popj 17,

lst_uHint:
	hlrz 1,st_uHint
	popj 17,

lsy_uHint:
	hrrz 1,st_uHint
	popj 17,

sst_uHint:
	hrlm 1,st_uHint
	popj 17,

sstr_uHint:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,st_uHint
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

lvs_uHint:
	hlrz 1,vst_uHint
	popj 17,

svs_uHint:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,vst_uHint
	popj 17,

la_uHint:
	hlrz 1,a_uHint
	popj 17,

sa_uHint:
	hrlm 1,a_uHint
	popj 17,

lai_uHint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_uHint,17]
	jumpe 4,%L453
%L452:
	ibp 3
	sojn 4,%L452	; decrement_and_branch_until_zero
%L453:
	ldb 1,3
	popj 17,

sai_uHint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_uHint,17]
	jumpe 4,%L456
%L455:
	ibp 3
	sojn 4,%L455	; decrement_and_branch_until_zero
%L456:
	dpb 2,3	; movhi
	popj 17,

lvi_uHint:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,va_uHint,17]
	jumpe 4,%L459
%L458:
	ibp 1
	sojn 4,%L458	; decrement_and_branch_until_zero
%L459:
	ldb 1,1
	popj 17,

svi_uHint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,va_uHint,17]
	jumpe 4,%L462
%L461:
	ibp 3
	sojn 4,%L461	; decrement_and_branch_until_zero
%L462:
	dpb 2,3	; movhi
	popj 17,

lp_uHint:
	ldb 1,1
	popj 17,

sp_uHint:
	dpb 2,1	; movhi
	popj 17,

spr_uHint:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	move 1,2
	popj 17,

lpi_uHint:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L469
%L468:
	ibp 1
	sojn 4,%L468	; decrement_and_branch_until_zero
%L469:
	ldb 1,1
	popj 17,

spi_uHint:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L473
%L472:
	ibp 1
	sojn 4,%L472	; decrement_and_branch_until_zero
%L473:
	dpb 3,1	; movhi
	popj 17,

lgp_uHint:
	ldb 1,ps_uHint
	popj 17,

lgap_uHint:
	ldb 1,pa_uHint
	popj 17,

lgvp_uHint:
	ldb 1,vps_uHint
	popj 17,

sgp_uHint:
	dpb 1,ps_uHint	; movhi
	popj 17,

prp_uHint:
	ibp 1
	ldb 1,1
	popj 17,

pip_uHint:
	ldb 4,1
	ibp 1
	ldb 1,1
	add 4,1
	hrrzi 4,(4)	; zero_extendhisi2
	move 1,4
	popj 17,

us_uHint:
	hlrz 6,s_uHint
	addi 6,(1)
	movem 6,s_uHint
	hrrz 1,6
	popj 17,

ust_uHint:
	hrrzi 1,(1)	; zero_extendhisi2
	hlrz 4,st_uHint
	add 4,1
	hrlm 4,st_uHint
	hrrz 4,st_uHint
	sub 4,1
	hrrm 4,st_uHint
	hlrz 1,st_uHint
	hrrz 4,st_uHint
	add 1,4
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

use_uHint:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	hrrzi 10,(10)	; zero_extendhisi2
	andi 11,7
	move 1,10
	pushj 17,ss_uHint
	movei 1,1(10)
	pushj 17,sv_uHint
	movei 1,2(10)
	pushj 17,sst_uHint
	movei 1,3(10)
	pushj 17,svs_uHint
	movei 1,4(10)
	pushj 17,sa_uHint
	movei 2,5(10)
	move 1,11
	pushj 17,sai_uHint
	movei 2,6(10)
	move 1,11
	pushj 17,svi_uHint
	movei 2,7(10)
	move 1,[POINT 18,a_uHint,35]
	pushj 17,sp_uHint
	movei 3,10(10)
	move 1,[POINT 18,a_uHint,17]
	move 2,11
	pushj 17,spi_uHint
	movei 1,11(10)
	pushj 17,sgp_uHint
	move 1,10
	pushj 17,ssr_uHint
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	movei 1,12(10)
	pushj 17,sstr_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	movei 2,13(10)
	move 1,[POINT 18,a_uHint+1,17]
	pushj 17,spr_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,ls_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lv_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lst_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lsy_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lvs_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,la_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,11
	pushj 17,lai_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,11
	pushj 17,lvi_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,[POINT 18,a_uHint,35]
	pushj 17,lp_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,[POINT 18,a_uHint,17]
	move 2,11
	pushj 17,lpi_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lgp_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lgap_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lgvp_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,[POINT 18,a_uHint,17]
	pushj 17,prp_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,[POINT 18,a_uHint,17]
	pushj 17,pip_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,10
	pushj 17,us_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,10
	pushj 17,ust_uHint
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_Sint:
	.long	s_Sint
	.align	2
pa_Sint:
	.long	a_Sint+3
	.align	2
vps_Sint:
	.long	vs_Sint

ls_Sint:
	move 1,s_Sint
	popj 17,

ss_Sint:
	movem 1,s_Sint
	popj 17,

ssr_Sint:
	movem 1,s_Sint
	popj 17,

lv_Sint:
	move 1,vs_Sint
	popj 17,

sv_Sint:
	movem 1,vs_Sint
	popj 17,

lst_Sint:
	move 1,st_Sint
	popj 17,

lsy_Sint:
	move 1,st_Sint+1
	popj 17,

sst_Sint:
	movem 1,st_Sint
	popj 17,

sstr_Sint:
	movem 1,st_Sint+1
	popj 17,

lvs_Sint:
	move 1,vst_Sint
	popj 17,

svs_Sint:
	movem 1,vst_Sint+1
	popj 17,

la_Sint:
	move 1,a_Sint
	popj 17,

sa_Sint:
	movem 1,a_Sint
	popj 17,

lai_Sint:
	move 1,a_Sint(1)
	popj 17,

sai_Sint:
	movem 2,a_Sint(1)
	popj 17,

lvi_Sint:
	move 1,va_Sint(1)
	popj 17,

svi_Sint:
	movem 2,va_Sint(1)
	popj 17,

lp_Sint:
	move 1,(1)
	popj 17,

sp_Sint:
	movem 2,(1)
	popj 17,

spr_Sint:
	movem 2,(1)
	move 1,2
	popj 17,

lpi_Sint:
	add 1,2
	move 1,(1)
	popj 17,

spi_Sint:
	add 1,2
	movem 3,(1)
	popj 17,

lgp_Sint:
	move 4,ps_Sint
	move 1,(4)
	popj 17,

lgap_Sint:
	move 4,pa_Sint
	move 1,(4)
	popj 17,

lgvp_Sint:
	move 4,vps_Sint
	move 1,(4)
	popj 17,

sgp_Sint:
	move 4,ps_Sint
	movem 1,(4)
	popj 17,

prp_Sint:
	move 1,1(1)
	popj 17,

pip_Sint:
	move 6,(1)
	add 6,1(1)
	move 1,6
	popj 17,

us_Sint:
	addb 1,s_Sint
	popj 17,

ust_Sint:
	move 3,1
	addb 3,st_Sint
	move 4,st_Sint+1
	sub 4,1
	movem 4,st_Sint+1
	add 3,4
	move 1,3
	popj 17,

use_Sint:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	andi 12,7
	pushj 17,ss_Sint
	move 1,11
	addi 1,1
	pushj 17,sv_Sint
	move 1,11
	addi 1,2
	pushj 17,sst_Sint
	move 1,11
	addi 1,3
	pushj 17,svs_Sint
	move 1,11
	addi 1,4
	pushj 17,sa_Sint
	move 2,11
	addi 2,5
	move 1,12
	pushj 17,sai_Sint
	move 2,11
	addi 2,6
	move 1,12
	pushj 17,svi_Sint
	move 2,11
	addi 2,7
	movei 1,a_Sint+1
	pushj 17,sp_Sint
	move 3,11
	addi 3,10
	movei 1,a_Sint
	move 2,12
	pushj 17,spi_Sint
	move 1,11
	addi 1,11
	pushj 17,sgp_Sint
	move 1,11
	pushj 17,ssr_Sint
	move 10,1
	move 1,11
	addi 1,12
	pushj 17,sstr_Sint
	add 10,1
	move 2,11
	addi 2,13
	movei 1,a_Sint+2
	pushj 17,spr_Sint
	add 10,1
	pushj 17,ls_Sint
	add 10,1
	pushj 17,lv_Sint
	add 10,1
	pushj 17,lst_Sint
	add 10,1
	pushj 17,lsy_Sint
	add 10,1
	pushj 17,lvs_Sint
	add 10,1
	pushj 17,la_Sint
	add 10,1
	move 1,12
	pushj 17,lai_Sint
	add 10,1
	move 1,12
	pushj 17,lvi_Sint
	add 10,1
	movei 1,a_Sint+1
	pushj 17,lp_Sint
	add 10,1
	movei 1,a_Sint
	move 2,12
	pushj 17,lpi_Sint
	add 10,1
	pushj 17,lgp_Sint
	add 10,1
	pushj 17,lgap_Sint
	add 10,1
	pushj 17,lgvp_Sint
	add 10,1
	movei 1,a_Sint
	pushj 17,prp_Sint
	add 10,1
	movei 1,a_Sint
	pushj 17,pip_Sint
	add 10,1
	move 1,11
	pushj 17,us_Sint
	add 10,1
	move 1,11
	pushj 17,ust_Sint
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_uSint:
	.long	s_uSint
	.align	2
pa_uSint:
	.long	a_uSint+3
	.align	2
vps_uSint:
	.long	vs_uSint

ls_uSint:
	move 1,s_uSint
	popj 17,

ss_uSint:
	movem 1,s_uSint
	popj 17,

ssr_uSint:
	movem 1,s_uSint
	popj 17,

lv_uSint:
	move 1,vs_uSint
	popj 17,

sv_uSint:
	movem 1,vs_uSint
	popj 17,

lst_uSint:
	move 1,st_uSint
	popj 17,

lsy_uSint:
	move 1,st_uSint+1
	popj 17,

sst_uSint:
	movem 1,st_uSint
	popj 17,

sstr_uSint:
	movem 1,st_uSint+1
	popj 17,

lvs_uSint:
	move 1,vst_uSint
	popj 17,

svs_uSint:
	movem 1,vst_uSint+1
	popj 17,

la_uSint:
	move 1,a_uSint
	popj 17,

sa_uSint:
	movem 1,a_uSint
	popj 17,

lai_uSint:
	move 1,a_uSint(1)
	popj 17,

sai_uSint:
	movem 2,a_uSint(1)
	popj 17,

lvi_uSint:
	move 1,va_uSint(1)
	popj 17,

svi_uSint:
	movem 2,va_uSint(1)
	popj 17,

lp_uSint:
	move 1,(1)
	popj 17,

sp_uSint:
	movem 2,(1)
	popj 17,

spr_uSint:
	movem 2,(1)
	move 1,2
	popj 17,

lpi_uSint:
	add 1,2
	move 1,(1)
	popj 17,

spi_uSint:
	add 1,2
	movem 3,(1)
	popj 17,

lgp_uSint:
	move 4,ps_uSint
	move 1,(4)
	popj 17,

lgap_uSint:
	move 4,pa_uSint
	move 1,(4)
	popj 17,

lgvp_uSint:
	move 4,vps_uSint
	move 1,(4)
	popj 17,

sgp_uSint:
	move 4,ps_uSint
	movem 1,(4)
	popj 17,

prp_uSint:
	move 1,1(1)
	popj 17,

pip_uSint:
	move 6,(1)
	add 6,1(1)
	move 1,6
	popj 17,

us_uSint:
	addb 1,s_uSint
	popj 17,

ust_uSint:
	move 3,1
	addb 3,st_uSint
	move 4,st_uSint+1
	sub 4,1
	movem 4,st_uSint+1
	add 3,4
	move 1,3
	popj 17,

use_uSint:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	andi 12,7
	pushj 17,ss_uSint
	move 1,11
	addi 1,1
	pushj 17,sv_uSint
	move 1,11
	addi 1,2
	pushj 17,sst_uSint
	move 1,11
	addi 1,3
	pushj 17,svs_uSint
	move 1,11
	addi 1,4
	pushj 17,sa_uSint
	move 2,11
	addi 2,5
	move 1,12
	pushj 17,sai_uSint
	move 2,11
	addi 2,6
	move 1,12
	pushj 17,svi_uSint
	move 2,11
	addi 2,7
	movei 1,a_uSint+1
	pushj 17,sp_uSint
	move 3,11
	addi 3,10
	movei 1,a_uSint
	move 2,12
	pushj 17,spi_uSint
	move 1,11
	addi 1,11
	pushj 17,sgp_uSint
	move 1,11
	pushj 17,ssr_uSint
	move 10,1
	move 1,11
	addi 1,12
	pushj 17,sstr_uSint
	add 10,1
	move 2,11
	addi 2,13
	movei 1,a_uSint+2
	pushj 17,spr_uSint
	add 10,1
	pushj 17,ls_uSint
	add 10,1
	pushj 17,lv_uSint
	add 10,1
	pushj 17,lst_uSint
	add 10,1
	pushj 17,lsy_uSint
	add 10,1
	pushj 17,lvs_uSint
	add 10,1
	pushj 17,la_uSint
	add 10,1
	move 1,12
	pushj 17,lai_uSint
	add 10,1
	move 1,12
	pushj 17,lvi_uSint
	add 10,1
	movei 1,a_uSint+1
	pushj 17,lp_uSint
	add 10,1
	movei 1,a_uSint
	move 2,12
	pushj 17,lpi_uSint
	add 10,1
	pushj 17,lgp_uSint
	add 10,1
	pushj 17,lgap_uSint
	add 10,1
	pushj 17,lgvp_uSint
	add 10,1
	movei 1,a_uSint
	pushj 17,prp_uSint
	add 10,1
	movei 1,a_uSint
	pushj 17,pip_uSint
	add 10,1
	move 1,11
	pushj 17,us_uSint
	add 10,1
	move 1,11
	pushj 17,ust_uSint
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_char6:
	.long	s_char6+301989888
	.align	2
pa_char6:
	.long	a_char6+12985565184
	.align	2
vps_char6:
	.long	vs_char6+301989888

ls_char6:
	hrre 1,s_char6
	popj 17,

ss_char6:
	movem 1,s_char6
	popj 17,

ssr_char6:
	lsh 1,36
	ash 1,-36
	movem 1,s_char6
	lsh 1,36
	ash 1,-36
	popj 17,

lv_char6:
	ldb 1,[POINT 18,vs_char6,35]
	trne 1,40
	orcmi 1,77
	popj 17,

sv_char6:
	lsh 1,36
	ash 1,-36
	movem 1,vs_char6
	popj 17,

lst_char6:
	move 1,st_char6
	ash 1,-36
	popj 17,

lsy_char6:
	move 1,st_char6
	lsh 1,6
	ash 1,-36
	popj 17,

sst_char6:
	lsh 1,36
	ash 1,-36
	dpb 1,[POINT 6,st_char6,5]
	popj 17,

sstr_char6:
	lsh 1,36
	ash 1,-36
	dpb 1,[POINT 6,st_char6,11]
	lsh 1,36
	ash 1,-36
	popj 17,

lvs_char6:
	move 1,vst_char6
	ash 1,-36
	popj 17,

svs_char6:
	lsh 1,36
	ash 1,-36
	dpb 1,[POINT 6,vst_char6,11]
	popj 17,

la_char6:
	move 1,a_char6
	ash 1,-36
	popj 17,

sa_char6:
	lsh 1,36
	ash 1,-36
	dpb 1,[POINT 6,a_char6,5]
	popj 17,

lai_char6:
	move 4,[POINT 6,a_char6,5]
	jumple 1,%L615
%L614:
	ibp 4
	sojg 1,%L614	; decrement_and_branch_until_zero
%L615:
	jumpe 1,%L617
%L616:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L616
%L617:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

sai_char6:
	lsh 2,36
	ash 2,-36
	move 4,[POINT 6,a_char6,5]
	jumple 1,%L620
%L619:
	ibp 4
	sojg 1,%L619	; decrement_and_branch_until_zero
%L620:
	jumpe 1,%L622
%L621:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L621
%L622:
	dpb 2,4
	popj 17,

lvi_char6:
	move 4,[POINT 6,va_char6,5]
	jumple 1,%L625
%L624:
	ibp 4
	sojg 1,%L624	; decrement_and_branch_until_zero
%L625:
	jumpe 1,%L627
%L626:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L626
%L627:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

svi_char6:
	lsh 2,36
	ash 2,-36
	move 4,[POINT 6,va_char6,5]
	jumple 1,%L630
%L629:
	ibp 4
	sojg 1,%L629	; decrement_and_branch_until_zero
%L630:
	jumpe 1,%L632
%L631:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L631
%L632:
	dpb 2,4
	popj 17,

lp_char6:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

sp_char6:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

spr_char6:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	lsh 2,36
	ash 2,-36
	move 1,2
	popj 17,

lpi_char6:
	jumple 2,%L639
%L638:
	ibp 1
	sojg 2,%L638	; decrement_and_branch_until_zero
%L639:
	jumpe 2,%L641
%L640:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L640
%L641:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

spi_char6:
	lsh 3,36
	ash 3,-36
	jumple 2,%L645
%L644:
	ibp 1
	sojg 2,%L644	; decrement_and_branch_until_zero
%L645:
	jumpe 2,%L647
%L646:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L646
%L647:
	dpb 3,1
	popj 17,

lgp_char6:
	ldb 1,ps_char6
	trne 1,40
	orcmi 1,77
	popj 17,

lgap_char6:
	ldb 1,pa_char6
	trne 1,40
	orcmi 1,77
	popj 17,

lgvp_char6:
	ldb 1,vps_char6
	trne 1,40
	orcmi 1,77
	popj 17,

sgp_char6:
	lsh 1,36
	ash 1,-36
	dpb 1,ps_char6
	popj 17,

prp_char6:
	ildb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

pip_char6:
	ldb 4,1
	trne 4,40
	orcmi 4,77
	ildb 1,1
	add 4,1
	lsh 4,36
	ash 4,-36
	move 1,4
	popj 17,

us_char6:
	lsh 1,36
	ash 1,-36
	ldb 6,[POINT 18,s_char6,35]
	add 1,6
	movem 1,s_char6
	lsh 1,36
	ash 1,-36
	popj 17,

ust_char6:
	lsh 1,36
	ash 1,-36
	move 4,st_char6
	ash 4,-36
	add 4,1
	dpb 4,[POINT 6,st_char6,5]
	move 4,st_char6
	lsh 4,6
	ash 4,-36
	sub 4,1
	dpb 4,[POINT 6,st_char6,11]
	move 1,st_char6
	ash 1,-36
	move 4,st_char6
	lsh 4,6
	ash 4,-36
	add 1,4
	lsh 1,36
	ash 1,-36
	popj 17,

use_char6:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	lsh 11,36
	ash 11,-36
	andi 12,7
	move 13,11
	lsh 13,36
	ash 13,-36
	move 1,13
	pushj 17,ss_char6
	move 1,11
	addi 1,1
	lsh 1,36
	ash 1,-36
	pushj 17,sv_char6
	move 1,11
	addi 1,2
	lsh 1,36
	ash 1,-36
	pushj 17,sst_char6
	move 1,11
	addi 1,3
	lsh 1,36
	ash 1,-36
	pushj 17,svs_char6
	move 1,11
	addi 1,4
	lsh 1,36
	ash 1,-36
	pushj 17,sa_char6
	move 2,11
	addi 2,5
	lsh 2,36
	ash 2,-36
	move 1,12
	pushj 17,sai_char6
	move 2,11
	addi 2,6
	lsh 2,36
	ash 2,-36
	move 1,12
	pushj 17,svi_char6
	move 2,11
	addi 2,7
	lsh 2,36
	ash 2,-36
	move 1,[POINT 6,a_char6,11]
	pushj 17,sp_char6
	move 3,11
	addi 3,10
	lsh 3,36
	ash 3,-36
	move 1,[POINT 6,a_char6,5]
	move 2,12
	pushj 17,spi_char6
	move 1,11
	addi 1,11
	lsh 1,36
	ash 1,-36
	pushj 17,sgp_char6
	move 1,13
	pushj 17,ssr_char6
	move 10,1
	lsh 10,36
	ash 10,-36
	move 1,11
	addi 1,12
	lsh 1,36
	ash 1,-36
	pushj 17,sstr_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	addi 11,13
	lsh 11,36
	ash 11,-36
	move 1,[POINT 6,a_char6,17]
	move 2,11
	pushj 17,spr_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	pushj 17,ls_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	pushj 17,lv_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	pushj 17,lst_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	pushj 17,lsy_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	pushj 17,lvs_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	pushj 17,la_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	move 1,12
	pushj 17,lai_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	move 1,12
	pushj 17,lvi_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	move 1,[POINT 6,a_char6,11]
	pushj 17,lp_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	move 1,[POINT 6,a_char6,5]
	move 2,12
	pushj 17,lpi_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	pushj 17,lgp_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	pushj 17,lgap_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	pushj 17,lgvp_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	move 1,[POINT 6,a_char6,5]
	pushj 17,prp_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	move 1,[POINT 6,a_char6,5]
	pushj 17,pip_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	move 1,13
	pushj 17,us_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	move 1,13
	pushj 17,ust_char6
	add 10,1
	lsh 10,36
	ash 10,-36
	lsh 10,36
	ash 10,-36
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_uchar6:
	.long	s_uchar6+301989888
	.align	2
pa_uchar6:
	.long	a_uchar6+12985565184
	.align	2
vps_uchar6:
	.long	vs_uchar6+301989888

ls_uchar6:
	move 1,s_uchar6
	popj 17,

ss_uchar6:
	movem 1,s_uchar6
	popj 17,

ssr_uchar6:
	andi 1,77
	movem 1,s_uchar6
	andi 1,77
	popj 17,

lv_uchar6:
	ldb 1,[POINT 18,vs_uchar6,35]
	popj 17,

sv_uchar6:
	andi 1,77
	movem 1,vs_uchar6
	popj 17,

lst_uchar6:
	move 1,st_uchar6
	lsh 1,-36
	popj 17,

lsy_uchar6:
	ldb 1,[POINT 6,st_uchar6,11]
	popj 17,

sst_uchar6:
	andi 1,77
	dpb 1,[POINT 6,st_uchar6,5]
	popj 17,

sstr_uchar6:
	andi 1,77
	dpb 1,[POINT 6,st_uchar6,11]
	andi 1,77
	popj 17,

lvs_uchar6:
	move 1,vst_uchar6
	lsh 1,-36
	popj 17,

svs_uchar6:
	andi 1,77
	dpb 1,[POINT 6,vst_uchar6,11]
	popj 17,

la_uchar6:
	move 1,a_uchar6
	lsh 1,-36
	popj 17,

sa_uchar6:
	andi 1,77
	dpb 1,[POINT 6,a_uchar6,5]
	popj 17,

lai_uchar6:
	move 4,[POINT 6,a_uchar6,5]
	jumple 1,%L689
%L688:
	ibp 4
	sojg 1,%L688	; decrement_and_branch_until_zero
%L689:
	jumpe 1,%L691
%L690:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L690
%L691:
	ldb 1,4
	popj 17,

sai_uchar6:
	andi 2,77
	move 4,[POINT 6,a_uchar6,5]
	jumple 1,%L694
%L693:
	ibp 4
	sojg 1,%L693	; decrement_and_branch_until_zero
%L694:
	jumpe 1,%L696
%L695:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L695
%L696:
	dpb 2,4
	popj 17,

lvi_uchar6:
	move 4,[POINT 6,va_uchar6,5]
	jumple 1,%L699
%L698:
	ibp 4
	sojg 1,%L698	; decrement_and_branch_until_zero
%L699:
	jumpe 1,%L701
%L700:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L700
%L701:
	ldb 1,4
	popj 17,

svi_uchar6:
	andi 2,77
	move 4,[POINT 6,va_uchar6,5]
	jumple 1,%L704
%L703:
	ibp 4
	sojg 1,%L703	; decrement_and_branch_until_zero
%L704:
	jumpe 1,%L706
%L705:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L705
%L706:
	dpb 2,4
	popj 17,

lp_uchar6:
	ldb 1,1
	popj 17,

sp_uchar6:
	andi 2,77
	dpb 2,1
	popj 17,

spr_uchar6:
	andi 2,77
	dpb 2,1
	andi 2,77
	move 1,2
	popj 17,

lpi_uchar6:
	jumple 2,%L713
%L712:
	ibp 1
	sojg 2,%L712	; decrement_and_branch_until_zero
%L713:
	jumpe 2,%L715
%L714:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L714
%L715:
	ldb 1,1
	popj 17,

spi_uchar6:
	andi 3,77
	jumple 2,%L719
%L718:
	ibp 1
	sojg 2,%L718	; decrement_and_branch_until_zero
%L719:
	jumpe 2,%L721
%L720:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L720
%L721:
	dpb 3,1
	popj 17,

lgp_uchar6:
	ldb 1,ps_uchar6
	popj 17,

lgap_uchar6:
	ldb 1,pa_uchar6
	popj 17,

lgvp_uchar6:
	ldb 1,vps_uchar6
	popj 17,

sgp_uchar6:
	andi 1,77
	dpb 1,ps_uchar6
	popj 17,

prp_uchar6:
	ildb 1,1
	popj 17,

pip_uchar6:
	ldb 4,1
	ildb 1,1
	add 4,1
	andi 4,77
	move 1,4
	popj 17,

us_uchar6:
	andi 1,77
	ldb 6,[POINT 18,s_uchar6,35]
	add 1,6
	movem 1,s_uchar6
	andi 1,77
	popj 17,

ust_uchar6:
	andi 1,77
	move 4,st_uchar6
	lsh 4,-36
	add 4,1
	dpb 4,[POINT 6,st_uchar6,5]
	ldb 4,[POINT 6,st_uchar6,11]
	sub 4,1
	dpb 4,[POINT 6,st_uchar6,11]
	move 1,st_uchar6
	lsh 1,-36
	ldb 4,[POINT 6,st_uchar6,11]
	add 1,4
	andi 1,77
	popj 17,

use_uchar6:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	andi 11,77
	andi 12,7
	move 13,11
	andi 13,77
	move 1,13
	pushj 17,ss_uchar6
	move 1,11
	addi 1,1
	andi 1,77
	pushj 17,sv_uchar6
	move 1,11
	addi 1,2
	andi 1,77
	pushj 17,sst_uchar6
	move 1,11
	addi 1,3
	andi 1,77
	pushj 17,svs_uchar6
	move 1,11
	addi 1,4
	andi 1,77
	pushj 17,sa_uchar6
	move 2,11
	addi 2,5
	andi 2,77
	move 1,12
	pushj 17,sai_uchar6
	move 2,11
	addi 2,6
	andi 2,77
	move 1,12
	pushj 17,svi_uchar6
	move 2,11
	addi 2,7
	andi 2,77
	move 1,[POINT 6,a_uchar6,11]
	pushj 17,sp_uchar6
	move 3,11
	addi 3,10
	andi 3,77
	move 1,[POINT 6,a_uchar6,5]
	move 2,12
	pushj 17,spi_uchar6
	move 1,11
	addi 1,11
	andi 1,77
	pushj 17,sgp_uchar6
	move 1,13
	pushj 17,ssr_uchar6
	move 10,1
	andi 10,77
	move 1,11
	addi 1,12
	andi 1,77
	pushj 17,sstr_uchar6
	add 10,1
	andi 10,77
	addi 11,13
	andi 11,77
	move 1,[POINT 6,a_uchar6,17]
	move 2,11
	pushj 17,spr_uchar6
	add 10,1
	andi 10,77
	pushj 17,ls_uchar6
	add 10,1
	andi 10,77
	pushj 17,lv_uchar6
	add 10,1
	andi 10,77
	pushj 17,lst_uchar6
	add 10,1
	andi 10,77
	pushj 17,lsy_uchar6
	add 10,1
	andi 10,77
	pushj 17,lvs_uchar6
	add 10,1
	andi 10,77
	pushj 17,la_uchar6
	add 10,1
	andi 10,77
	move 1,12
	pushj 17,lai_uchar6
	add 10,1
	andi 10,77
	move 1,12
	pushj 17,lvi_uchar6
	add 10,1
	andi 10,77
	move 1,[POINT 6,a_uchar6,11]
	pushj 17,lp_uchar6
	add 10,1
	andi 10,77
	move 1,[POINT 6,a_uchar6,5]
	move 2,12
	pushj 17,lpi_uchar6
	add 10,1
	andi 10,77
	pushj 17,lgp_uchar6
	add 10,1
	andi 10,77
	pushj 17,lgap_uchar6
	add 10,1
	andi 10,77
	pushj 17,lgvp_uchar6
	add 10,1
	andi 10,77
	move 1,[POINT 6,a_uchar6,5]
	pushj 17,prp_uchar6
	add 10,1
	andi 10,77
	move 1,[POINT 6,a_uchar6,5]
	pushj 17,pip_uchar6
	add 10,1
	andi 10,77
	move 1,13
	pushj 17,us_uchar6
	add 10,1
	andi 10,77
	move 1,13
	pushj 17,ust_uchar6
	add 10,1
	andi 10,77
	andi 10,77
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_char7:
	.long	s_char7+301989888
	.align	2
pa_char7:
	.long	a_char7+8707375104
	.align	2
vps_char7:
	.long	vs_char7+301989888

ls_char7:
	hrre 1,s_char7
	popj 17,

ss_char7:
	movem 1,s_char7
	popj 17,

ssr_char7:
	lsh 1,35
	ash 1,-35
	movem 1,s_char7
	lsh 1,35
	ash 1,-35
	popj 17,

lv_char7:
	ldb 1,[POINT 18,vs_char7,35]
	trne 1,100
	orcmi 1,177
	popj 17,

sv_char7:
	lsh 1,35
	ash 1,-35
	movem 1,vs_char7
	popj 17,

lst_char7:
	move 1,st_char7
	ash 1,-35
	popj 17,

lsy_char7:
	move 1,st_char7
	lsh 1,7
	ash 1,-35
	popj 17,

sst_char7:
	lsh 1,35
	ash 1,-35
	dpb 1,[POINT 7,st_char7,6]
	popj 17,

sstr_char7:
	lsh 1,35
	ash 1,-35
	dpb 1,[POINT 7,st_char7,13]
	lsh 1,35
	ash 1,-35
	popj 17,

lvs_char7:
	move 1,vst_char7
	ash 1,-35
	popj 17,

svs_char7:
	lsh 1,35
	ash 1,-35
	dpb 1,[POINT 7,vst_char7,13]
	popj 17,

la_char7:
	move 1,a_char7
	ash 1,-35
	popj 17,

sa_char7:
	lsh 1,35
	ash 1,-35
	dpb 1,[POINT 7,a_char7,6]
	popj 17,

lai_char7:
	move 4,[POINT 7,a_char7,6]
	jumple 1,%L763
%L762:
	ibp 4
	sojg 1,%L762	; decrement_and_branch_until_zero
%L763:
	jumpe 1,%L765
%L764:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L764
%L765:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

sai_char7:
	lsh 2,35
	ash 2,-35
	move 4,[POINT 7,a_char7,6]
	jumple 1,%L768
%L767:
	ibp 4
	sojg 1,%L767	; decrement_and_branch_until_zero
%L768:
	jumpe 1,%L770
%L769:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L769
%L770:
	dpb 2,4
	popj 17,

lvi_char7:
	move 4,[POINT 7,va_char7,6]
	jumple 1,%L773
%L772:
	ibp 4
	sojg 1,%L772	; decrement_and_branch_until_zero
%L773:
	jumpe 1,%L775
%L774:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L774
%L775:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

svi_char7:
	lsh 2,35
	ash 2,-35
	move 4,[POINT 7,va_char7,6]
	jumple 1,%L778
%L777:
	ibp 4
	sojg 1,%L777	; decrement_and_branch_until_zero
%L778:
	jumpe 1,%L780
%L779:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L779
%L780:
	dpb 2,4
	popj 17,

lp_char7:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

sp_char7:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

spr_char7:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	lsh 2,35
	ash 2,-35
	move 1,2
	popj 17,

lpi_char7:
	jumple 2,%L787
%L786:
	ibp 1
	sojg 2,%L786	; decrement_and_branch_until_zero
%L787:
	jumpe 2,%L789
%L788:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L788
%L789:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

spi_char7:
	lsh 3,35
	ash 3,-35
	jumple 2,%L793
%L792:
	ibp 1
	sojg 2,%L792	; decrement_and_branch_until_zero
%L793:
	jumpe 2,%L795
%L794:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L794
%L795:
	dpb 3,1
	popj 17,

lgp_char7:
	ldb 1,ps_char7
	trne 1,100
	orcmi 1,177
	popj 17,

lgap_char7:
	ldb 1,pa_char7
	trne 1,100
	orcmi 1,177
	popj 17,

lgvp_char7:
	ldb 1,vps_char7
	trne 1,100
	orcmi 1,177
	popj 17,

sgp_char7:
	lsh 1,35
	ash 1,-35
	dpb 1,ps_char7
	popj 17,

prp_char7:
	ildb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

pip_char7:
	ldb 4,1
	trne 4,100
	orcmi 4,177
	ildb 1,1
	add 4,1
	lsh 4,35
	ash 4,-35
	move 1,4
	popj 17,

us_char7:
	lsh 1,35
	ash 1,-35
	ldb 6,[POINT 18,s_char7,35]
	add 1,6
	movem 1,s_char7
	lsh 1,35
	ash 1,-35
	popj 17,

ust_char7:
	lsh 1,35
	ash 1,-35
	move 4,st_char7
	ash 4,-35
	add 4,1
	dpb 4,[POINT 7,st_char7,6]
	move 4,st_char7
	lsh 4,7
	ash 4,-35
	sub 4,1
	dpb 4,[POINT 7,st_char7,13]
	move 1,st_char7
	ash 1,-35
	move 4,st_char7
	lsh 4,7
	ash 4,-35
	add 1,4
	lsh 1,35
	ash 1,-35
	popj 17,

use_char7:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	lsh 11,35
	ash 11,-35
	andi 12,7
	move 13,11
	lsh 13,35
	ash 13,-35
	move 1,13
	pushj 17,ss_char7
	move 1,11
	addi 1,1
	lsh 1,35
	ash 1,-35
	pushj 17,sv_char7
	move 1,11
	addi 1,2
	lsh 1,35
	ash 1,-35
	pushj 17,sst_char7
	move 1,11
	addi 1,3
	lsh 1,35
	ash 1,-35
	pushj 17,svs_char7
	move 1,11
	addi 1,4
	lsh 1,35
	ash 1,-35
	pushj 17,sa_char7
	move 2,11
	addi 2,5
	lsh 2,35
	ash 2,-35
	move 1,12
	pushj 17,sai_char7
	move 2,11
	addi 2,6
	lsh 2,35
	ash 2,-35
	move 1,12
	pushj 17,svi_char7
	move 2,11
	addi 2,7
	lsh 2,35
	ash 2,-35
	move 1,[POINT 7,a_char7,13]
	pushj 17,sp_char7
	move 3,11
	addi 3,10
	lsh 3,35
	ash 3,-35
	move 1,[POINT 7,a_char7,6]
	move 2,12
	pushj 17,spi_char7
	move 1,11
	addi 1,11
	lsh 1,35
	ash 1,-35
	pushj 17,sgp_char7
	move 1,13
	pushj 17,ssr_char7
	move 10,1
	lsh 10,35
	ash 10,-35
	move 1,11
	addi 1,12
	lsh 1,35
	ash 1,-35
	pushj 17,sstr_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	addi 11,13
	lsh 11,35
	ash 11,-35
	move 1,[POINT 7,a_char7,20]
	move 2,11
	pushj 17,spr_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	pushj 17,ls_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	pushj 17,lv_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	pushj 17,lst_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	pushj 17,lsy_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	pushj 17,lvs_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	pushj 17,la_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	move 1,12
	pushj 17,lai_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	move 1,12
	pushj 17,lvi_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	move 1,[POINT 7,a_char7,13]
	pushj 17,lp_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	move 1,[POINT 7,a_char7,6]
	move 2,12
	pushj 17,lpi_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	pushj 17,lgp_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	pushj 17,lgap_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	pushj 17,lgvp_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	move 1,[POINT 7,a_char7,6]
	pushj 17,prp_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	move 1,[POINT 7,a_char7,6]
	pushj 17,pip_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	move 1,13
	pushj 17,us_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	move 1,13
	pushj 17,ust_char7
	add 10,1
	lsh 10,35
	ash 10,-35
	lsh 10,35
	ash 10,-35
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_uchar7:
	.long	s_uchar7+301989888
	.align	2
pa_uchar7:
	.long	a_uchar7+8707375104
	.align	2
vps_uchar7:
	.long	vs_uchar7+301989888

ls_uchar7:
	move 1,s_uchar7
	popj 17,

ss_uchar7:
	movem 1,s_uchar7
	popj 17,

ssr_uchar7:
	andi 1,177
	movem 1,s_uchar7
	andi 1,177
	popj 17,

lv_uchar7:
	ldb 1,[POINT 18,vs_uchar7,35]
	popj 17,

sv_uchar7:
	andi 1,177
	movem 1,vs_uchar7
	popj 17,

lst_uchar7:
	move 1,st_uchar7
	lsh 1,-35
	popj 17,

lsy_uchar7:
	ldb 1,[POINT 7,st_uchar7,13]
	popj 17,

sst_uchar7:
	andi 1,177
	dpb 1,[POINT 7,st_uchar7,6]
	popj 17,

sstr_uchar7:
	andi 1,177
	dpb 1,[POINT 7,st_uchar7,13]
	andi 1,177
	popj 17,

lvs_uchar7:
	move 1,vst_uchar7
	lsh 1,-35
	popj 17,

svs_uchar7:
	andi 1,177
	dpb 1,[POINT 7,vst_uchar7,13]
	popj 17,

la_uchar7:
	move 1,a_uchar7
	lsh 1,-35
	popj 17,

sa_uchar7:
	andi 1,177
	dpb 1,[POINT 7,a_uchar7,6]
	popj 17,

lai_uchar7:
	move 4,[POINT 7,a_uchar7,6]
	jumple 1,%L837
%L836:
	ibp 4
	sojg 1,%L836	; decrement_and_branch_until_zero
%L837:
	jumpe 1,%L839
%L838:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L838
%L839:
	ldb 1,4
	popj 17,

sai_uchar7:
	andi 2,177
	move 4,[POINT 7,a_uchar7,6]
	jumple 1,%L842
%L841:
	ibp 4
	sojg 1,%L841	; decrement_and_branch_until_zero
%L842:
	jumpe 1,%L844
%L843:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L843
%L844:
	dpb 2,4
	popj 17,

lvi_uchar7:
	move 4,[POINT 7,va_uchar7,6]
	jumple 1,%L847
%L846:
	ibp 4
	sojg 1,%L846	; decrement_and_branch_until_zero
%L847:
	jumpe 1,%L849
%L848:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L848
%L849:
	ldb 1,4
	popj 17,

svi_uchar7:
	andi 2,177
	move 4,[POINT 7,va_uchar7,6]
	jumple 1,%L852
%L851:
	ibp 4
	sojg 1,%L851	; decrement_and_branch_until_zero
%L852:
	jumpe 1,%L854
%L853:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L853
%L854:
	dpb 2,4
	popj 17,

lp_uchar7:
	ldb 1,1
	popj 17,

sp_uchar7:
	andi 2,177
	dpb 2,1
	popj 17,

spr_uchar7:
	andi 2,177
	dpb 2,1
	andi 2,177
	move 1,2
	popj 17,

lpi_uchar7:
	jumple 2,%L861
%L860:
	ibp 1
	sojg 2,%L860	; decrement_and_branch_until_zero
%L861:
	jumpe 2,%L863
%L862:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L862
%L863:
	ldb 1,1
	popj 17,

spi_uchar7:
	andi 3,177
	jumple 2,%L867
%L866:
	ibp 1
	sojg 2,%L866	; decrement_and_branch_until_zero
%L867:
	jumpe 2,%L869
%L868:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L868
%L869:
	dpb 3,1
	popj 17,

lgp_uchar7:
	ldb 1,ps_uchar7
	popj 17,

lgap_uchar7:
	ldb 1,pa_uchar7
	popj 17,

lgvp_uchar7:
	ldb 1,vps_uchar7
	popj 17,

sgp_uchar7:
	andi 1,177
	dpb 1,ps_uchar7
	popj 17,

prp_uchar7:
	ildb 1,1
	popj 17,

pip_uchar7:
	ldb 4,1
	ildb 1,1
	add 4,1
	andi 4,177
	move 1,4
	popj 17,

us_uchar7:
	andi 1,177
	ldb 6,[POINT 18,s_uchar7,35]
	add 1,6
	movem 1,s_uchar7
	andi 1,177
	popj 17,

ust_uchar7:
	andi 1,177
	move 4,st_uchar7
	lsh 4,-35
	add 4,1
	dpb 4,[POINT 7,st_uchar7,6]
	ldb 4,[POINT 7,st_uchar7,13]
	sub 4,1
	dpb 4,[POINT 7,st_uchar7,13]
	move 1,st_uchar7
	lsh 1,-35
	ldb 4,[POINT 7,st_uchar7,13]
	add 1,4
	andi 1,177
	popj 17,

use_uchar7:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	andi 11,177
	andi 12,7
	move 13,11
	andi 13,177
	move 1,13
	pushj 17,ss_uchar7
	move 1,11
	addi 1,1
	andi 1,177
	pushj 17,sv_uchar7
	move 1,11
	addi 1,2
	andi 1,177
	pushj 17,sst_uchar7
	move 1,11
	addi 1,3
	andi 1,177
	pushj 17,svs_uchar7
	move 1,11
	addi 1,4
	andi 1,177
	pushj 17,sa_uchar7
	move 2,11
	addi 2,5
	andi 2,177
	move 1,12
	pushj 17,sai_uchar7
	move 2,11
	addi 2,6
	andi 2,177
	move 1,12
	pushj 17,svi_uchar7
	move 2,11
	addi 2,7
	andi 2,177
	move 1,[POINT 7,a_uchar7,13]
	pushj 17,sp_uchar7
	move 3,11
	addi 3,10
	andi 3,177
	move 1,[POINT 7,a_uchar7,6]
	move 2,12
	pushj 17,spi_uchar7
	move 1,11
	addi 1,11
	andi 1,177
	pushj 17,sgp_uchar7
	move 1,13
	pushj 17,ssr_uchar7
	move 10,1
	andi 10,177
	move 1,11
	addi 1,12
	andi 1,177
	pushj 17,sstr_uchar7
	add 10,1
	andi 10,177
	addi 11,13
	andi 11,177
	move 1,[POINT 7,a_uchar7,20]
	move 2,11
	pushj 17,spr_uchar7
	add 10,1
	andi 10,177
	pushj 17,ls_uchar7
	add 10,1
	andi 10,177
	pushj 17,lv_uchar7
	add 10,1
	andi 10,177
	pushj 17,lst_uchar7
	add 10,1
	andi 10,177
	pushj 17,lsy_uchar7
	add 10,1
	andi 10,177
	pushj 17,lvs_uchar7
	add 10,1
	andi 10,177
	pushj 17,la_uchar7
	add 10,1
	andi 10,177
	move 1,12
	pushj 17,lai_uchar7
	add 10,1
	andi 10,177
	move 1,12
	pushj 17,lvi_uchar7
	add 10,1
	andi 10,177
	move 1,[POINT 7,a_uchar7,13]
	pushj 17,lp_uchar7
	add 10,1
	andi 10,177
	move 1,[POINT 7,a_uchar7,6]
	move 2,12
	pushj 17,lpi_uchar7
	add 10,1
	andi 10,177
	pushj 17,lgp_uchar7
	add 10,1
	andi 10,177
	pushj 17,lgap_uchar7
	add 10,1
	andi 10,177
	pushj 17,lgvp_uchar7
	add 10,1
	andi 10,177
	move 1,[POINT 7,a_uchar7,6]
	pushj 17,prp_uchar7
	add 10,1
	andi 10,177
	move 1,[POINT 7,a_uchar7,6]
	pushj 17,pip_uchar7
	add 10,1
	andi 10,177
	move 1,13
	pushj 17,us_uchar7
	add 10,1
	andi 10,177
	move 1,13
	pushj 17,ust_uchar7
	add 10,1
	andi 10,177
	andi 10,177
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_char8:
	.long	s_char8+301989888
	.align	2
pa_char8:
	.long	a_char8+4429185024
	.align	2
vps_char8:
	.long	vs_char8+301989888

ls_char8:
	hrre 1,s_char8
	popj 17,

ss_char8:
	movem 1,s_char8
	popj 17,

ssr_char8:
	lsh 1,34
	ash 1,-34
	movem 1,s_char8
	lsh 1,34
	ash 1,-34
	popj 17,

lv_char8:
	ldb 1,[POINT 18,vs_char8,35]
	trne 1,200
	orcmi 1,377
	popj 17,

sv_char8:
	lsh 1,34
	ash 1,-34
	movem 1,vs_char8
	popj 17,

lst_char8:
	move 1,st_char8
	ash 1,-34
	popj 17,

lsy_char8:
	move 1,st_char8
	lsh 1,10
	ash 1,-34
	popj 17,

sst_char8:
	lsh 1,34
	ash 1,-34
	dpb 1,[POINT 8,st_char8,7]
	popj 17,

sstr_char8:
	lsh 1,34
	ash 1,-34
	dpb 1,[POINT 8,st_char8,15]
	lsh 1,34
	ash 1,-34
	popj 17,

lvs_char8:
	move 1,vst_char8
	ash 1,-34
	popj 17,

svs_char8:
	lsh 1,34
	ash 1,-34
	dpb 1,[POINT 8,vst_char8,15]
	popj 17,

la_char8:
	move 1,a_char8
	ash 1,-34
	popj 17,

sa_char8:
	lsh 1,34
	ash 1,-34
	dpb 1,[POINT 8,a_char8,7]
	popj 17,

lai_char8:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,a_char8,7]
	jumpe 4,%L911
%L910:
	ibp 3
	sojn 4,%L910	; decrement_and_branch_until_zero
%L911:
	ldb 1,3
	trne 1,200
	orcmi 1,377
	popj 17,

sai_char8:
	lsh 2,34
	ash 2,-34
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,a_char8,7]
	jumpe 4,%L914
%L913:
	ibp 3
	sojn 4,%L913	; decrement_and_branch_until_zero
%L914:
	dpb 2,3
	popj 17,

lvi_char8:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,va_char8,7]
	jumpe 4,%L917
%L916:
	ibp 1
	sojn 4,%L916	; decrement_and_branch_until_zero
%L917:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

svi_char8:
	lsh 2,34
	ash 2,-34
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,va_char8,7]
	jumpe 4,%L920
%L919:
	ibp 3
	sojn 4,%L919	; decrement_and_branch_until_zero
%L920:
	dpb 2,3
	popj 17,

lp_char8:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

sp_char8:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	popj 17,

spr_char8:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	lsh 2,34
	ash 2,-34
	move 1,2
	popj 17,

lpi_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L927
%L926:
	ibp 1
	sojn 4,%L926	; decrement_and_branch_until_zero
%L927:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

spi_char8:
	lsh 3,34
	ash 3,-34
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L931
%L930:
	ibp 1
	sojn 4,%L930	; decrement_and_branch_until_zero
%L931:
	dpb 3,1
	popj 17,

lgp_char8:
	ldb 1,ps_char8
	trne 1,200
	orcmi 1,377
	popj 17,

lgap_char8:
	ldb 1,pa_char8
	trne 1,200
	orcmi 1,377
	popj 17,

lgvp_char8:
	ldb 1,vps_char8
	trne 1,200
	orcmi 1,377
	popj 17,

sgp_char8:
	lsh 1,34
	ash 1,-34
	dpb 1,ps_char8
	popj 17,

prp_char8:
	ildb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

pip_char8:
	ldb 4,1
	trne 4,200
	orcmi 4,377
	ildb 1,1
	add 4,1
	lsh 4,34
	ash 4,-34
	move 1,4
	popj 17,

us_char8:
	lsh 1,34
	ash 1,-34
	ldb 6,[POINT 18,s_char8,35]
	add 1,6
	movem 1,s_char8
	lsh 1,34
	ash 1,-34
	popj 17,

ust_char8:
	lsh 1,34
	ash 1,-34
	move 4,st_char8
	ash 4,-34
	add 4,1
	dpb 4,[POINT 8,st_char8,7]
	move 4,st_char8
	lsh 4,10
	ash 4,-34
	sub 4,1
	dpb 4,[POINT 8,st_char8,15]
	move 1,st_char8
	ash 1,-34
	move 4,st_char8
	lsh 4,10
	ash 4,-34
	add 1,4
	lsh 1,34
	ash 1,-34
	popj 17,

use_char8:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	lsh 11,34
	ash 11,-34
	andi 12,7
	move 13,11
	lsh 13,34
	ash 13,-34
	move 1,13
	pushj 17,ss_char8
	move 1,11
	addi 1,1
	lsh 1,34
	ash 1,-34
	pushj 17,sv_char8
	move 1,11
	addi 1,2
	lsh 1,34
	ash 1,-34
	pushj 17,sst_char8
	move 1,11
	addi 1,3
	lsh 1,34
	ash 1,-34
	pushj 17,svs_char8
	move 1,11
	addi 1,4
	lsh 1,34
	ash 1,-34
	pushj 17,sa_char8
	move 2,11
	addi 2,5
	lsh 2,34
	ash 2,-34
	move 1,12
	pushj 17,sai_char8
	move 2,11
	addi 2,6
	lsh 2,34
	ash 2,-34
	move 1,12
	pushj 17,svi_char8
	move 2,11
	addi 2,7
	lsh 2,34
	ash 2,-34
	move 1,[POINT 8,a_char8,15]
	pushj 17,sp_char8
	move 3,11
	addi 3,10
	lsh 3,34
	ash 3,-34
	move 1,[POINT 8,a_char8,7]
	move 2,12
	pushj 17,spi_char8
	move 1,11
	addi 1,11
	lsh 1,34
	ash 1,-34
	pushj 17,sgp_char8
	move 1,13
	pushj 17,ssr_char8
	move 10,1
	lsh 10,34
	ash 10,-34
	move 1,11
	addi 1,12
	lsh 1,34
	ash 1,-34
	pushj 17,sstr_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	addi 11,13
	lsh 11,34
	ash 11,-34
	move 1,[POINT 8,a_char8,23]
	move 2,11
	pushj 17,spr_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	pushj 17,ls_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	pushj 17,lv_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	pushj 17,lst_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	pushj 17,lsy_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	pushj 17,lvs_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	pushj 17,la_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,12
	pushj 17,lai_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,12
	pushj 17,lvi_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,[POINT 8,a_char8,15]
	pushj 17,lp_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,[POINT 8,a_char8,7]
	move 2,12
	pushj 17,lpi_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	pushj 17,lgp_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	pushj 17,lgap_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	pushj 17,lgvp_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,[POINT 8,a_char8,7]
	pushj 17,prp_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,[POINT 8,a_char8,7]
	pushj 17,pip_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,13
	pushj 17,us_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	move 1,13
	pushj 17,ust_char8
	add 10,1
	lsh 10,34
	ash 10,-34
	lsh 10,34
	ash 10,-34
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_uchar8:
	.long	s_uchar8+301989888
	.align	2
pa_uchar8:
	.long	a_uchar8+4429185024
	.align	2
vps_uchar8:
	.long	vs_uchar8+301989888

ls_uchar8:
	move 1,s_uchar8
	popj 17,

ss_uchar8:
	movem 1,s_uchar8
	popj 17,

ssr_uchar8:
	andi 1,377
	movem 1,s_uchar8
	andi 1,377
	popj 17,

lv_uchar8:
	ldb 1,[POINT 18,vs_uchar8,35]
	popj 17,

sv_uchar8:
	andi 1,377
	movem 1,vs_uchar8
	popj 17,

lst_uchar8:
	move 1,st_uchar8
	lsh 1,-34
	popj 17,

lsy_uchar8:
	ldb 1,[POINT 8,st_uchar8,15]
	popj 17,

sst_uchar8:
	andi 1,377
	dpb 1,[POINT 8,st_uchar8,7]
	popj 17,

sstr_uchar8:
	andi 1,377
	dpb 1,[POINT 8,st_uchar8,15]
	andi 1,377
	popj 17,

lvs_uchar8:
	move 1,vst_uchar8
	lsh 1,-34
	popj 17,

svs_uchar8:
	andi 1,377
	dpb 1,[POINT 8,vst_uchar8,15]
	popj 17,

la_uchar8:
	move 1,a_uchar8
	lsh 1,-34
	popj 17,

sa_uchar8:
	andi 1,377
	dpb 1,[POINT 8,a_uchar8,7]
	popj 17,

lai_uchar8:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,a_uchar8,7]
	jumpe 4,%L973
%L972:
	ibp 3
	sojn 4,%L972	; decrement_and_branch_until_zero
%L973:
	ldb 1,3
	popj 17,

sai_uchar8:
	andi 2,377
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,a_uchar8,7]
	jumpe 4,%L976
%L975:
	ibp 3
	sojn 4,%L975	; decrement_and_branch_until_zero
%L976:
	dpb 2,3
	popj 17,

lvi_uchar8:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,va_uchar8,7]
	jumpe 4,%L979
%L978:
	ibp 1
	sojn 4,%L978	; decrement_and_branch_until_zero
%L979:
	ldb 1,1
	popj 17,

svi_uchar8:
	andi 2,377
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,va_uchar8,7]
	jumpe 4,%L982
%L981:
	ibp 3
	sojn 4,%L981	; decrement_and_branch_until_zero
%L982:
	dpb 2,3
	popj 17,

lp_uchar8:
	ldb 1,1
	popj 17,

sp_uchar8:
	andi 2,377
	dpb 2,1
	popj 17,

spr_uchar8:
	andi 2,377
	dpb 2,1
	andi 2,377
	move 1,2
	popj 17,

lpi_uchar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L989
%L988:
	ibp 1
	sojn 4,%L988	; decrement_and_branch_until_zero
%L989:
	ldb 1,1
	popj 17,

spi_uchar8:
	andi 3,377
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L993
%L992:
	ibp 1
	sojn 4,%L992	; decrement_and_branch_until_zero
%L993:
	dpb 3,1
	popj 17,

lgp_uchar8:
	ldb 1,ps_uchar8
	popj 17,

lgap_uchar8:
	ldb 1,pa_uchar8
	popj 17,

lgvp_uchar8:
	ldb 1,vps_uchar8
	popj 17,

sgp_uchar8:
	andi 1,377
	dpb 1,ps_uchar8
	popj 17,

prp_uchar8:
	ildb 1,1
	popj 17,

pip_uchar8:
	ldb 4,1
	ildb 1,1
	add 4,1
	andi 4,377
	move 1,4
	popj 17,

us_uchar8:
	andi 1,377
	ldb 6,[POINT 18,s_uchar8,35]
	add 1,6
	movem 1,s_uchar8
	andi 1,377
	popj 17,

ust_uchar8:
	andi 1,377
	move 4,st_uchar8
	lsh 4,-34
	add 4,1
	dpb 4,[POINT 8,st_uchar8,7]
	ldb 4,[POINT 8,st_uchar8,15]
	sub 4,1
	dpb 4,[POINT 8,st_uchar8,15]
	move 1,st_uchar8
	lsh 1,-34
	ldb 4,[POINT 8,st_uchar8,15]
	add 1,4
	andi 1,377
	popj 17,

use_uchar8:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	andi 11,377
	andi 12,7
	move 13,11
	andi 13,377
	move 1,13
	pushj 17,ss_uchar8
	move 1,11
	addi 1,1
	andi 1,377
	pushj 17,sv_uchar8
	move 1,11
	addi 1,2
	andi 1,377
	pushj 17,sst_uchar8
	move 1,11
	addi 1,3
	andi 1,377
	pushj 17,svs_uchar8
	move 1,11
	addi 1,4
	andi 1,377
	pushj 17,sa_uchar8
	move 2,11
	addi 2,5
	andi 2,377
	move 1,12
	pushj 17,sai_uchar8
	move 2,11
	addi 2,6
	andi 2,377
	move 1,12
	pushj 17,svi_uchar8
	move 2,11
	addi 2,7
	andi 2,377
	move 1,[POINT 8,a_uchar8,15]
	pushj 17,sp_uchar8
	move 3,11
	addi 3,10
	andi 3,377
	move 1,[POINT 8,a_uchar8,7]
	move 2,12
	pushj 17,spi_uchar8
	move 1,11
	addi 1,11
	andi 1,377
	pushj 17,sgp_uchar8
	move 1,13
	pushj 17,ssr_uchar8
	move 10,1
	andi 10,377
	move 1,11
	addi 1,12
	andi 1,377
	pushj 17,sstr_uchar8
	add 10,1
	andi 10,377
	addi 11,13
	andi 11,377
	move 1,[POINT 8,a_uchar8,23]
	move 2,11
	pushj 17,spr_uchar8
	add 10,1
	andi 10,377
	pushj 17,ls_uchar8
	add 10,1
	andi 10,377
	pushj 17,lv_uchar8
	add 10,1
	andi 10,377
	pushj 17,lst_uchar8
	add 10,1
	andi 10,377
	pushj 17,lsy_uchar8
	add 10,1
	andi 10,377
	pushj 17,lvs_uchar8
	add 10,1
	andi 10,377
	pushj 17,la_uchar8
	add 10,1
	andi 10,377
	move 1,12
	pushj 17,lai_uchar8
	add 10,1
	andi 10,377
	move 1,12
	pushj 17,lvi_uchar8
	add 10,1
	andi 10,377
	move 1,[POINT 8,a_uchar8,15]
	pushj 17,lp_uchar8
	add 10,1
	andi 10,377
	move 1,[POINT 8,a_uchar8,7]
	move 2,12
	pushj 17,lpi_uchar8
	add 10,1
	andi 10,377
	pushj 17,lgp_uchar8
	add 10,1
	andi 10,377
	pushj 17,lgap_uchar8
	add 10,1
	andi 10,377
	pushj 17,lgvp_uchar8
	add 10,1
	andi 10,377
	move 1,[POINT 8,a_uchar8,7]
	pushj 17,prp_uchar8
	add 10,1
	andi 10,377
	move 1,[POINT 8,a_uchar8,7]
	pushj 17,pip_uchar8
	add 10,1
	andi 10,377
	move 1,13
	pushj 17,us_uchar8
	add 10,1
	andi 10,377
	move 1,13
	pushj 17,ust_uchar8
	add 10,1
	andi 10,377
	andi 10,377
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_char9:
	.long	s_char9+301989888
	.align	2
pa_char9:
	.long	a_char9+150994944
	.align	2
vps_char9:
	.long	vs_char9+301989888

ls_char9:
	hrre 1,s_char9
	popj 17,

ss_char9:
	movem 1,s_char9
	popj 17,

ssr_char9:
	movem 1,s_char9
	lsh 1,33
	ash 1,-33
	popj 17,

lv_char9:
	hrre 1,vs_char9
	popj 17,

sv_char9:
	movem 1,vs_char9
	popj 17,

lst_char9:
	move 1,st_char9
	ash 1,-33
	popj 17,

lsy_char9:
	move 1,st_char9
	lsh 1,11
	ash 1,-33
	popj 17,

sst_char9:
	dpb 1,[POINT 9,st_char9,8]
	popj 17,

sstr_char9:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,st_char9,17]
	lsh 1,33
	ash 1,-33
	popj 17,

lvs_char9:
	ldb 1,[POINT 9,vst_char9,8]
	lsh 1,33
	ash 1,-33
	popj 17,

svs_char9:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vst_char9,17]
	popj 17,

la_char9:
	move 1,a_char9
	ash 1,-33
	popj 17,

sa_char9:
	dpb 1,[POINT 9,a_char9,8]
	popj 17,

lai_char9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_char9,8]
	jumpe 4,%L1035
%L1034:
	ibp 3
	sojn 4,%L1034	; decrement_and_branch_until_zero
%L1035:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

sai_char9:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_char9,8]
	jumpe 4,%L1038
%L1037:
	ibp 3
	sojn 4,%L1037	; decrement_and_branch_until_zero
%L1038:
	dpb 2,3
	popj 17,

lvi_char9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,va_char9,8]
	jumpe 4,%L1041
%L1040:
	ibp 1
	sojn 4,%L1040	; decrement_and_branch_until_zero
%L1041:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

svi_char9:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,va_char9,8]
	jumpe 4,%L1044
%L1043:
	ibp 3
	sojn 4,%L1043	; decrement_and_branch_until_zero
%L1044:
	dpb 2,3
	popj 17,

lp_char9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

sp_char9:
	dpb 2,1
	popj 17,

spr_char9:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

lpi_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1051
%L1050:
	ibp 1
	sojn 4,%L1050	; decrement_and_branch_until_zero
%L1051:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

spi_char9:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1055
%L1054:
	ibp 1
	sojn 4,%L1054	; decrement_and_branch_until_zero
%L1055:
	dpb 3,1
	popj 17,

lgp_char9:
	ldb 1,ps_char9
	trne 1,400
	orcmi 1,777
	popj 17,

lgap_char9:
	ldb 1,pa_char9
	trne 1,400
	orcmi 1,777
	popj 17,

lgvp_char9:
	ldb 1,vps_char9
	trne 1,400
	orcmi 1,777
	popj 17,

sgp_char9:
	dpb 1,ps_char9
	popj 17,

prp_char9:
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

pip_char9:
	ldb 4,1
	ildb 1,1
	add 4,1
	lsh 4,33
	ash 4,-33
	move 1,4
	popj 17,

us_char9:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,s_char9,35]
	add 1,6
	movem 1,s_char9
	lsh 1,33
	ash 1,-33
	popj 17,

ust_char9:
	andi 1,777	; zero_extendqisi2
	ldb 4,[POINT 9,st_char9,8]
	add 4,1
	dpb 4,[POINT 9,st_char9,8]
	ldb 4,[POINT 9,st_char9,17]
	sub 4,1
	dpb 4,[POINT 9,st_char9,17]
	ldb 1,[POINT 9,st_char9,8]
	ldb 4,[POINT 9,st_char9,17]
	add 1,4
	lsh 1,33
	ash 1,-33
	popj 17,

use_char9:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	andi 11,7
	move 12,10
	lsh 12,33
	ash 12,-33
	move 1,12
	pushj 17,ss_char9
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sv_char9
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sst_char9
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,svs_char9
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sa_char9
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,11
	pushj 17,sai_char9
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,11
	pushj 17,svi_char9
	addi 10,1
	move 2,10
	lsh 2,33
	ash 2,-33
	move 1,[POINT 9,a_char9,17]
	pushj 17,sp_char9
	addi 10,1
	move 3,10
	lsh 3,33
	ash 3,-33
	move 1,[POINT 9,a_char9,8]
	move 2,11
	pushj 17,spi_char9
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sgp_char9
	move 1,12
	pushj 17,ssr_char9
	move 13,1
	andi 13,777	; zero_extendqisi2
	addi 10,1
	move 1,10
	lsh 1,33
	ash 1,-33
	pushj 17,sstr_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	addi 10,1
	lsh 10,33
	ash 10,-33
	move 1,[POINT 9,a_char9,26]
	move 2,10
	pushj 17,spr_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,ls_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lv_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lst_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lsy_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lvs_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,la_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,11
	pushj 17,lai_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,11
	pushj 17,lvi_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_char9,17]
	pushj 17,lp_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_char9,8]
	move 2,11
	pushj 17,lpi_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgp_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgap_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	pushj 17,lgvp_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_char9,8]
	pushj 17,prp_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,[POINT 9,a_char9,8]
	pushj 17,pip_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,12
	pushj 17,us_char9
	add 1,13
	move 13,1
	andi 13,777	; zero_extendqisi2
	move 1,12
	pushj 17,ust_char9
	add 13,1
	move 1,13
	lsh 1,33
	ash 1,-33
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_uchar9:
	.long	s_uchar9+301989888
	.align	2
pa_uchar9:
	.long	a_uchar9+150994944
	.align	2
vps_uchar9:
	.long	vs_uchar9+301989888

ls_uchar9:
	move 1,s_uchar9
	popj 17,

ss_uchar9:
	movem 1,s_uchar9
	popj 17,

ssr_uchar9:
	movem 1,s_uchar9
	popj 17,

lv_uchar9:
	move 1,vs_uchar9
	popj 17,

sv_uchar9:
	movem 1,vs_uchar9
	popj 17,

lst_uchar9:
	move 1,st_uchar9
	lsh 1,-33
	popj 17,

lsy_uchar9:
	ldb 1,[POINT 9,st_uchar9,17]
	popj 17,

sst_uchar9:
	dpb 1,[POINT 9,st_uchar9,8]
	popj 17,

sstr_uchar9:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,st_uchar9,17]
	andi 1,777	; zero_extendqisi2
	popj 17,

lvs_uchar9:
	ldb 1,[POINT 9,vst_uchar9,8]
	popj 17,

svs_uchar9:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,vst_uchar9,17]
	popj 17,

la_uchar9:
	move 1,a_uchar9
	lsh 1,-33
	popj 17,

sa_uchar9:
	dpb 1,[POINT 9,a_uchar9,8]
	popj 17,

lai_uchar9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_uchar9,8]
	jumpe 4,%L1097
%L1096:
	ibp 3
	sojn 4,%L1096	; decrement_and_branch_until_zero
%L1097:
	ldb 1,3
	popj 17,

sai_uchar9:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,a_uchar9,8]
	jumpe 4,%L1100
%L1099:
	ibp 3
	sojn 4,%L1099	; decrement_and_branch_until_zero
%L1100:
	dpb 2,3
	popj 17,

lvi_uchar9:
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,va_uchar9,8]
	jumpe 4,%L1103
%L1102:
	ibp 1
	sojn 4,%L1102	; decrement_and_branch_until_zero
%L1103:
	ldb 1,1
	popj 17,

svi_uchar9:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,va_uchar9,8]
	jumpe 4,%L1106
%L1105:
	ibp 3
	sojn 4,%L1105	; decrement_and_branch_until_zero
%L1106:
	dpb 2,3
	popj 17,

lp_uchar9:
	ldb 1,1
	popj 17,

sp_uchar9:
	dpb 2,1
	popj 17,

spr_uchar9:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	move 1,2
	popj 17,

lpi_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1113
%L1112:
	ibp 1
	sojn 4,%L1112	; decrement_and_branch_until_zero
%L1113:
	ldb 1,1
	popj 17,

spi_uchar9:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1117
%L1116:
	ibp 1
	sojn 4,%L1116	; decrement_and_branch_until_zero
%L1117:
	dpb 3,1
	popj 17,

lgp_uchar9:
	ldb 1,ps_uchar9
	popj 17,

lgap_uchar9:
	ldb 1,pa_uchar9
	popj 17,

lgvp_uchar9:
	ldb 1,vps_uchar9
	popj 17,

sgp_uchar9:
	dpb 1,ps_uchar9
	popj 17,

prp_uchar9:
	ildb 1,1
	popj 17,

pip_uchar9:
	ldb 4,1
	ildb 1,1
	add 4,1
	andi 4,777	; zero_extendqisi2
	move 1,4
	popj 17,

us_uchar9:
	andi 1,777	; zero_extendqisi2
	ldb 6,[POINT 18,s_uchar9,35]
	add 1,6
	movem 1,s_uchar9
	andi 1,777
	popj 17,

ust_uchar9:
	andi 1,777	; zero_extendqisi2
	ldb 4,[POINT 9,st_uchar9,8]
	add 4,1
	dpb 4,[POINT 9,st_uchar9,8]
	ldb 4,[POINT 9,st_uchar9,17]
	sub 4,1
	dpb 4,[POINT 9,st_uchar9,17]
	ldb 1,[POINT 9,st_uchar9,8]
	ldb 4,[POINT 9,st_uchar9,17]
	add 1,4
	andi 1,777	; zero_extendqisi2
	popj 17,

use_uchar9:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	andi 10,777	; zero_extendqisi2
	andi 11,7
	move 1,10
	pushj 17,ss_uchar9
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sv_uchar9
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sst_uchar9
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,svs_uchar9
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sa_uchar9
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,11
	pushj 17,sai_uchar9
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,11
	pushj 17,svi_uchar9
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	move 1,[POINT 9,a_uchar9,17]
	pushj 17,sp_uchar9
	addi 10,1
	move 3,10
	andi 3,777	; zero_extendqisi2
	move 1,[POINT 9,a_uchar9,8]
	move 2,11
	pushj 17,spi_uchar9
	addi 10,1
	move 1,10
	andi 1,777	; zero_extendqisi2
	subi 10,11
	pushj 17,sgp_uchar9
	move 1,10
	pushj 17,ssr_uchar9
	move 12,1
	andi 12,777	; zero_extendqisi2
	addi 10,12
	move 1,10
	andi 1,777	; zero_extendqisi2
	pushj 17,sstr_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	addi 10,1
	move 2,10
	andi 2,777	; zero_extendqisi2
	subi 10,13
	move 1,[POINT 9,a_uchar9,26]
	pushj 17,spr_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,ls_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lv_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lst_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lsy_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lvs_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,la_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,11
	pushj 17,lai_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,11
	pushj 17,lvi_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_uchar9,17]
	pushj 17,lp_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_uchar9,8]
	move 2,11
	pushj 17,lpi_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgp_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgap_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	pushj 17,lgvp_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_uchar9,8]
	pushj 17,prp_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,[POINT 9,a_uchar9,8]
	pushj 17,pip_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,10
	pushj 17,us_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,10
	pushj 17,ust_uchar9
	add 1,12
	move 12,1
	andi 12,777	; zero_extendqisi2
	move 1,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_short16:
	.long	s_short16+301989888
	.align	2
pa_short16:
	.long	a_short16+301989889
	.align	2
vps_short16:
	.long	vs_short16+301989888

ls_short16:
	hlrz 1,s_short16
	lsh 1,24
	ash 1,-24
	popj 17,

ss_short16:
	lsh 1,24
	ash 1,-24
	movem 1,s_short16
	popj 17,

ssr_short16:
	lsh 1,24
	ash 1,-24
	movem 1,s_short16
	lsh 1,24
	ash 1,-24
	popj 17,

lv_short16:
	hlrz 1,vs_short16
	lsh 1,24
	ash 1,-24
	popj 17,

sv_short16:
	lsh 1,24
	ash 1,-24
	movem 1,vs_short16
	popj 17,

lst_short16:
	move 1,st_short16
	ash 1,-24
	popj 17,

lsy_short16:
	move 1,st_short16
	lsh 1,20
	ash 1,-24
	popj 17,

sst_short16:
	lsh 1,24
	ash 1,-24
	dpb 1,[POINT 16,st_short16,15]
	popj 17,

sstr_short16:
	lsh 1,24
	ash 1,-24
	dpb 1,[POINT 16,st_short16,31]
	lsh 1,24
	ash 1,-24
	popj 17,

lvs_short16:
	move 1,vst_short16
	ash 1,-24
	popj 17,

svs_short16:
	lsh 1,24
	ash 1,-24
	dpb 1,[POINT 16,vst_short16,31]
	popj 17,

la_short16:
	move 1,a_short16
	ash 1,-24
	popj 17,

sa_short16:
	lsh 1,24
	ash 1,-24
	dpb 1,[POINT 16,a_short16,15]
	popj 17,

lai_short16:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_short16,17]
	jumpe 4,%L1159
%L1158:
	ibp 3
	sojn 4,%L1158	; decrement_and_branch_until_zero
%L1159:
	move 1,(3)
	ash 1,-24
	popj 17,

sai_short16:
	lsh 2,24
	ash 2,-24
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_short16,17]
	jumpe 4,%L1162
%L1161:
	ibp 3
	sojn 4,%L1161	; decrement_and_branch_until_zero
%L1162:
	dpb 2,3	; movhi
	popj 17,

lvi_short16:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,va_short16,17]
	jumpe 4,%L1165
%L1164:
	ibp 1
	sojn 4,%L1164	; decrement_and_branch_until_zero
%L1165:
	ldb 1,1
	lsh 1,22
	ash 1,-24
	popj 17,

svi_short16:
	lsh 2,24
	ash 2,-24
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,va_short16,17]
	jumpe 4,%L1168
%L1167:
	ibp 3
	sojn 4,%L1167	; decrement_and_branch_until_zero
%L1168:
	dpb 2,3	; movhi
	popj 17,

lp_short16:
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

sp_short16:
	lsh 2,24
	ash 2,-24
	dpb 2,1	; movhi
	popj 17,

spr_short16:
	lsh 2,24
	ash 2,-24
	dpb 2,1	; movhi
	lsh 2,24
	ash 2,-24
	move 1,2
	popj 17,

lpi_short16:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1175
%L1174:
	ibp 1
	sojn 4,%L1174	; decrement_and_branch_until_zero
%L1175:
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

spi_short16:
	lsh 3,24
	ash 3,-24
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1179
%L1178:
	ibp 1
	sojn 4,%L1178	; decrement_and_branch_until_zero
%L1179:
	dpb 3,1	; movhi
	popj 17,

lgp_short16:
	ldb 1,ps_short16
	lsh 1,24
	ash 1,-24
	popj 17,

lgap_short16:
	ldb 1,pa_short16
	lsh 1,24
	ash 1,-24
	popj 17,

lgvp_short16:
	ldb 1,vps_short16
	lsh 1,24
	ash 1,-24
	popj 17,

sgp_short16:
	lsh 1,24
	ash 1,-24
	dpb 1,ps_short16	; movhi
	popj 17,

prp_short16:
	ibp 1
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

pip_short16:
	ldb 4,1
	lsh 4,24
	ash 4,-24
	ibp 1
	ldb 1,1
	add 4,1
	lsh 4,24
	ash 4,-24
	move 1,4
	popj 17,

us_short16:
	lsh 1,24
	ash 1,-24
	hlrz 6,s_short16
	add 1,6
	movem 1,s_short16
	lsh 1,24
	ash 1,-24
	popj 17,

ust_short16:
	lsh 1,24
	ash 1,-24
	move 4,st_short16
	ash 4,-24
	add 4,1
	dpb 4,[POINT 16,st_short16,15]
	move 4,st_short16
	lsh 4,20
	ash 4,-24
	sub 4,1
	dpb 4,[POINT 16,st_short16,31]
	move 1,st_short16
	ash 1,-24
	move 4,st_short16
	lsh 4,20
	ash 4,-24
	add 1,4
	lsh 1,24
	ash 1,-24
	popj 17,

use_short16:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	lsh 11,24
	ash 11,-24
	andi 12,7
	move 13,11
	lsh 13,24
	ash 13,-24
	move 1,13
	pushj 17,ss_short16
	move 1,11
	addi 1,1
	lsh 1,24
	ash 1,-24
	pushj 17,sv_short16
	move 1,11
	addi 1,2
	lsh 1,24
	ash 1,-24
	pushj 17,sst_short16
	move 1,11
	addi 1,3
	lsh 1,24
	ash 1,-24
	pushj 17,svs_short16
	move 1,11
	addi 1,4
	lsh 1,24
	ash 1,-24
	pushj 17,sa_short16
	move 2,11
	addi 2,5
	lsh 2,24
	ash 2,-24
	move 1,12
	pushj 17,sai_short16
	move 2,11
	addi 2,6
	lsh 2,24
	ash 2,-24
	move 1,12
	pushj 17,svi_short16
	move 2,11
	addi 2,7
	lsh 2,24
	ash 2,-24
	move 1,[POINT 18,a_short16,35]
	pushj 17,sp_short16
	move 3,11
	addi 3,10
	lsh 3,24
	ash 3,-24
	move 1,[POINT 18,a_short16,17]
	move 2,12
	pushj 17,spi_short16
	move 1,11
	addi 1,11
	lsh 1,24
	ash 1,-24
	pushj 17,sgp_short16
	move 1,13
	pushj 17,ssr_short16
	move 10,1
	lsh 10,24
	ash 10,-24
	move 1,11
	addi 1,12
	lsh 1,24
	ash 1,-24
	pushj 17,sstr_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	addi 11,13
	lsh 11,24
	ash 11,-24
	move 1,[POINT 18,a_short16+1,17]
	move 2,11
	pushj 17,spr_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	pushj 17,ls_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	pushj 17,lv_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	pushj 17,lst_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	pushj 17,lsy_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	pushj 17,lvs_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	pushj 17,la_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	move 1,12
	pushj 17,lai_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	move 1,12
	pushj 17,lvi_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	move 1,[POINT 18,a_short16,35]
	pushj 17,lp_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	move 1,[POINT 18,a_short16,17]
	move 2,12
	pushj 17,lpi_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	pushj 17,lgp_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	pushj 17,lgap_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	pushj 17,lgvp_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	move 1,[POINT 18,a_short16,17]
	pushj 17,prp_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	move 1,[POINT 18,a_short16,17]
	pushj 17,pip_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	move 1,13
	pushj 17,us_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	move 1,13
	pushj 17,ust_short16
	add 10,1
	lsh 10,24
	ash 10,-24
	lsh 10,24
	ash 10,-24
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_ushort16:
	.long	s_ushort16+301989888
	.align	2
pa_ushort16:
	.long	a_ushort16+301989889
	.align	2
vps_ushort16:
	.long	vs_ushort16+301989888

ls_ushort16:
	hlrz 1,s_ushort16
	andi 1,177777
	popj 17,

ss_ushort16:
	andi 1,177777
	movem 1,s_ushort16
	popj 17,

ssr_ushort16:
	andi 1,177777
	movem 1,s_ushort16
	andi 1,177777
	popj 17,

lv_ushort16:
	hlrz 1,vs_ushort16
	andi 1,177777
	popj 17,

sv_ushort16:
	andi 1,177777
	movem 1,vs_ushort16
	popj 17,

lst_ushort16:
	move 1,st_ushort16
	lsh 1,-24
	popj 17,

lsy_ushort16:
	move 1,st_ushort16
	lsh 1,-4
	andi 1,177777
	popj 17,

sst_ushort16:
	andi 1,177777
	dpb 1,[POINT 16,st_ushort16,15]
	popj 17,

sstr_ushort16:
	andi 1,177777
	dpb 1,[POINT 16,st_ushort16,31]
	andi 1,177777
	popj 17,

lvs_ushort16:
	move 1,vst_ushort16
	lsh 1,-24
	popj 17,

svs_ushort16:
	andi 1,177777
	dpb 1,[POINT 16,vst_ushort16,31]
	popj 17,

la_ushort16:
	move 1,a_ushort16
	lsh 1,-24
	popj 17,

sa_ushort16:
	andi 1,177777
	dpb 1,[POINT 16,a_ushort16,15]
	popj 17,

lai_ushort16:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,a_ushort16,17]
	jumpe 4,%L1221
%L1220:
	ibp 1
	sojn 4,%L1220	; decrement_and_branch_until_zero
%L1221:
	move 1,(1)
	lsh 1,-24
	popj 17,

sai_ushort16:
	andi 2,177777
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_ushort16,17]
	jumpe 4,%L1224
%L1223:
	ibp 3
	sojn 4,%L1223	; decrement_and_branch_until_zero
%L1224:
	dpb 2,3	; movhi
	popj 17,

lvi_ushort16:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,va_ushort16,17]
	jumpe 4,%L1227
%L1226:
	ibp 1
	sojn 4,%L1226	; decrement_and_branch_until_zero
%L1227:
	move 1,(1)
	lsh 1,-24
	popj 17,

svi_ushort16:
	andi 2,177777
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,va_ushort16,17]
	jumpe 4,%L1230
%L1229:
	ibp 3
	sojn 4,%L1229	; decrement_and_branch_until_zero
%L1230:
	dpb 2,3	; movhi
	popj 17,

lp_ushort16:
	ldb 1,1
	andi 1,177777
	popj 17,

sp_ushort16:
	andi 2,177777
	dpb 2,1	; movhi
	popj 17,

spr_ushort16:
	andi 2,177777
	dpb 2,1	; movhi
	andi 2,177777
	move 1,2
	popj 17,

lpi_ushort16:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1237
%L1236:
	ibp 1
	sojn 4,%L1236	; decrement_and_branch_until_zero
%L1237:
	ldb 1,1
	andi 1,177777
	popj 17,

spi_ushort16:
	andi 3,177777
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1241
%L1240:
	ibp 1
	sojn 4,%L1240	; decrement_and_branch_until_zero
%L1241:
	dpb 3,1	; movhi
	popj 17,

lgp_ushort16:
	ldb 1,ps_ushort16
	andi 1,177777
	popj 17,

lgap_ushort16:
	ldb 1,pa_ushort16
	andi 1,177777
	popj 17,

lgvp_ushort16:
	ldb 1,vps_ushort16
	andi 1,177777
	popj 17,

sgp_ushort16:
	andi 1,177777
	dpb 1,ps_ushort16	; movhi
	popj 17,

prp_ushort16:
	ibp 1
	ldb 1,1
	andi 1,177777
	popj 17,

pip_ushort16:
	ldb 4,1
	andi 4,177777
	ibp 1
	ldb 1,1
	add 4,1
	andi 4,177777
	move 1,4
	popj 17,

us_ushort16:
	andi 1,177777
	hlrz 6,s_ushort16
	add 1,6
	movem 1,s_ushort16
	andi 1,177777
	popj 17,

ust_ushort16:
	andi 1,177777
	move 4,st_ushort16
	lsh 4,-24
	add 4,1
	dpb 4,[POINT 16,st_ushort16,15]
	move 4,st_ushort16
	lsh 4,-4
	andi 4,177777
	sub 4,1
	dpb 4,[POINT 16,st_ushort16,31]
	move 1,st_ushort16
	lsh 1,-24
	move 4,st_ushort16
	lsh 4,-4
	andi 4,177777
	add 1,4
	andi 1,177777
	popj 17,

use_ushort16:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	andi 11,177777
	andi 12,7
	move 13,11
	andi 13,177777
	move 1,13
	pushj 17,ss_ushort16
	move 1,11
	addi 1,1
	andi 1,177777
	pushj 17,sv_ushort16
	move 1,11
	addi 1,2
	andi 1,177777
	pushj 17,sst_ushort16
	move 1,11
	addi 1,3
	andi 1,177777
	pushj 17,svs_ushort16
	move 1,11
	addi 1,4
	andi 1,177777
	pushj 17,sa_ushort16
	move 2,11
	addi 2,5
	andi 2,177777
	move 1,12
	pushj 17,sai_ushort16
	move 2,11
	addi 2,6
	andi 2,177777
	move 1,12
	pushj 17,svi_ushort16
	move 2,11
	addi 2,7
	andi 2,177777
	move 1,[POINT 18,a_ushort16,35]
	pushj 17,sp_ushort16
	move 3,11
	addi 3,10
	andi 3,177777
	move 1,[POINT 18,a_ushort16,17]
	move 2,12
	pushj 17,spi_ushort16
	move 1,11
	addi 1,11
	andi 1,177777
	pushj 17,sgp_ushort16
	move 1,13
	pushj 17,ssr_ushort16
	move 10,1
	andi 10,177777
	move 1,11
	addi 1,12
	andi 1,177777
	pushj 17,sstr_ushort16
	add 10,1
	andi 10,177777
	addi 11,13
	andi 11,177777
	move 1,[POINT 18,a_ushort16+1,17]
	move 2,11
	pushj 17,spr_ushort16
	add 10,1
	andi 10,177777
	pushj 17,ls_ushort16
	add 10,1
	andi 10,177777
	pushj 17,lv_ushort16
	add 10,1
	andi 10,177777
	pushj 17,lst_ushort16
	add 10,1
	andi 10,177777
	pushj 17,lsy_ushort16
	add 10,1
	andi 10,177777
	pushj 17,lvs_ushort16
	add 10,1
	andi 10,177777
	pushj 17,la_ushort16
	add 10,1
	andi 10,177777
	move 1,12
	pushj 17,lai_ushort16
	add 10,1
	andi 10,177777
	move 1,12
	pushj 17,lvi_ushort16
	add 10,1
	andi 10,177777
	move 1,[POINT 18,a_ushort16,35]
	pushj 17,lp_ushort16
	add 10,1
	andi 10,177777
	move 1,[POINT 18,a_ushort16,17]
	move 2,12
	pushj 17,lpi_ushort16
	add 10,1
	andi 10,177777
	pushj 17,lgp_ushort16
	add 10,1
	andi 10,177777
	pushj 17,lgap_ushort16
	add 10,1
	andi 10,177777
	pushj 17,lgvp_ushort16
	add 10,1
	andi 10,177777
	move 1,[POINT 18,a_ushort16,17]
	pushj 17,prp_ushort16
	add 10,1
	andi 10,177777
	move 1,[POINT 18,a_ushort16,17]
	pushj 17,pip_ushort16
	add 10,1
	andi 10,177777
	move 1,13
	pushj 17,us_ushort16
	add 10,1
	andi 10,177777
	move 1,13
	pushj 17,ust_ushort16
	add 10,1
	andi 10,177777
	andi 10,177777
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_short18:
	.long	s_short18+301989888
	.align	2
pa_short18:
	.long	a_short18+301989889
	.align	2
vps_short18:
	.long	vs_short18+301989888

ls_short18:
	hrre 1,s_short18
	popj 17,

ss_short18:
	movem 1,s_short18
	popj 17,

ssr_short18:
	movem 1,s_short18
	hrre 1,1
	popj 17,

lv_short18:
	hrre 1,vs_short18
	popj 17,

sv_short18:
	movem 1,vs_short18
	popj 17,

lst_short18:
	hlre 1,st_short18
	popj 17,

lsy_short18:
	hrre 1,st_short18
	popj 17,

sst_short18:
	hrlm 1,st_short18
	popj 17,

sstr_short18:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,st_short18
	hrre 1,1	; extendhisi2
	popj 17,

lvs_short18:
	hlrz 1,vst_short18
	hrre 1,1
	popj 17,

svs_short18:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,vst_short18
	popj 17,

la_short18:
	hlre 1,a_short18
	popj 17,

sa_short18:
	hrlm 1,a_short18
	popj 17,

lai_short18:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_short18,17]
	jumpe 4,%L1283
%L1282:
	ibp 3
	sojn 4,%L1282	; decrement_and_branch_until_zero
%L1283:
	ldb 1,3
	hrre 1,1
	popj 17,

sai_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_short18,17]
	jumpe 4,%L1286
%L1285:
	ibp 3
	sojn 4,%L1285	; decrement_and_branch_until_zero
%L1286:
	dpb 2,3	; movhi
	popj 17,

lvi_short18:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,va_short18,17]
	jumpe 4,%L1289
%L1288:
	ibp 3
	sojn 4,%L1288	; decrement_and_branch_until_zero
%L1289:
	ldb 1,3
	hrre 1,1
	popj 17,

svi_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,va_short18,17]
	jumpe 4,%L1292
%L1291:
	ibp 3
	sojn 4,%L1291	; decrement_and_branch_until_zero
%L1292:
	dpb 2,3	; movhi
	popj 17,

lp_short18:
	ldb 1,1
	hrre 1,1
	popj 17,

sp_short18:
	dpb 2,1	; movhi
	popj 17,

spr_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	hrre 2,2
	move 1,2
	popj 17,

lpi_short18:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1299
%L1298:
	ibp 1
	sojn 4,%L1298	; decrement_and_branch_until_zero
%L1299:
	ldb 1,1
	hrre 1,1
	popj 17,

spi_short18:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1303
%L1302:
	ibp 1
	sojn 4,%L1302	; decrement_and_branch_until_zero
%L1303:
	dpb 3,1	; movhi
	popj 17,

lgp_short18:
	ldb 1,ps_short18
	hrre 1,1
	popj 17,

lgap_short18:
	ldb 1,pa_short18
	hrre 1,1
	popj 17,

lgvp_short18:
	ldb 1,vps_short18
	hrre 1,1
	popj 17,

sgp_short18:
	dpb 1,ps_short18	; movhi
	popj 17,

prp_short18:
	ibp 1
	ldb 1,1
	hrre 1,1
	popj 17,

pip_short18:
	ldb 4,1
	ibp 1
	ldb 1,1
	add 4,1
	hrre 4,4	; extendhisi2
	move 1,4
	popj 17,

us_short18:
	hlrz 6,s_short18
	addi 6,(1)
	movem 6,s_short18
	hrre 1,6
	popj 17,

ust_short18:
	hrrzi 1,(1)	; zero_extendhisi2
	hlrz 4,st_short18
	add 4,1
	hrlm 4,st_short18
	hrrz 4,st_short18
	sub 4,1
	hrrm 4,st_short18
	hlrz 1,st_short18
	hrrz 4,st_short18
	add 1,4
	hrre 1,1	; extendhisi2
	popj 17,

use_short18:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	hrrzi 10,(10)	; zero_extendhisi2
	andi 11,7
	hrre 12,10	; extendhisi2
	move 1,12
	pushj 17,ss_short18
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sv_short18
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sst_short18
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,svs_short18
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sa_short18
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,11
	pushj 17,sai_short18
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,11
	pushj 17,svi_short18
	addi 10,1
	hrre 2,10	; extendhisi2
	move 1,[POINT 18,a_short18,35]
	pushj 17,sp_short18
	addi 10,1
	hrre 3,10	; extendhisi2
	move 1,[POINT 18,a_short18,17]
	move 2,11
	pushj 17,spi_short18
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sgp_short18
	move 1,12
	pushj 17,ssr_short18
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	addi 10,1
	hrre 1,10	; extendhisi2
	pushj 17,sstr_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	addi 10,1
	hrre 10,10	; extendhisi2
	move 1,[POINT 18,a_short18+1,17]
	move 2,10
	pushj 17,spr_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,ls_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lv_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lst_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lsy_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lvs_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,la_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,11
	pushj 17,lai_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,11
	pushj 17,lvi_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,[POINT 18,a_short18,35]
	pushj 17,lp_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,[POINT 18,a_short18,17]
	move 2,11
	pushj 17,lpi_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lgp_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lgap_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	pushj 17,lgvp_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,[POINT 18,a_short18,17]
	pushj 17,prp_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,[POINT 18,a_short18,17]
	pushj 17,pip_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,12
	pushj 17,us_short18
	add 1,13
	move 13,1
	hrrzi 13,(13)	; zero_extendhisi2
	move 1,12
	pushj 17,ust_short18
	add 13,1
	hrre 1,13
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.data
	.align	2
ps_ushort18:
	.long	s_ushort18+301989888
	.align	2
pa_ushort18:
	.long	a_ushort18+301989889
	.align	2
vps_ushort18:
	.long	vs_ushort18+301989888

ls_ushort18:
	move 1,s_ushort18
	popj 17,

ss_ushort18:
	movem 1,s_ushort18
	popj 17,

ssr_ushort18:
	movem 1,s_ushort18
	popj 17,

lv_ushort18:
	move 1,vs_ushort18
	popj 17,

sv_ushort18:
	movem 1,vs_ushort18
	popj 17,

lst_ushort18:
	hlrz 1,st_ushort18
	popj 17,

lsy_ushort18:
	hrrz 1,st_ushort18
	popj 17,

sst_ushort18:
	hrlm 1,st_ushort18
	popj 17,

sstr_ushort18:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,st_ushort18
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

lvs_ushort18:
	hlrz 1,vst_ushort18
	popj 17,

svs_ushort18:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrm 1,vst_ushort18
	popj 17,

la_ushort18:
	hlrz 1,a_ushort18
	popj 17,

sa_ushort18:
	hrlm 1,a_ushort18
	popj 17,

lai_ushort18:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_ushort18,17]
	jumpe 4,%L1345
%L1344:
	ibp 3
	sojn 4,%L1344	; decrement_and_branch_until_zero
%L1345:
	ldb 1,3
	popj 17,

sai_ushort18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,a_ushort18,17]
	jumpe 4,%L1348
%L1347:
	ibp 3
	sojn 4,%L1347	; decrement_and_branch_until_zero
%L1348:
	dpb 2,3	; movhi
	popj 17,

lvi_ushort18:
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,va_ushort18,17]
	jumpe 4,%L1351
%L1350:
	ibp 1
	sojn 4,%L1350	; decrement_and_branch_until_zero
%L1351:
	ldb 1,1
	popj 17,

svi_ushort18:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,va_ushort18,17]
	jumpe 4,%L1354
%L1353:
	ibp 3
	sojn 4,%L1353	; decrement_and_branch_until_zero
%L1354:
	dpb 2,3	; movhi
	popj 17,

lp_ushort18:
	ldb 1,1
	popj 17,

sp_ushort18:
	dpb 2,1	; movhi
	popj 17,

spr_ushort18:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	move 1,2
	popj 17,

lpi_ushort18:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1361
%L1360:
	ibp 1
	sojn 4,%L1360	; decrement_and_branch_until_zero
%L1361:
	ldb 1,1
	popj 17,

spi_ushort18:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1365
%L1364:
	ibp 1
	sojn 4,%L1364	; decrement_and_branch_until_zero
%L1365:
	dpb 3,1	; movhi
	popj 17,

lgp_ushort18:
	ldb 1,ps_ushort18
	popj 17,

lgap_ushort18:
	ldb 1,pa_ushort18
	popj 17,

lgvp_ushort18:
	ldb 1,vps_ushort18
	popj 17,

sgp_ushort18:
	dpb 1,ps_ushort18	; movhi
	popj 17,

prp_ushort18:
	ibp 1
	ldb 1,1
	popj 17,

pip_ushort18:
	ldb 4,1
	ibp 1
	ldb 1,1
	add 4,1
	hrrzi 4,(4)	; zero_extendhisi2
	move 1,4
	popj 17,

us_ushort18:
	hlrz 6,s_ushort18
	addi 6,(1)
	movem 6,s_ushort18
	hrrz 1,6
	popj 17,

ust_ushort18:
	hrrzi 1,(1)	; zero_extendhisi2
	hlrz 4,st_ushort18
	add 4,1
	hrlm 4,st_ushort18
	hrrz 4,st_ushort18
	sub 4,1
	hrrm 4,st_ushort18
	hlrz 1,st_ushort18
	hrrz 4,st_ushort18
	add 1,4
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

use_ushort18:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	hrrzi 10,(10)	; zero_extendhisi2
	andi 11,7
	move 1,10
	pushj 17,ss_ushort18
	movei 1,1(10)
	pushj 17,sv_ushort18
	movei 1,2(10)
	pushj 17,sst_ushort18
	movei 1,3(10)
	pushj 17,svs_ushort18
	movei 1,4(10)
	pushj 17,sa_ushort18
	movei 2,5(10)
	move 1,11
	pushj 17,sai_ushort18
	movei 2,6(10)
	move 1,11
	pushj 17,svi_ushort18
	movei 2,7(10)
	move 1,[POINT 18,a_ushort18,35]
	pushj 17,sp_ushort18
	movei 3,10(10)
	move 1,[POINT 18,a_ushort18,17]
	move 2,11
	pushj 17,spi_ushort18
	movei 1,11(10)
	pushj 17,sgp_ushort18
	move 1,10
	pushj 17,ssr_ushort18
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	movei 1,12(10)
	pushj 17,sstr_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	movei 2,13(10)
	move 1,[POINT 18,a_ushort18+1,17]
	pushj 17,spr_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,ls_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lv_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lst_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lsy_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lvs_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,la_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,11
	pushj 17,lai_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,11
	pushj 17,lvi_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,[POINT 18,a_ushort18,35]
	pushj 17,lp_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,[POINT 18,a_ushort18,17]
	move 2,11
	pushj 17,lpi_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lgp_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lgap_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	pushj 17,lgvp_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,[POINT 18,a_ushort18,17]
	pushj 17,prp_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,[POINT 18,a_ushort18,17]
	pushj 17,pip_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,10
	pushj 17,us_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,10
	pushj 17,ust_ushort18
	add 1,12
	move 12,1
	hrrzi 12,(12)	; zero_extendhisi2
	move 1,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_int32:
	.long	s_int32
	.align	2
pa_int32:
	.long	a_int32+3
	.align	2
vps_int32:
	.long	vs_int32

ls_int32:
	move 1,s_int32
	popj 17,

ss_int32:
	movem 1,s_int32
	popj 17,

ssr_int32:
	movem 1,s_int32
	popj 17,

lv_int32:
	move 1,vs_int32
	popj 17,

sv_int32:
	movem 1,vs_int32
	popj 17,

lst_int32:
	move 1,st_int32
	ash 1,-4
	popj 17,

lsy_int32:
	move 1,st_int32+1
	ash 1,-4
	popj 17,

sst_int32:
	lsh 1,4
	movem 1,st_int32
	popj 17,

sstr_int32:
	dpb 1,[POINT 32,st_int32+1,31]
	lsh 1,4
	ash 1,-4
	popj 17,

lvs_int32:
	move 1,vst_int32
	ash 1,-4
	popj 17,

svs_int32:
	dpb 1,[POINT 32,vst_int32+1,31]
	popj 17,

la_int32:
	move 1,a_int32
	ash 1,-4
	popj 17,

sa_int32:
	dpb 1,[POINT 32,a_int32,31]
	popj 17,

lai_int32:
	move 1,a_int32(1)
	ash 1,-4
	popj 17,

sai_int32:
	movei 4,a_int32
	jumple 1,%L1409
%L1408:
	ibp 4
	sojg 1,%L1408	; decrement_and_branch_until_zero
%L1409:
	jumpe 1,%L1411
%L1410:
	subi 4,1
	aojl 1,%L1410
%L1411:
	dpb 2,[POINT 32,(4),31]
	popj 17,

lvi_int32:
	move 1,va_int32(1)
	ash 1,-4
	popj 17,

svi_int32:
	movei 4,va_int32
	jumple 1,%L1416
%L1415:
	ibp 4
	sojg 1,%L1415	; decrement_and_branch_until_zero
%L1416:
	jumpe 1,%L1418
%L1417:
	subi 4,1
	aojl 1,%L1417
%L1418:
	dpb 2,[POINT 32,(4),31]
	popj 17,

lp_int32:
	move 1,(1)
	popj 17,

sp_int32:
	movem 2,(1)
	popj 17,

spr_int32:
	movem 2,(1)
	move 1,2
	popj 17,

lpi_int32:
	add 1,2
	move 1,(1)
	popj 17,

spi_int32:
	add 1,2
	movem 3,(1)
	popj 17,

lgp_int32:
	move 4,ps_int32
	move 1,(4)
	popj 17,

lgap_int32:
	move 4,pa_int32
	move 1,(4)
	popj 17,

lgvp_int32:
	move 4,vps_int32
	move 1,(4)
	popj 17,

sgp_int32:
	move 4,ps_int32
	movem 1,(4)
	popj 17,

prp_int32:
	move 1,1(1)
	popj 17,

pip_int32:
	move 6,(1)
	add 6,1(1)
	move 1,6
	popj 17,

us_int32:
	addb 1,s_int32
	popj 17,

ust_int32:
	move 4,st_int32
	ash 4,-4
	add 4,1
	lsh 4,4
	movem 4,st_int32
	move 4,st_int32+1
	ash 4,-4
	sub 4,1
	dpb 4,[POINT 32,st_int32+1,31]
	move 1,st_int32
	ash 1,-4
	move 4,st_int32+1
	ash 4,-4
	add 1,4
	popj 17,

use_int32:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	andi 12,7
	pushj 17,ss_int32
	move 1,11
	addi 1,1
	pushj 17,sv_int32
	move 1,11
	addi 1,2
	pushj 17,sst_int32
	move 1,11
	addi 1,3
	pushj 17,svs_int32
	move 1,11
	addi 1,4
	pushj 17,sa_int32
	move 2,11
	addi 2,5
	move 1,12
	pushj 17,sai_int32
	move 2,11
	addi 2,6
	move 1,12
	pushj 17,svi_int32
	move 2,11
	addi 2,7
	movei 1,a_int32+1
	pushj 17,sp_int32
	move 3,11
	addi 3,10
	movei 1,a_int32
	move 2,12
	pushj 17,spi_int32
	move 1,11
	addi 1,11
	pushj 17,sgp_int32
	move 1,11
	pushj 17,ssr_int32
	move 10,1
	move 1,11
	addi 1,12
	pushj 17,sstr_int32
	add 10,1
	move 2,11
	addi 2,13
	movei 1,a_int32+2
	pushj 17,spr_int32
	add 10,1
	pushj 17,ls_int32
	add 10,1
	pushj 17,lv_int32
	add 10,1
	pushj 17,lst_int32
	add 10,1
	pushj 17,lsy_int32
	add 10,1
	pushj 17,lvs_int32
	add 10,1
	pushj 17,la_int32
	add 10,1
	move 1,12
	pushj 17,lai_int32
	add 10,1
	move 1,12
	pushj 17,lvi_int32
	add 10,1
	movei 1,a_int32+1
	pushj 17,lp_int32
	add 10,1
	movei 1,a_int32
	move 2,12
	pushj 17,lpi_int32
	add 10,1
	pushj 17,lgp_int32
	add 10,1
	pushj 17,lgap_int32
	add 10,1
	pushj 17,lgvp_int32
	add 10,1
	movei 1,a_int32
	pushj 17,prp_int32
	add 10,1
	movei 1,a_int32
	pushj 17,pip_int32
	add 10,1
	move 1,11
	pushj 17,us_int32
	add 10,1
	move 1,11
	pushj 17,ust_int32
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_uint32:
	.long	s_uint32
	.align	2
pa_uint32:
	.long	a_uint32+3
	.align	2
vps_uint32:
	.long	vs_uint32

ls_uint32:
	move 1,s_uint32
	popj 17,

ss_uint32:
	movem 1,s_uint32
	popj 17,

ssr_uint32:
	movem 1,s_uint32
	popj 17,

lv_uint32:
	move 1,vs_uint32
	popj 17,

sv_uint32:
	movem 1,vs_uint32
	popj 17,

lst_uint32:
	move 1,st_uint32
	lsh 1,-4
	popj 17,

lsy_uint32:
	move 1,st_uint32+1
	lsh 1,-4
	popj 17,

sst_uint32:
	lsh 1,4
	movem 1,st_uint32
	popj 17,

sstr_uint32:
	dpb 1,[POINT 32,st_uint32+1,31]
	tlz 1,740000
	popj 17,

lvs_uint32:
	move 1,vst_uint32
	lsh 1,-4
	popj 17,

svs_uint32:
	dpb 1,[POINT 32,vst_uint32+1,31]
	popj 17,

la_uint32:
	move 1,a_uint32
	lsh 1,-4
	popj 17,

sa_uint32:
	dpb 1,[POINT 32,a_uint32,31]
	popj 17,

lai_uint32:
	move 1,a_uint32(1)
	lsh 1,-4
	popj 17,

sai_uint32:
	movei 4,a_uint32
	jumple 1,%L1469
%L1468:
	ibp 4
	sojg 1,%L1468	; decrement_and_branch_until_zero
%L1469:
	jumpe 1,%L1471
%L1470:
	subi 4,1
	aojl 1,%L1470
%L1471:
	dpb 2,[POINT 32,(4),31]
	popj 17,

lvi_uint32:
	move 1,va_uint32(1)
	lsh 1,-4
	popj 17,

svi_uint32:
	movei 4,va_uint32
	jumple 1,%L1476
%L1475:
	ibp 4
	sojg 1,%L1475	; decrement_and_branch_until_zero
%L1476:
	jumpe 1,%L1478
%L1477:
	subi 4,1
	aojl 1,%L1477
%L1478:
	dpb 2,[POINT 32,(4),31]
	popj 17,

lp_uint32:
	move 1,(1)
	popj 17,

sp_uint32:
	movem 2,(1)
	popj 17,

spr_uint32:
	movem 2,(1)
	move 1,2
	popj 17,

lpi_uint32:
	add 1,2
	move 1,(1)
	popj 17,

spi_uint32:
	add 1,2
	movem 3,(1)
	popj 17,

lgp_uint32:
	move 4,ps_uint32
	move 1,(4)
	popj 17,

lgap_uint32:
	move 4,pa_uint32
	move 1,(4)
	popj 17,

lgvp_uint32:
	move 4,vps_uint32
	move 1,(4)
	popj 17,

sgp_uint32:
	move 4,ps_uint32
	movem 1,(4)
	popj 17,

prp_uint32:
	move 1,1(1)
	popj 17,

pip_uint32:
	move 6,(1)
	add 6,1(1)
	move 1,6
	popj 17,

us_uint32:
	addb 1,s_uint32
	popj 17,

ust_uint32:
	move 4,st_uint32
	lsh 4,-4
	add 4,1
	lsh 4,4
	movem 4,st_uint32
	move 4,st_uint32+1
	lsh 4,-4
	sub 4,1
	dpb 4,[POINT 32,st_uint32+1,31]
	move 1,st_uint32
	lsh 1,-4
	move 4,st_uint32+1
	lsh 4,-4
	add 1,4
	popj 17,

use_uint32:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	andi 12,7
	pushj 17,ss_uint32
	move 1,11
	addi 1,1
	pushj 17,sv_uint32
	move 1,11
	addi 1,2
	pushj 17,sst_uint32
	move 1,11
	addi 1,3
	pushj 17,svs_uint32
	move 1,11
	addi 1,4
	pushj 17,sa_uint32
	move 2,11
	addi 2,5
	move 1,12
	pushj 17,sai_uint32
	move 2,11
	addi 2,6
	move 1,12
	pushj 17,svi_uint32
	move 2,11
	addi 2,7
	movei 1,a_uint32+1
	pushj 17,sp_uint32
	move 3,11
	addi 3,10
	movei 1,a_uint32
	move 2,12
	pushj 17,spi_uint32
	move 1,11
	addi 1,11
	pushj 17,sgp_uint32
	move 1,11
	pushj 17,ssr_uint32
	move 10,1
	move 1,11
	addi 1,12
	pushj 17,sstr_uint32
	add 10,1
	move 2,11
	addi 2,13
	movei 1,a_uint32+2
	pushj 17,spr_uint32
	add 10,1
	pushj 17,ls_uint32
	add 10,1
	pushj 17,lv_uint32
	add 10,1
	pushj 17,lst_uint32
	add 10,1
	pushj 17,lsy_uint32
	add 10,1
	pushj 17,lvs_uint32
	add 10,1
	pushj 17,la_uint32
	add 10,1
	move 1,12
	pushj 17,lai_uint32
	add 10,1
	move 1,12
	pushj 17,lvi_uint32
	add 10,1
	movei 1,a_uint32+1
	pushj 17,lp_uint32
	add 10,1
	movei 1,a_uint32
	move 2,12
	pushj 17,lpi_uint32
	add 10,1
	pushj 17,lgp_uint32
	add 10,1
	pushj 17,lgap_uint32
	add 10,1
	pushj 17,lgvp_uint32
	add 10,1
	movei 1,a_uint32
	pushj 17,prp_uint32
	add 10,1
	movei 1,a_uint32
	pushj 17,pip_uint32
	add 10,1
	move 1,11
	pushj 17,us_uint32
	add 10,1
	move 1,11
	pushj 17,ust_uint32
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_int36:
	.long	s_int36
	.align	2
pa_int36:
	.long	a_int36+3
	.align	2
vps_int36:
	.long	vs_int36

ls_int36:
	move 1,s_int36
	popj 17,

ss_int36:
	movem 1,s_int36
	popj 17,

ssr_int36:
	movem 1,s_int36
	popj 17,

lv_int36:
	move 1,vs_int36
	popj 17,

sv_int36:
	movem 1,vs_int36
	popj 17,

lst_int36:
	move 1,st_int36
	popj 17,

lsy_int36:
	move 1,st_int36+1
	popj 17,

sst_int36:
	movem 1,st_int36
	popj 17,

sstr_int36:
	movem 1,st_int36+1
	popj 17,

lvs_int36:
	move 1,vst_int36
	popj 17,

svs_int36:
	movem 1,vst_int36+1
	popj 17,

la_int36:
	move 1,a_int36
	popj 17,

sa_int36:
	movem 1,a_int36
	popj 17,

lai_int36:
	move 1,a_int36(1)
	popj 17,

sai_int36:
	movem 2,a_int36(1)
	popj 17,

lvi_int36:
	move 1,va_int36(1)
	popj 17,

svi_int36:
	movem 2,va_int36(1)
	popj 17,

lp_int36:
	move 1,(1)
	popj 17,

sp_int36:
	movem 2,(1)
	popj 17,

spr_int36:
	movem 2,(1)
	move 1,2
	popj 17,

lpi_int36:
	add 1,2
	move 1,(1)
	popj 17,

spi_int36:
	add 1,2
	movem 3,(1)
	popj 17,

lgp_int36:
	move 4,ps_int36
	move 1,(4)
	popj 17,

lgap_int36:
	move 4,pa_int36
	move 1,(4)
	popj 17,

lgvp_int36:
	move 4,vps_int36
	move 1,(4)
	popj 17,

sgp_int36:
	move 4,ps_int36
	movem 1,(4)
	popj 17,

prp_int36:
	move 1,1(1)
	popj 17,

pip_int36:
	move 6,(1)
	add 6,1(1)
	move 1,6
	popj 17,

us_int36:
	addb 1,s_int36
	popj 17,

ust_int36:
	move 3,1
	addb 3,st_int36
	move 4,st_int36+1
	sub 4,1
	movem 4,st_int36+1
	add 3,4
	move 1,3
	popj 17,

use_int36:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	andi 12,7
	pushj 17,ss_int36
	move 1,11
	addi 1,1
	pushj 17,sv_int36
	move 1,11
	addi 1,2
	pushj 17,sst_int36
	move 1,11
	addi 1,3
	pushj 17,svs_int36
	move 1,11
	addi 1,4
	pushj 17,sa_int36
	move 2,11
	addi 2,5
	move 1,12
	pushj 17,sai_int36
	move 2,11
	addi 2,6
	move 1,12
	pushj 17,svi_int36
	move 2,11
	addi 2,7
	movei 1,a_int36+1
	pushj 17,sp_int36
	move 3,11
	addi 3,10
	movei 1,a_int36
	move 2,12
	pushj 17,spi_int36
	move 1,11
	addi 1,11
	pushj 17,sgp_int36
	move 1,11
	pushj 17,ssr_int36
	move 10,1
	move 1,11
	addi 1,12
	pushj 17,sstr_int36
	add 10,1
	move 2,11
	addi 2,13
	movei 1,a_int36+2
	pushj 17,spr_int36
	add 10,1
	pushj 17,ls_int36
	add 10,1
	pushj 17,lv_int36
	add 10,1
	pushj 17,lst_int36
	add 10,1
	pushj 17,lsy_int36
	add 10,1
	pushj 17,lvs_int36
	add 10,1
	pushj 17,la_int36
	add 10,1
	move 1,12
	pushj 17,lai_int36
	add 10,1
	move 1,12
	pushj 17,lvi_int36
	add 10,1
	movei 1,a_int36+1
	pushj 17,lp_int36
	add 10,1
	movei 1,a_int36
	move 2,12
	pushj 17,lpi_int36
	add 10,1
	pushj 17,lgp_int36
	add 10,1
	pushj 17,lgap_int36
	add 10,1
	pushj 17,lgvp_int36
	add 10,1
	movei 1,a_int36
	pushj 17,prp_int36
	add 10,1
	movei 1,a_int36
	pushj 17,pip_int36
	add 10,1
	move 1,11
	pushj 17,us_int36
	add 10,1
	move 1,11
	pushj 17,ust_int36
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.data
	.align	2
ps_uint36:
	.long	s_uint36
	.align	2
pa_uint36:
	.long	a_uint36+3
	.align	2
vps_uint36:
	.long	vs_uint36

ls_uint36:
	move 1,s_uint36
	popj 17,

ss_uint36:
	movem 1,s_uint36
	popj 17,

ssr_uint36:
	movem 1,s_uint36
	popj 17,

lv_uint36:
	move 1,vs_uint36
	popj 17,

sv_uint36:
	movem 1,vs_uint36
	popj 17,

lst_uint36:
	move 1,st_uint36
	popj 17,

lsy_uint36:
	move 1,st_uint36+1
	popj 17,

sst_uint36:
	movem 1,st_uint36
	popj 17,

sstr_uint36:
	movem 1,st_uint36+1
	popj 17,

lvs_uint36:
	move 1,vst_uint36
	popj 17,

svs_uint36:
	movem 1,vst_uint36+1
	popj 17,

la_uint36:
	move 1,a_uint36
	popj 17,

sa_uint36:
	movem 1,a_uint36
	popj 17,

lai_uint36:
	move 1,a_uint36(1)
	popj 17,

sai_uint36:
	movem 2,a_uint36(1)
	popj 17,

lvi_uint36:
	move 1,va_uint36(1)
	popj 17,

svi_uint36:
	movem 2,va_uint36(1)
	popj 17,

lp_uint36:
	move 1,(1)
	popj 17,

sp_uint36:
	movem 2,(1)
	popj 17,

spr_uint36:
	movem 2,(1)
	move 1,2
	popj 17,

lpi_uint36:
	add 1,2
	move 1,(1)
	popj 17,

spi_uint36:
	add 1,2
	movem 3,(1)
	popj 17,

lgp_uint36:
	move 4,ps_uint36
	move 1,(4)
	popj 17,

lgap_uint36:
	move 4,pa_uint36
	move 1,(4)
	popj 17,

lgvp_uint36:
	move 4,vps_uint36
	move 1,(4)
	popj 17,

sgp_uint36:
	move 4,ps_uint36
	movem 1,(4)
	popj 17,

prp_uint36:
	move 1,1(1)
	popj 17,

pip_uint36:
	move 6,(1)
	add 6,1(1)
	move 1,6
	popj 17,

us_uint36:
	addb 1,s_uint36
	popj 17,

ust_uint36:
	move 3,1
	addb 3,st_uint36
	move 4,st_uint36+1
	sub 4,1
	movem 4,st_uint36+1
	add 3,4
	move 1,3
	popj 17,

use_uint36:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	andi 12,7
	pushj 17,ss_uint36
	move 1,11
	addi 1,1
	pushj 17,sv_uint36
	move 1,11
	addi 1,2
	pushj 17,sst_uint36
	move 1,11
	addi 1,3
	pushj 17,svs_uint36
	move 1,11
	addi 1,4
	pushj 17,sa_uint36
	move 2,11
	addi 2,5
	move 1,12
	pushj 17,sai_uint36
	move 2,11
	addi 2,6
	move 1,12
	pushj 17,svi_uint36
	move 2,11
	addi 2,7
	movei 1,a_uint36+1
	pushj 17,sp_uint36
	move 3,11
	addi 3,10
	movei 1,a_uint36
	move 2,12
	pushj 17,spi_uint36
	move 1,11
	addi 1,11
	pushj 17,sgp_uint36
	move 1,11
	pushj 17,ssr_uint36
	move 10,1
	move 1,11
	addi 1,12
	pushj 17,sstr_uint36
	add 10,1
	move 2,11
	addi 2,13
	movei 1,a_uint36+2
	pushj 17,spr_uint36
	add 10,1
	pushj 17,ls_uint36
	add 10,1
	pushj 17,lv_uint36
	add 10,1
	pushj 17,lst_uint36
	add 10,1
	pushj 17,lsy_uint36
	add 10,1
	pushj 17,lvs_uint36
	add 10,1
	pushj 17,la_uint36
	add 10,1
	move 1,12
	pushj 17,lai_uint36
	add 10,1
	move 1,12
	pushj 17,lvi_uint36
	add 10,1
	movei 1,a_uint36+1
	pushj 17,lp_uint36
	add 10,1
	movei 1,a_uint36
	move 2,12
	pushj 17,lpi_uint36
	add 10,1
	pushj 17,lgp_uint36
	add 10,1
	pushj 17,lgap_uint36
	add 10,1
	pushj 17,lgvp_uint36
	add 10,1
	movei 1,a_uint36
	pushj 17,prp_uint36
	add 10,1
	movei 1,a_uint36
	pushj 17,pip_uint36
	add 10,1
	move 1,11
	pushj 17,us_uint36
	add 10,1
	move 1,11
	pushj 17,ust_uint36
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	use_memory_forms
use_memory_forms:
	add 17,[10,,10]
	movem 16,-7(17)
	movei 0,-6(17)
	hrli 0,10
	blt 0,-1(17)
	move 13,1
	move 12,2
	move 15,1
	andi 15,777	; zero_extendqisi2
	move 1,15
	pushj 17,use_native_char
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 14,13
	lsh 14,33
	ash 14,-33
	move 1,14
	move 2,12
	pushj 17,use_native_schar
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,15
	move 2,12
	pushj 17,use_native_uchar
	add 10,1
	move 1,14
	move 2,12
	pushj 17,use_Qint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,14
	move 2,12
	pushj 17,use_sQint
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,15
	move 2,12
	pushj 17,use_uQint
	add 10,1
	hrre 6,13	; extendhisi2
	movem 6,(17)
	move 1,6
	move 2,12
	pushj 17,use_Hint
	hrre 1,1	; extendhisi2
	add 10,1
	move 16,13
	hrrzi 16,(16)	; zero_extendhisi2
	move 1,16
	move 2,12
	pushj 17,use_uHint
	add 10,1
	move 1,13
	move 2,12
	pushj 17,use_Sint
	add 10,1
	move 1,13
	move 2,12
	pushj 17,use_uSint
	add 10,1
	move 11,13
	move 1,13
	lsh 1,36
	ash 1,-36
	move 2,12
	pushj 17,use_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,13
	andi 1,77
	move 2,12
	pushj 17,use_uchar6
	andi 1,77
	add 10,1
	move 1,13
	lsh 1,35
	ash 1,-35
	move 2,12
	pushj 17,use_char7
	lsh 1,35
	ash 1,-35
	add 10,1
	move 1,13
	andi 1,177
	move 2,12
	pushj 17,use_uchar7
	andi 1,177
	add 10,1
	move 1,13
	lsh 1,34
	ash 1,-34
	move 2,12
	pushj 17,use_char8
	lsh 1,34
	ash 1,-34
	add 10,1
	andi 11,377
	move 1,11
	move 2,12
	pushj 17,use_uchar8
	andi 1,377
	add 10,1
	move 1,14
	move 2,12
	pushj 17,use_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,15
	move 2,12
	pushj 17,use_uchar9
	add 10,1
	move 11,13
	move 1,13
	lsh 1,24
	ash 1,-24
	move 2,12
	pushj 17,use_short16
	lsh 1,24
	ash 1,-24
	add 10,1
	andi 11,177777
	move 1,11
	move 2,12
	pushj 17,use_ushort16
	andi 1,177777
	add 10,1
	move 1,(17)
	move 2,12
	pushj 17,use_short18
	hrre 1,1	; extendhisi2
	add 10,1
	move 1,16
	move 2,12
	pushj 17,use_ushort18
	add 10,1
	move 1,13
	move 2,12
	pushj 17,use_int32
	add 10,1
	move 1,13
	move 2,12
	pushj 17,use_uint32
	add 10,1
	move 1,13
	move 2,12
	pushj 17,use_int36
	add 10,1
	move 1,13
	move 2,12
	pushj 17,use_uint36
	add 10,1
	move 1,10
	move 16,-7(17)
	movei 0,10
	hrli 0,-6(17)
	blt 0,15
	add 17,[-10,,-10]
	popj 17,

	.bss
s_native_char:
	.space	4
vs_native_char:
	.space	4
st_native_char:
	.space	4
vst_native_char:
	.space	4
a_native_char:
	.space	8
va_native_char:
	.space	8
s_native_schar:
	.space	4
vs_native_schar:
	.space	4
st_native_schar:
	.space	4
vst_native_schar:
	.space	4
a_native_schar:
	.space	8
va_native_schar:
	.space	8
s_native_uchar:
	.space	4
vs_native_uchar:
	.space	4
st_native_uchar:
	.space	4
vst_native_uchar:
	.space	4
a_native_uchar:
	.space	8
va_native_uchar:
	.space	8
s_Qint:
	.space	4
vs_Qint:
	.space	4
st_Qint:
	.space	4
vst_Qint:
	.space	4
a_Qint:
	.space	8
va_Qint:
	.space	8
s_sQint:
	.space	4
vs_sQint:
	.space	4
st_sQint:
	.space	4
vst_sQint:
	.space	4
a_sQint:
	.space	8
va_sQint:
	.space	8
s_uQint:
	.space	4
vs_uQint:
	.space	4
st_uQint:
	.space	4
vst_uQint:
	.space	4
a_uQint:
	.space	8
va_uQint:
	.space	8
s_Hint:
	.space	4
vs_Hint:
	.space	4
st_Hint:
	.space	4
vst_Hint:
	.space	4
a_Hint:
	.space	16
va_Hint:
	.space	16
s_uHint:
	.space	4
vs_uHint:
	.space	4
st_uHint:
	.space	4
vst_uHint:
	.space	4
a_uHint:
	.space	16
va_uHint:
	.space	16
s_Sint:
	.space	4
vs_Sint:
	.space	4
st_Sint:
	.space	8
vst_Sint:
	.space	8
a_Sint:
	.space	32
va_Sint:
	.space	32
s_uSint:
	.space	4
vs_uSint:
	.space	4
st_uSint:
	.space	8
vst_uSint:
	.space	8
a_uSint:
	.space	32
va_uSint:
	.space	32
s_char6:
	.space	4
vs_char6:
	.space	4
st_char6:
	.space	4
vst_char6:
	.space	4
a_char6:
	.space	8
va_char6:
	.space	8
s_uchar6:
	.space	4
vs_uchar6:
	.space	4
st_uchar6:
	.space	4
vst_uchar6:
	.space	4
a_uchar6:
	.space	8
va_uchar6:
	.space	8
s_char7:
	.space	4
vs_char7:
	.space	4
st_char7:
	.space	4
vst_char7:
	.space	4
a_char7:
	.space	8
va_char7:
	.space	8
s_uchar7:
	.space	4
vs_uchar7:
	.space	4
st_uchar7:
	.space	4
vst_uchar7:
	.space	4
a_uchar7:
	.space	8
va_uchar7:
	.space	8
s_char8:
	.space	4
vs_char8:
	.space	4
st_char8:
	.space	4
vst_char8:
	.space	4
a_char8:
	.space	8
va_char8:
	.space	8
s_uchar8:
	.space	4
vs_uchar8:
	.space	4
st_uchar8:
	.space	4
vst_uchar8:
	.space	4
a_uchar8:
	.space	8
va_uchar8:
	.space	8
s_char9:
	.space	4
vs_char9:
	.space	4
st_char9:
	.space	4
vst_char9:
	.space	4
a_char9:
	.space	8
va_char9:
	.space	8
s_uchar9:
	.space	4
vs_uchar9:
	.space	4
st_uchar9:
	.space	4
vst_uchar9:
	.space	4
a_uchar9:
	.space	8
va_uchar9:
	.space	8
s_short16:
	.space	4
vs_short16:
	.space	4
st_short16:
	.space	4
vst_short16:
	.space	4
a_short16:
	.space	16
va_short16:
	.space	16
s_ushort16:
	.space	4
vs_ushort16:
	.space	4
st_ushort16:
	.space	4
vst_ushort16:
	.space	4
a_ushort16:
	.space	16
va_ushort16:
	.space	16
s_short18:
	.space	4
vs_short18:
	.space	4
st_short18:
	.space	4
vst_short18:
	.space	4
a_short18:
	.space	16
va_short18:
	.space	16
s_ushort18:
	.space	4
vs_ushort18:
	.space	4
st_ushort18:
	.space	4
vst_ushort18:
	.space	4
a_ushort18:
	.space	16
va_ushort18:
	.space	16
s_int32:
	.space	4
vs_int32:
	.space	4
st_int32:
	.space	8
vst_int32:
	.space	8
a_int32:
	.space	32
va_int32:
	.space	32
s_uint32:
	.space	4
vs_uint32:
	.space	4
st_uint32:
	.space	8
vst_uint32:
	.space	8
a_uint32:
	.space	32
va_uint32:
	.space	32
s_int36:
	.space	4
vs_int36:
	.space	4
st_int36:
	.space	8
vst_int36:
	.space	8
a_int36:
	.space	32
va_int36:
	.space	32
s_uint36:
	.space	4
vs_uint36:
	.space	4
st_uint36:
	.space	8
vst_uint36:
	.space	8
a_uint36:
	.space	32
va_uint36:
	.space	32
