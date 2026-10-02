
	.globl	ffssi2
ffssi2:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L2
	movei 3,44
%L2:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_arg:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L4
	movei 3,44
%L4:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_second_arg:
	setzb 6,7
	movn 4,2
	move 6,2
	and 6,4
	jffo 6,%L6
	movei 7,44
%L6:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

uffs_arg:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L8
	movei 3,44
%L8:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_local:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L10
	movei 3,44
%L10:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_local:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L12
	movei 3,44
%L12:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_reuse:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L14
	movei 3,44
%L14:
	move 4,3
	subi 4,44
	movn 1,4
	popj 17,

ffs_after_add:
	setzb 6,7
	add 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L16
	movei 7,44
%L16:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_after_sub:
	setzb 6,7
	sub 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L18
	movei 7,44
%L18:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_after_neg:
	setzb 2,3
	movn 4,1
	move 2,4
	and 2,1
	jffo 2,%L20
	movei 3,44
%L20:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_after_and:
	setzb 6,7
	and 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L22
	movei 7,44
%L22:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_after_or:
	setzb 6,7
	ior 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L24
	movei 7,44
%L24:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_after_xor:
	setzb 6,7
	xor 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L26
	movei 7,44
%L26:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_after_shift_left:
	setzb 6,7
	lsh 1,(2)
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L28
	movei 7,44
%L28:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_after_shift_right:
	setzb 6,7
	movn 2,2
	lsh 1,(2)
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L30
	movei 7,44
%L30:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_call_value:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 10,11
	pushj 17,f
	movn 4,1
	move 10,1
	and 10,4
	jffo 10,%L32
	movei 11,44
%L32:
	move 1,11
	subi 1,44
	movn 1,1
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

uffs_call_value:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 10,11
	pushj 17,uf
	movn 4,1
	move 10,1
	and 10,4
	jffo 10,%L34
	movei 11,44
%L34:
	move 1,11
	subi 1,44
	movn 1,1
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_mem:
	setzb 2,3
	movn 4,(1)
	move 2,4
	and 2,(1)
	jffo 2,%L36
	movei 3,44
%L36:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_mem:
	setzb 2,3
	movn 4,(1)
	move 2,4
	and 2,(1)
	jffo 2,%L38
	movei 3,44
%L38:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_volatile_mem:
	setzb 6,7
	move 3,(1)
	movn 4,3
	move 6,3
	and 6,4
	jffo 6,%L40
	movei 7,44
%L40:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

uffs_volatile_mem:
	setzb 6,7
	move 3,(1)
	movn 4,3
	move 6,3
	and 6,4
	jffo 6,%L42
	movei 7,44
%L42:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_global:
	setzb 2,3
	movn 4,ffs_ga
	move 2,4
	and 2,ffs_ga
	jffo 2,%L44
	movei 3,44
%L44:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_global_b:
	setzb 2,3
	movn 4,ffs_gb
	move 2,4
	and 2,ffs_gb
	jffo 2,%L46
	movei 3,44
%L46:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_volatile_global:
	setzb 1,2
	move 3,ffs_vga
	movn 4,3
	move 1,3
	and 1,4
	jffo 1,%L48
	movei 2,44
%L48:
	move 1,2
	subi 1,44
	movn 1,1
	popj 17,

uffs_global:
	setzb 2,3
	movn 4,uffs_ga
	move 2,4
	and 2,uffs_ga
	jffo 2,%L50
	movei 3,44
%L50:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_global_b:
	setzb 2,3
	movn 4,uffs_gb
	move 2,4
	and 2,uffs_gb
	jffo 2,%L52
	movei 3,44
%L52:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_volatile_global:
	setzb 1,2
	move 3,uffs_vga
	movn 4,3
	move 1,3
	and 1,4
	jffo 1,%L54
	movei 2,44
%L54:
	move 1,2
	subi 1,44
	movn 1,1
	popj 17,

ffs_array:
	setzb 2,3
	andi 1,17
	movn 4,ffs_buf(1)
	move 2,4
	and 2,ffs_buf(1)
	jffo 2,%L56
	movei 3,44
%L56:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_array:
	setzb 2,3
	andi 1,17
	movn 4,uffs_buf(1)
	move 2,4
	and 2,uffs_buf(1)
	jffo 2,%L58
	movei 3,44
%L58:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_ptr_array:
	setzb 6,7
	andi 2,17
	add 1,2
	movn 4,(1)
	move 6,4
	and 6,(1)
	jffo 6,%L61
	movei 7,44
%L61:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

uffs_ptr_array:
	setzb 6,7
	andi 2,17
	add 1,2
	movn 4,(1)
	move 6,4
	and 6,(1)
	jffo 6,%L64
	movei 7,44
%L64:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_struct_a:
	setzb 2,3
	movn 4,(1)
	move 2,4
	and 2,(1)
	jffo 2,%L66
	movei 3,44
%L66:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_struct_b:
	setzb 2,3
	movn 4,1(1)
	move 2,4
	and 2,1(1)
	jffo 2,%L68
	movei 3,44
%L68:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_struct_a:
	setzb 2,3
	movn 4,(1)
	move 2,4
	and 2,(1)
	jffo 2,%L70
	movei 3,44
%L70:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_struct_b:
	setzb 2,3
	movn 4,1(1)
	move 2,4
	and 2,1(1)
	jffo 2,%L72
	movei 3,44
%L72:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_global_struct_a:
	setzb 2,3
	movn 4,ffs_gp
	move 2,4
	and 2,ffs_gp
	jffo 2,%L74
	movei 3,44
%L74:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_global_struct_b:
	setzb 2,3
	movn 4,ffs_gp+1
	move 2,4
	and 2,ffs_gp+1
	jffo 2,%L76
	movei 3,44
%L76:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_global_struct_a:
	setzb 2,3
	movn 4,uffs_gp
	move 2,4
	and 2,uffs_gp
	jffo 2,%L78
	movei 3,44
%L78:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_global_struct_b:
	setzb 2,3
	movn 4,uffs_gp+1
	move 2,4
	and 2,uffs_gp+1
	jffo 2,%L80
	movei 3,44
%L80:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_global_struct_three:
	setzb 2,3
	movn 4,ffs_gt+2
	move 2,4
	and 2,ffs_gt+2
	jffo 2,%L82
	movei 3,44
%L82:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_const_zero:
	setzb 4,5
	jffo 4,%L84
%L84:
	movei 1,0
	popj 17,

ffs_const_one:
	move 4,[1]
	move 5,[0]
	jffo 4,%L86
%L86:
	movei 1,1
	popj 17,

ffs_const_two:
	move 4,[2]
	move 5,[0]
	jffo 4,%L88
%L88:
	movei 1,2
	popj 17,

ffs_const_four:
	move 4,[4]
	move 5,[0]
	jffo 4,%L90
%L90:
	movei 1,3
	popj 17,

ffs_const_400:
	move 4,[400]
	move 5,[0]
	jffo 4,%L92
%L92:
	movei 1,11
	popj 17,

ffs_const_1000:
	move 4,[1000]
	move 5,[0]
	jffo 4,%L94
%L94:
	movei 1,12
	popj 17,

ffs_const_right_high:
	move 4,[400000]
	move 5,[0]
	jffo 4,%L96
%L96:
	movei 1,22
	popj 17,

ffs_const_halfword:
	move 4,[1000000]
	move 5,[0]
	jffo 4,%L98
%L98:
	movei 1,23
	popj 17,

ffs_const_left_low:
	move 4,[100000000000]
	move 5,[0]
	jffo 4,%L100
%L100:
	movei 1,42
	popj 17,

ffs_const_signbit:
	move 4,[400000000000]
	move 5,[0]
	jffo 4,%L102
%L102:
	movei 1,44
	popj 17,

ffs_const_allones:
	move 4,[1]
	move 5,[0]
	jffo 4,%L104
%L104:
	movei 1,1
	popj 17,

ffs_const_pattern:
	move 4,[2]
	move 5,[0]
	jffo 4,%L106
%L106:
	movei 1,2
	popj 17,

ffs_const_minus_one:
	move 4,[1]
	move 5,[0]
	jffo 4,%L108
%L108:
	movei 1,1
	popj 17,

ffs_const_minus_two:
	move 4,[2]
	move 5,[0]
	jffo 4,%L110
%L110:
	movei 1,2
	popj 17,

ffs_const_minus_power:
	move 4,[1000]
	move 5,[0]
	jffo 4,%L112
%L112:
	movei 1,12
	popj 17,

ffs_lowbit_0:
	setzb 2,3
	iori 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L114
	movei 3,44
%L114:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_lowbit_1:
	setzb 2,3
	lsh 1,1
	iori 1,2
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L116
	movei 3,44
%L116:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_lowbit_2:
	setzb 2,3
	lsh 1,2
	iori 1,4
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L118
	movei 3,44
%L118:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_lowbit_8:
	setzb 2,3
	lsh 1,11
	iori 1,400
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L120
	movei 3,44
%L120:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_lowbit_9:
	setzb 2,3
	lsh 1,12
	iori 1,1000
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L122
	movei 3,44
%L122:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_lowbit_17:
	setzb 2,3
	hrlz 1,1
	iori 1,400000
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L124
	movei 3,44
%L124:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_lowbit_18:
	setzb 2,3
	lsh 1,23
	tlo 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L126
	movei 3,44
%L126:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_lowbit_35:
	setzb 2,3
	lsh 1,43
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L128
	movei 3,44
%L128:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

uffs_lowbit_35:
	setzb 2,3
	lsh 1,43
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L130
	movei 3,44
%L130:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_isolated:
	setzb 6,7
	movn 4,1
	and 4,1
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L132
	movei 7,44
%L132:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

uffs_isolated:
	setzb 6,7
	movn 4,1
	and 4,1
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L134
	movei 7,44
%L134:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_isolated_mem:
	setzb 6,7
	movn 4,(1)
	and 4,(1)
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L136
	movei 7,44
%L136:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_isolated_global:
	setzb 1,2
	movn 4,ffs_ga
	and 4,ffs_ga
	movn 3,4
	move 1,4
	and 1,3
	jffo 1,%L138
	movei 2,44
%L138:
	move 1,2
	subi 1,44
	movn 1,1
	popj 17,

ffs_masked_low:
	setzb 2,3
	hrrz 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L140
	movei 3,44
%L140:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_masked_high:
	setzb 2,3
	hllz 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L142
	movei 3,44
%L142:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_masked_sign:
	setzb 2,3
	and 1,[-400000000000]
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L144
	movei 3,44
%L144:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_shifted_mask:
	setzb 6,7
	hrrz 1,1
	lsh 1,(2)
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L146
	movei 7,44
%L146:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_store_ptr:
	setzb 6,7
	movn 4,2
	move 6,2
	and 6,4
	jffo 6,%L148
	movei 7,44
%L148:
	move 4,7
	subi 4,44
	movnm 4,(1)
	popj 17,

ffs_store_ptr_return:
	setzb 6,7
	move 3,1
	movn 4,2
	move 6,2
	and 6,4
	jffo 6,%L150
	movei 7,44
%L150:
	move 1,7
	subi 1,44
	movn 1,1
	movem 1,(3)
	popj 17,

ffs_store_global:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L152
	movei 3,44
%L152:
	move 4,3
	subi 4,44
	movnm 4,ffs_ga
	popj 17,

ffs_store_global_return:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L154
	movei 3,44
%L154:
	move 1,3
	subi 1,44
	movn 1,1
	movem 1,ffs_ga
	popj 17,

ffs_store_array:
	setzb 6,7
	andi 1,17
	xmovei 1,ffs_buf(1)
	movn 4,2
	move 6,2
	and 6,4
	jffo 6,%L156
	movei 7,44
%L156:
	move 4,7
	subi 4,44
	movnm 4,(1)
	popj 17,

ffs_store_array_return:
	setzb 6,7
	andi 1,17
	xmovei 3,ffs_buf(1)
	movn 4,2
	move 6,2
	and 6,4
	jffo 6,%L158
	movei 7,44
%L158:
	move 1,7
	subi 1,44
	movn 1,1
	movem 1,(3)
	popj 17,

uffs_store_ptr:
	setzb 6,7
	movn 4,2
	move 6,2
	and 6,4
	jffo 6,%L160
	movei 7,44
%L160:
	move 4,7
	subi 4,44
	movnm 4,(1)
	popj 17,

uffs_store_ptr_return:
	setzb 6,7
	move 3,1
	movn 4,2
	move 6,2
	and 6,4
	jffo 6,%L162
	movei 7,44
%L162:
	move 1,7
	subi 1,44
	movn 1,1
	movem 1,(3)
	popj 17,

ffs_plus:
	setzb 6,7
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L164
	movei 7,44
%L164:
	move 4,7
	subi 4,44
	sub 2,4
	move 1,2
	popj 17,

ffs_minus:
	setzb 6,7
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L166
	movei 7,44
%L166:
	move 1,7
	subi 1,44
	movn 1,1
	sub 1,2
	popj 17,

ffs_mul:
	setzb 6,7
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L168
	movei 7,44
%L168:
	move 1,7
	subi 1,44
	movn 1,1
	imul 1,2
	popj 17,

ffs_xor:
	setzb 6,7
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L170
	movei 7,44
%L170:
	move 1,7
	subi 1,44
	movn 1,1
	xor 1,2
	popj 17,

ffs_or:
	setzb 6,7
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L172
	movei 7,44
%L172:
	move 1,7
	subi 1,44
	movn 1,1
	ior 1,2
	popj 17,

ffs_and:
	setzb 6,7
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L174
	movei 7,44
%L174:
	move 1,7
	subi 1,44
	movn 1,1
	and 1,2
	popj 17,

ffs_twice:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	setzb 10,11
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L176
	movei 7,44
%L176:
	move 4,7
	subi 4,44
	movn 1,4
	movn 4,2
	move 10,2
	and 10,4
	jffo 10,%L177
	movei 11,44
%L177:
	move 4,11
	subi 4,44
	sub 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_nested:
	setzb 2,3
	setzb 6,7
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L179
	movei 3,44
%L179:
	subi 3,44
	movn 4,3
	move 6,4
	and 6,3
	jffo 6,%L180
	movei 7,44
%L180:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_index_array:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L182
	movei 3,44
%L182:
	move 4,3
	subi 4,44
	movn 4,4
	andi 4,17
	move 1,ffs_buf(4)
	popj 17,

ffs_shift_result:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L184
	movei 3,44
%L184:
	move 4,3
	subi 4,44
	movn 4,4
	movei 1,1
	lsh 1,(4)
	popj 17,

ffs_shift_input:
	setzb 6,7
	lsh 1,(2)
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L186
	movei 7,44
%L186:
	move 4,7
	subi 4,44
	sub 2,4
	move 1,2
	popj 17,

ffs_eq_zero:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L188
	movei 3,44
%L188:
	movei 6,44
	came 3,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_ne_zero:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L190
	movei 3,44
%L190:
	movei 6,44
	camn 3,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_eq_one:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L192
	movei 3,44
%L192:
	movei 6,43
	came 3,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_gt_one:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L194
	movei 3,44
%L194:
	move 1,3
	subi 1,44
	movn 1,1
	movei 6,1
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_lt_18:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L196
	movei 3,44
%L196:
	move 1,3
	subi 1,44
	movn 1,1
	movei 6,21
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_ge_18:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L198
	movei 3,44
%L198:
	move 1,3
	subi 1,44
	movn 1,1
	movei 6,21
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_if_zero:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L201
	movei 3,44
%L201:
	movei 6,44
	camn 3,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_if_nonzero:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L204
	movei 3,44
%L204:
	movei 6,44
	camn 3,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_if_low:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L207
	movei 3,44
%L207:
	move 4,3
	subi 4,44
	movn 4,4
	seto 1,
	caile 4,11
	movei 1,1
	popj 17,

ffs_if_high:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L210
	movei 3,44
%L210:
	move 4,3
	subi 4,44
	movn 4,4
	movei 1,1
	caig 4,22
	seto 1,
	popj 17,

ffs_range:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L212
	movei 3,44
%L212:
	move 4,3
	subi 4,44
	movn 1,4
	movei 4,0
	jumpe 1,%L211
	seto 4,
	caig 1,21
	jrst %L211
	movei 4,1
	caig 1,22
	movei 4,22
%L211:
	move 1,4
	popj 17,

uffs_eq_zero:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L217
	movei 3,44
%L217:
	movei 6,44
	came 3,6
	tdza 1,1
	movei 1,1
	popj 17,

uffs_ne_zero:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L219
	movei 3,44
%L219:
	movei 6,44
	camn 3,6
	tdza 1,1
	movei 1,1
	popj 17,

uffs_gt_18:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L221
	movei 3,44
%L221:
	move 1,3
	subi 1,44
	movn 1,1
	movei 6,22
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

uffs_if_highbit:
	setzb 2,3
	tlo 1,400000
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L224
	movei 3,44
%L224:
	move 4,3
	subi 4,44
	movn 4,4
	movei 1,1
	caig 4,22
	seto 1,
	popj 17,

uffs_range:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L226
	movei 3,44
%L226:
	move 4,3
	subi 4,44
	movn 1,4
	movei 4,0
	jumpe 1,%L225
	seto 4,
	caig 1,21
	jrst %L225
	movei 4,1
	caig 1,22
	movei 4,22
%L225:
	move 1,4
	popj 17,

ffs_qi:
	setzb 2,3
	lsh 1,33
	ash 1,-33
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L231
	movei 3,44
%L231:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_uqi:
	setzb 2,3
	andi 1,777	; zero_extendqisi2
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L233
	movei 3,44
%L233:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_hi:
	setzb 2,3
	hrre 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L235
	movei 3,44
%L235:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_uhi:
	setzb 2,3
	hrrzi 1,(1)	; zero_extendhisi2
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L237
	movei 3,44
%L237:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_qi_plus:
	setzb 6,7
	lsh 1,33
	ash 1,-33
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L239
	movei 7,44
%L239:
	move 4,7
	subi 4,44
	sub 2,4
	move 1,2
	popj 17,

ffs_uqi_plus:
	setzb 6,7
	andi 1,777	; zero_extendqisi2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L241
	movei 7,44
%L241:
	move 4,7
	subi 4,44
	sub 2,4
	move 1,2
	popj 17,

ffs_hi_plus:
	setzb 6,7
	hrre 1,1
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L243
	movei 7,44
%L243:
	move 4,7
	subi 4,44
	sub 2,4
	move 1,2
	popj 17,

ffs_uhi_plus:
	setzb 6,7
	hrrzi 1,(1)	; zero_extendhisi2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L245
	movei 7,44
%L245:
	move 4,7
	subi 4,44
	sub 2,4
	move 1,2
	popj 17,

ffs_qi_if:
	setzb 2,3
	lsh 1,33
	ash 1,-33
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L248
	movei 3,44
%L248:
	movei 6,44
	camn 3,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_hi_if:
	setzb 2,3
	hrre 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L251
	movei 3,44
%L251:
	move 4,3
	subi 4,44
	movn 4,4
	movei 1,1
	caig 4,11
	seto 1,
	popj 17,

ffs_switch_like:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L253
	movei 3,44
%L253:
	move 4,3
	subi 4,44
	movn 1,4
	movei 4,0
	jumpe 1,%L252
	movei 4,12
	cain 1,1
	jrst %L252
	movei 4,264
	cain 1,22
	jrst %L252
	movei 4,550
	caie 1,44
	move 4,1
%L252:
	move 1,4
	popj 17,

ffs_select_value:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	setzb 10,11
	move 5,3
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L260
	movei 7,44
%L260:
	move 4,7
	subi 4,44
	movn 3,4
	movn 4,2
	move 10,2
	and 10,4
	jffo 10,%L261
	movei 11,44
%L261:
	move 1,11
	subi 1,44
	movn 1,1
	camle 3,1
	skipa 1,5
	move 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_loop_mask:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L263
	movei 3,44
%L263:
	move 4,3
	subi 4,44
	movn 1,4
	movei 4,0
	jumple 1,%L269
%L267:
	add 4,1
	sojg 1,%L267	; decrement_and_branch_until_zero
%L269:
	move 1,4
	popj 17,

ffs_after_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 11,12
	move 10,(1)
	pushj 17,clobber
	movn 4,10
	move 11,10
	and 11,4
	jffo 11,%L271
	movei 12,44
%L271:
	move 1,12
	subi 1,44
	movn 1,1
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

ffs_store_after_call:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 11,12
	move 13,1
	pushj 17,f
	move 10,1
	pushj 17,clobber
	movn 4,10
	move 11,10
	and 11,4
	jffo 11,%L273
	movei 12,44
%L273:
	move 1,12
	subi 1,44
	movn 1,1
	movem 1,(13)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

ffs_global_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 10,11
	pushj 17,clobber
	movn 4,ffs_ga
	move 10,4
	and 10,ffs_ga
	jffo 10,%L275
	movei 11,44
%L275:
	move 1,11
	subi 1,44
	movn 1,1
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_volatile_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 10,11
	pushj 17,clobber
	move 3,ffs_vga
	movn 4,3
	move 10,3
	and 10,4
	jffo 10,%L277
	movei 11,44
%L277:
	move 1,11
	subi 1,44
	movn 1,1
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

uffs_after_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 11,12
	move 10,(1)
	pushj 17,clobber
	movn 4,10
	move 11,10
	and 11,4
	jffo 11,%L279
	movei 12,44
%L279:
	move 1,12
	subi 1,44
	movn 1,1
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

ffs_two_calls:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	setzb 11,12
	setzb 13,14
	pushj 17,f
	move 10,1
	pushj 17,f
	movn 4,10
	move 11,10
	and 11,4
	jffo 11,%L281
	movei 12,44
%L281:
	move 4,12
	subi 4,44
	movn 3,4
	movn 4,1
	move 13,1
	and 13,4
	jffo 13,%L282
	movei 14,44
%L282:
	move 4,14
	subi 4,44
	move 1,3
	sub 1,4
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

uffs_two_calls:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	setzb 11,12
	setzb 13,14
	pushj 17,uf
	move 10,1
	pushj 17,uf
	movn 4,10
	move 11,10
	and 11,4
	jffo 11,%L284
	movei 12,44
%L284:
	move 4,12
	subi 4,44
	movn 3,4
	movn 4,1
	move 13,1
	and 13,4
	jffo 13,%L285
	movei 14,44
%L285:
	move 1,14
	subi 1,44
	movn 1,1
	xor 1,3
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.bss
ffs_ga:
	.space	4
ffs_gb:
	.space	4
ffs_vga:
	.space	4
ffs_buf:
	.space	64
uffs_ga:
	.space	4
uffs_gb:
	.space	4
uffs_vga:
	.space	4
uffs_buf:
	.space	64
ffs_gp:
	.space	8
uffs_gp:
	.space	8
ffs_gt:
	.space	12
