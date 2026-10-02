
arg8uQinte:
	move 1,-1(17)
	andi 1,777
	popj 17,

arg8uQintf:
	move 1,-2(17)
	andi 1,777
	popj 17,

arg8uQintg:
	move 1,-3(17)
	andi 1,777
	popj 17,

arg8uQinth:
	move 1,-4(17)
	andi 1,777
	popj 17,

arg8Qinte:
	hrre 1,-1(17)
	popj 17,

arg8Qintf:
	hrre 1,-2(17)
	popj 17,

arg8Qintg:
	hrre 1,-3(17)
	popj 17,

arg8Qinth:
	hrre 1,-4(17)
	popj 17,

arg8uHinte:
	hrrz 1,-1(17)
	popj 17,

arg8uHintf:
	hrrz 1,-2(17)
	popj 17,

arg8uHintg:
	hrrz 1,-3(17)
	popj 17,

arg8uHinth:
	hrrz 1,-4(17)
	popj 17,

arg8Hinte:
	hrre 1,-1(17)
	popj 17,

arg8Hintf:
	hrre 1,-2(17)
	popj 17,

arg8Hintg:
	hrre 1,-3(17)
	popj 17,

arg8Hinth:
	hrre 1,-4(17)
	popj 17,

arg8uSinte:
	move 1,-1(17)
	popj 17,

arg8uSintf:
	move 1,-2(17)
	popj 17,

arg8uSintg:
	move 1,-3(17)
	popj 17,

arg8uSinth:
	move 1,-4(17)
	popj 17,

arg8Sinte:
	move 1,-1(17)
	popj 17,

arg8Sintf:
	move 1,-2(17)
	popj 17,

arg8Sintg:
	move 1,-3(17)
	popj 17,

arg8Sinth:
	move 1,-4(17)
	popj 17,

arg8Dintc:
	move 1,-2(17)
	move 2,-1(17)
	popj 17,

arg8Dintd:
	move 1,-4(17)
	move 2,-3(17)
	popj 17,

arg8Dinte:
	move 1,-6(17)
	move 2,-5(17)
	popj 17,

arg8Dintf:
	move 1,-10(17)
	move 2,-7(17)
	popj 17,

arg8Dintg:
	move 1,-12(17)
	move 2,-11(17)
	popj 17,

arg8Dinth:
	move 1,-14(17)
	move 2,-13(17)
	popj 17,

arg8uDintc:
	move 1,-2(17)
	move 2,-1(17)
	popj 17,

arg8uDintd:
	move 1,-4(17)
	move 2,-3(17)
	popj 17,

arg8uDinte:
	move 1,-6(17)
	move 2,-5(17)
	popj 17,

arg8uDintf:
	move 1,-10(17)
	move 2,-7(17)
	popj 17,

arg8uDintg:
	move 1,-12(17)
	move 2,-11(17)
	popj 17,

arg8uDinth:
	move 1,-14(17)
	move 2,-13(17)
	popj 17,

arg10Sinte:
	move 1,-1(17)
	popj 17,

arg10Sintf:
	move 1,-2(17)
	popj 17,

arg10Sintg:
	move 1,-3(17)
	popj 17,

arg10Sinth:
	move 1,-4(17)
	popj 17,

arg10Sinti:
	move 1,-5(17)
	popj 17,

arg10Sintj:
	move 1,-6(17)
	popj 17,

arg10uSinte:
	move 1,-1(17)
	popj 17,

arg10uSintf:
	move 1,-2(17)
	popj 17,

arg10uSintg:
	move 1,-3(17)
	popj 17,

arg10uSinth:
	move 1,-4(17)
	popj 17,

arg10uSinti:
	move 1,-5(17)
	popj 17,

arg10uSintj:
	move 1,-6(17)
	popj 17,

arg10Qinte:
	hrre 1,-1(17)
	popj 17,

arg10Qintf:
	hrre 1,-2(17)
	popj 17,

arg10Qintg:
	hrre 1,-3(17)
	popj 17,

arg10Qinth:
	hrre 1,-4(17)
	popj 17,

arg10Qinti:
	hrre 1,-5(17)
	popj 17,

arg10Qintj:
	hrre 1,-6(17)
	popj 17,

arg10Hinte:
	hrre 1,-1(17)
	popj 17,

arg10Hintf:
	hrre 1,-2(17)
	popj 17,

arg10Hintg:
	hrre 1,-3(17)
	popj 17,

arg10Hinth:
	hrre 1,-4(17)
	popj 17,

arg10Hinti:
	hrre 1,-5(17)
	popj 17,

arg10Hintj:
	hrre 1,-6(17)
	popj 17,

darg_c:
	move 1,-2(17)
	move 2,-1(17)
	popj 17,

darg_d:
	move 1,-4(17)
	move 2,-3(17)
	popj 17,

darg_e:
	move 1,-6(17)
	move 2,-5(17)
	popj 17,

darg_f:
	move 1,-10(17)
	move 2,-7(17)
	popj 17,

udarg_c:
	move 1,-2(17)
	move 2,-1(17)
	popj 17,

udarg_d:
	move 1,-4(17)
	move 2,-3(17)
	popj 17,

udarg_e:
	move 1,-6(17)
	move 2,-5(17)
	popj 17,

udarg_f:
	move 1,-10(17)
	move 2,-7(17)
	popj 17,

late_add_e:
	move 1,-1(17)
	add 1,-2(17)
	popj 17,

late_sub_g_h:
	move 1,-3(17)
	sub 1,-4(17)
	popj 17,

late_mix_e_h:
	move 4,-2(17)
	move 1,-1(17)
	add 1,-4(17)
	sub 4,-3(17)
	xor 1,4
	popj 17,

ulate_mix_e_h:
	move 4,-2(17)
	move 1,-1(17)
	add 1,-4(17)
	sub 4,-3(17)
	xor 1,4
	popj 17,

late_qi_sum:
	hrre 1,-1(17)
	hrre 4,-2(17)
	add 1,4
	hrre 4,-3(17)
	add 1,4
	hrre 4,-4(17)
	add 1,4
	popj 17,

late_uqi_sum:
	move 1,-1(17)
	andi 1,777
	move 4,-2(17)
	andi 4,777
	move 3,-3(17)
	andi 3,777
	move 2,-4(17)
	andi 2,777
	add 1,4
	add 1,3
	add 1,2
	popj 17,

late_hi_sum:
	hrre 1,-1(17)
	hrre 4,-2(17)
	add 1,4
	hrre 4,-3(17)
	add 1,4
	hrre 4,-4(17)
	add 1,4
	popj 17,

late_uhi_sum:
	hrrz 1,-1(17)
	hrrz 4,-2(17)
	hrrz 3,-3(17)
	hrrz 2,-4(17)
	add 1,4
	add 1,3
	add 1,2
	popj 17,

late_dint_select:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,-4(17)
	move 11,-3(17)
	move 4,-6(17)
	move 5,-5(17)
	move 1,-10(17)
	move 2,-7(17)
	move 6,-12(17)
	move 7,-11(17)
	camn 10,4
	jrst %L79
%L78:
	move 1,6
	move 2,7
%L77:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L79:
	came 11,5
	jrst %L78
	jrst %L77

late_dint_store:
	move 4,-6(17)
	move 5,-5(17)
	move 1,-10(17)
	move 2,-7(17)
	movem 4,darg_sink
	movem 5,darg_sink+1
	popj 17,

late_udint_store:
	move 4,-6(17)
	move 5,-5(17)
	move 1,-10(17)
	move 2,-7(17)
	movem 4,udarg_sink
	movem 5,udarg_sink+1
	popj 17,

mix_q_h_s_e:
	move 1,-1(17)
	popj 17,

mix_q_h_s_f:
	hrre 1,-2(17)
	popj 17,

mix_q_h_s_g:
	hrre 1,-3(17)
	popj 17,

mix_q_h_s_h:
	move 1,-4(17)
	popj 17,

mix_d_s_q_e:
	move 1,-2(17)
	popj 17,

mix_d_s_q_f:
	move 1,-4(17)
	move 2,-3(17)
	popj 17,

mix_d_s_q_g:
	move 1,-5(17)
	popj 17,

mix_s_d_s_e:
	move 1,-3(17)
	popj 17,

mix_s_d_s_d:
	move 1,-2(17)
	move 2,-1(17)
	popj 17,

mix_s_d_s_f:
	move 1,-4(17)
	popj 17,

ptr_arg_e:
	move 1,-1(17)
	popj 17,

ptr_arg_f:
	move 1,-2(17)
	popj 17,

ptr_arg_g:
	move 1,-3(17)
	popj 17,

ptr_arg_h:
	move 1,-4(17)
	popj 17,

ptr_load_e:
	move 1,@-1(17)
	popj 17,

ptr_load_h:
	move 1,@-4(17)
	popj 17,

ptr_store_g:
	move 6,-5(17)
	movem 6,@-3(17)
	popj 17,

qptr_arg_h:
	move 1,-4(17)
	popj 17,

hptr_arg_h:
	move 1,-4(17)
	popj 17,

small_arg_c:
	add 3,4
	add 3,-1(17)
	move 1,3
	popj 17,

small_arg_late:
	move 1,-2(17)
	move 2,-1(17)
	add 1,2
	add 1,-3(17)
	popj 17,

mixed_arg_late:
	move 4,-2(17)
	move 5,-1(17)
	move 1,4
	ash 1,-33
	hrre 3,4
	add 1,3
	add 1,5
	add 1,-3(17)
	popj 17,

big_arg_late:
	move 1,-5(17)
	add 1,-4(17)
	add 1,-3(17)
	add 1,-2(17)
	add 1,-1(17)
	add 1,-6(17)
	popj 17,

return_small_arg_late:
	move 1,-2(17)
	move 2,-1(17)
	popj 17,

return_mixed_arg_late:
	move 1,-2(17)
	move 2,-1(17)
	popj 17,

return_big_arg_late:
	movei 3,(1)
	hrli 3,-6(17)
	blt 3,4(1)
	popj 17,

store_small_arg_late:
	move 4,-2(17)
	move 5,-1(17)
	movem 4,small_global
	movem 5,small_global+1
	popj 17,

store_mixed_arg_late:
	move 4,-2(17)
	move 5,-1(17)
	movem 4,mixed_global
	movem 5,mixed_global+1
	popj 17,

store_big_arg_late:
	movei 4,big_global
	hrli 4,-5(17)
	blt 4,big_global+4
	popj 17,

callee8_sint:
	move 1,-1(17)
	add 1,-2(17)
	add 1,-3(17)
	add 1,-4(17)
	popj 17,

callee6_dint:
	move 1,-6(17)
	move 2,-5(17)
	popj 17,

call8_sint:
	add 17,[4,,4]
	move 6,-5(17)
	movem 6,(17)
	move 6,-6(17)
	movem 6,-1(17)
	move 6,-7(17)
	movem 6,-2(17)
	move 6,-10(17)
	movem 6,-3(17)
	pushj 17,callee8_sint
	add 17,[-4,,-4]
	popj 17,

call8_sint_constants:
	add 17,[4,,4]
	movei 6,5
	movem 6,(17)
	movei 6,6
	movem 6,-1(17)
	movei 6,7
	movem 6,-2(17)
	movei 6,10
	movem 6,-3(17)
	movei 1,1
	movei 2,2
	movei 3,3
	movei 4,4
	pushj 17,callee8_sint
	add 17,[-4,,-4]
	popj 17,

call8_sint_mixed:
	add 17,[11,,11]
	movei 0,-10(17)
	hrli 0,10
	blt 0,-4(17)
	move 10,1
	move 11,2
	pushj 17,f
	move 14,1
	move 12,10
	add 12,11
	move 13,10
	sub 13,11
	pushj 17,f
	movem 12,(17)
	movem 13,-1(17)
	movem 1,-2(17)
	movei 6,10
	movem 6,-3(17)
	move 1,10
	move 2,11
	move 3,14
	movei 4,4
	pushj 17,callee8_sint
	movei 0,10
	hrli 0,-10(17)
	blt 0,14
	add 17,[-11,,-11]
	popj 17,

call6_dint:
	add 17,[16,,16]
	movei 0,-15(17)
	hrli 0,10
	blt 0,-10(17)
	move 6,-20(17)
	move 7,-17(17)
	move 10,-22(17)
	move 11,-21(17)
	move 12,-24(17)
	move 13,-23(17)
	move 14,-26(17)
	move 15,-25(17)
	movem 6,-1(17)
	movem 7,(17)
	movem 10,-3(17)
	movem 11,-2(17)
	movem 12,-5(17)
	movem 13,-4(17)
	movem 14,-7(17)
	movem 15,-6(17)
	pushj 17,callee6_dint
	movei 0,10
	hrli 0,-15(17)
	blt 0,15
	add 17,[-16,,-16]
	popj 17,

call6_dint_constants:
	add 17,[10,,10]
	setzm -1(17)
	movei 6,3
	movem 6,(17)
	setzm -3(17)
	movei 6,4
	movem 6,-2(17)
	setzm -5(17)
	movei 6,5
	movem 6,-4(17)
	setzm -7(17)
	movei 6,6
	movem 6,-6(17)
	movei 1,0
	movei 2,1
	movei 3,0
	movei 4,2
	pushj 17,callee6_dint
	add 17,[-10,,-10]
	popj 17,

callee_mixed:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	lsh 1,33
	ash 1,-33
	hrre 2,2
	add 1,2
	add 1,3
	hrre 4,-3(17)
	add 1,4
	hrre 4,-4(17)
	add 1,4
	add 1,-5(17)
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

call_mixed:
	add 17,[12,,12]
	move 0,-12(17)
	movem 0,-11(17)
	movem 10,-10(17)
	movem 11,-7(17)
	movem 12,-6(17)
	movem 4,-12(17)
	move 10,-13(17)
	move 6,-20(17)
	move 7,-17(17)
	lsh 1,33
	ash 1,-33
	hrre 2,2
	hrre 5,-14(17)
	hrre 12,-15(17)
	movem 5,-1(17)
	movem 12,-2(17)
	move 5,-16(17)
	movem 5,-3(17)
	movem 6,-5(17)
	movem 7,-4(17)
	movem 10,(17)
	pushj 17,callee_mixed
	move 10,-10(17)
	move 11,-7(17)
	move 12,-6(17)
	move 0,-11(17)
	movem 0,-12(17)
	add 17,[-12,,-12]
	popj 17,

call_mixed_constants:
	add 17,[6,,6]
	movei 6,5
	movem 6,-1(17)
	movei 6,6
	movem 6,-2(17)
	movei 6,7
	movem 6,-3(17)
	setzm -5(17)
	movei 6,10
	movem 6,-4(17)
	setzm (17)
	movei 4,4
	movei 1,1
	movei 2,2
	movei 3,3
	pushj 17,callee_mixed
	add 17,[-6,,-6]
	popj 17,

late_after_call_e:
	pushj 17,clobber
	move 1,-1(17)
	popj 17,

late_after_call_h:
	pushj 17,clobber
	move 1,-4(17)
	popj 17,

late_dint_after_call_e:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,-10(17)
	move 11,-7(17)
	pushj 17,clobber
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

late_dint_after_call_f:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,-12(17)
	move 11,-11(17)
	pushj 17,clobber
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

late_branch_e:
	move 1,-2(17)
	skipe -1(17)
	move 1,-3(17)
	popj 17,

late_branch_h:
	move 1,-1(17)
	skipl 4,-4(17)
	move 1,4
	popj 17,

late_u_branch_h:
	move 1,-4(17)
	tlc 1,400000
	move 4,-1(17)
	tlc 4,400000
	camg 1,4
	tdza 1,1
	movei 1,1
	popj 17,

late_dint_branch:
	move 2,-6(17)
	move 3,-5(17)
	move 4,-10(17)
	move 5,-7(17)
	camn 2,4
	jrst %L133
%L132:
	movei 1,0
%L131:
	popj 17,
%L133:
	movei 1,1
	came 3,5
	jrst %L132
	popj 17,

late_address_copy_e:
	move 1,-1(17)
	popj 17,

late_address_copy_h:
	move 1,-4(17)
	popj 17,

late_dint_address_copy_e:
	movei 4,-6(17)
	move 6,-5(17)
	movem 6,4(4)
	move 1,(4)
	move 2,1(4)
	popj 17,

sink_late_e:
	move 6,-1(17)
	movem 6,arg_sink
	popj 17,

sink_late_h:
	move 6,-4(17)
	movem 6,arg_sink
	popj 17,

sink_late_dint_e:
	move 4,-6(17)
	move 5,-5(17)
	movem 4,darg_sink
	movem 5,darg_sink+1
	popj 17,

sink_late_udint_f:
	move 4,-10(17)
	move 5,-7(17)
	movem 4,udarg_sink
	movem 5,udarg_sink+1
	popj 17,

	.bss
arg_sink:
	.space	4
darg_sink:
	.space	8
udarg_sink:
	.space	8
small_global:
	.space	8
mixed_global:
	.space	8
big_global:
	.space	20
