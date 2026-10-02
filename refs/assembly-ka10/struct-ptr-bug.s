
ptr_A:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_A_a:
	move 1,(1)
	popj 17,

store_A_a:
	movem 2,(1)
	popj 17,

update_A_a:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

addr_A_a:
	popj 17,

stack_addr_A_a:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_A_b:
	hlre 1,1(1)
	popj 17,

store_A_b:
	hrlm 2,1(1)
	popj 17,

update_A_b:
	hlrz 4,1(1)
	addi 4,(2)
	hrlm 4,1(1)
	hlre 1,1(1)
	popj 17,

addr_A_b:
	addi 1,1
	movei 1,(1)
	tlo 1,2200
	popj 17,

stack_addr_A_b:
	add 17,[2,,2]
	move 1,[POINT 18,1(<fp>),17]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

ptr_B:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_B_a:
	move 1,(1)
	popj 17,

store_B_a:
	movem 2,(1)
	popj 17,

update_B_a:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

addr_B_a:
	popj 17,

stack_addr_B_a:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_B_b:
	move 1,1(1)
	lsh 1,-33
	popj 17,

store_B_b:
	addi 1,1
	dpb 2,[POINT 9,(1),8]
	popj 17,

update_B_b:
	ldb 4,[POINT 9,1(1),8]
	add 4,2
	idpb 4,[POINT 9,(1),8]
	subi 1,1
	move 1,1(1)
	lsh 1,-33
	popj 17,

addr_B_b:
	addi 1,1
	movei 1,(1)
	tlo 1,2200
	popj 17,

stack_addr_B_b:
	add 17,[2,,2]
	move 1,[POINT 9,1(<fp>),8]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

ptr_C:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,222200
	pushj 17,scalar_memory_forms
	add 17,[-1,,-1]
	popj 17,

load_C_a:
	hlre 1,(1)
	popj 17,

store_C_a:
	hrlm 2,(1)
	popj 17,

update_C_a:
	hlrz 4,(1)
	addi 4,(2)
	hrlm 4,(1)
	hlre 1,(1)
	popj 17,

addr_C_a:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_C_a:
	add 17,[1,,1]
	move 1,[POINT 18,<fp>,17]
	pushj 17,scalar_memory_forms
	add 17,[-1,,-1]
	popj 17,

load_C_b:
	ldb 1,[POINT 9,(1),26]
	popj 17,

store_C_b:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),26]
	popj 17,

update_C_b:
	andi 2,777	; zero_extendqisi2
	ldb 4,[POINT 9,(1),26]
	add 2,4
	dpb 2,[POINT 9,(1),26]
	ldb 1,[POINT 9,(1),26]
	popj 17,

addr_C_b:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_C_b:
	add 17,[1,,1]
	move 1,[POINT 9,<fp>,26]
	pushj 17,scalar_memory_forms
	add 17,[-1,,-1]
	popj 17,

ptr_D:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,331100
	pushj 17,scalar_memory_forms
	add 17,[-1,,-1]
	popj 17,

load_D_a:
	move 1,(1)
	lsh 1,-33
	popj 17,

store_D_a:
	dpb 2,[POINT 9,(1),8]
	popj 17,

update_D_a:
	ldb 4,[POINT 9,(1),8]
	add 4,2
	dpb 4,[POINT 9,(1),8]
	move 1,(1)
	lsh 1,-33
	popj 17,

addr_D_a:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_D_a:
	add 17,[1,,1]
	move 1,[POINT 9,<fp>,8]
	pushj 17,scalar_memory_forms
	add 17,[-1,,-1]
	popj 17,

load_D_b:
	ldb 1,[POINT 9,(1),17]
	popj 17,

store_D_b:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),17]
	popj 17,

update_D_b:
	andi 2,777	; zero_extendqisi2
	ldb 4,[POINT 9,(1),17]
	add 2,4
	dpb 2,[POINT 9,(1),17]
	ldb 1,[POINT 9,(1),17]
	popj 17,

addr_D_b:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_D_b:
	add 17,[1,,1]
	move 1,[POINT 9,<fp>,17]
	pushj 17,scalar_memory_forms
	add 17,[-1,,-1]
	popj 17,

ptr_E:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_E_a:
	move 1,(1)
	popj 17,

store_E_a:
	movem 2,(1)
	popj 17,

update_E_a:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

addr_E_a:
	popj 17,

stack_addr_E_a:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_E_b:
	move 1,1(1)
	ash 1,-33
	popj 17,

store_E_b:
	addi 1,1
	dpb 2,[POINT 9,(1),8]
	popj 17,

update_E_b:
	ldb 4,[POINT 9,1(1),8]
	add 4,2
	idpb 4,[POINT 9,(1),8]
	subi 1,1
	move 1,1(1)
	ash 1,-33
	popj 17,

addr_E_b:
	addi 1,1
	movei 1,(1)
	tlo 1,2200
	popj 17,

stack_addr_E_b:
	add 17,[2,,2]
	move 1,[POINT 9,1(<fp>),8]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_E_c:
	hrre 1,1(1)
	popj 17,

store_E_c:
	hrrm 2,1(1)
	popj 17,

update_E_c:
	hrrz 4,1(1)
	addi 4,(2)
	hrrm 4,1(1)
	hrre 1,1(1)
	popj 17,

addr_E_c:
	addi 1,1
	movei 1,(1)
	tlo 1,2200
	popj 17,

stack_addr_E_c:
	add 17,[2,,2]
	move 1,[POINT 18,1(<fp>),26]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

ptr_F:
	add 17,[3,,3]
	movei 1,-2(17)
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_F_a:
	move 1,(1)
	ash 1,-33
	popj 17,

store_F_a:
	lsh 2,33
	movem 2,(1)
	popj 17,

update_F_a:
	andi 2,777	; zero_extendqisi2
	ldb 4,[POINT 9,(1),8]
	add 4,2
	lsh 4,33
	movem 4,(1)
	move 1,(1)
	ash 1,-33
	popj 17,

addr_F_a:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_F_a:
	add 17,[3,,3]
	move 1,[POINT 9,<fp>,8]
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_F_b:
	move 1,1(1)
	popj 17,

store_F_b:
	movem 2,1(1)
	popj 17,

update_F_b:
	move 4,2
	addb 4,1(1)
	move 1,4
	popj 17,

addr_F_b:
	addi 1,1
	popj 17,

stack_addr_F_b:
	add 17,[3,,3]
	movei 1,-2(17)
	addi 1,1
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_F_c:
	move 1,2(1)
	ash 1,-33
	popj 17,

store_F_c:
	addi 1,2
	dpb 2,[POINT 9,(1),8]
	popj 17,

update_F_c:
	ldb 4,[POINT 9,2(1),8]
	add 4,2
	addi 1,2
	dpb 4,[POINT 9,(1),8]
	subi 1,2
	move 1,2(1)
	ash 1,-33
	popj 17,

addr_F_c:
	addi 1,2
	movei 1,(1)
	tlo 1,2200
	popj 17,

stack_addr_F_c:
	add 17,[3,,3]
	move 1,[POINT 9,2(<fp>),8]
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

ptr_G:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_G_a:
	move 1,(1)
	ash 1,-36
	popj 17,

store_G_a:
	lsh 2,36
	ash 2,-36
	dpb 2,[POINT 6,(1),5]
	popj 17,

update_G_a:
	lsh 2,36
	ash 2,-36
	move 4,(1)
	ash 4,-36
	add 2,4
	dpb 2,[POINT 6,(1),5]
	move 1,(1)
	ash 1,-36
	popj 17,

addr_G_a:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

stack_addr_G_a:
	add 17,[2,,2]
	move 1,[POINT 6,<fp>,5]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_G_b:
	move 1,(1)
	lsh 1,7
	ash 1,-35
	popj 17,

store_G_b:
	lsh 2,35
	ash 2,-35
	dpb 2,[POINT 7,(1),13]
	popj 17,

update_G_b:
	lsh 2,35
	ash 2,-35
	move 4,(1)
	lsh 4,7
	ash 4,-35
	add 2,4
	dpb 2,[POINT 7,(1),13]
	move 1,(1)
	lsh 1,7
	ash 1,-35
	popj 17,

addr_G_b:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

stack_addr_G_b:
	add 17,[2,,2]
	move 1,[POINT 7,<fp>,12]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_G_c:
	move 1,(1)
	lsh 1,20
	ash 1,-34
	popj 17,

store_G_c:
	lsh 2,34
	ash 2,-34
	dpb 2,[POINT 8,(1),23]
	popj 17,

update_G_c:
	lsh 2,34
	ash 2,-34
	move 4,(1)
	lsh 4,20
	ash 4,-34
	add 2,4
	dpb 2,[POINT 8,(1),23]
	move 1,(1)
	lsh 1,20
	ash 1,-34
	popj 17,

addr_G_c:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

stack_addr_G_c:
	add 17,[2,,2]
	move 1,[POINT 8,<fp>,20]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_G_d:
	move 1,(1)
	lsh 1,33
	ash 1,-33
	popj 17,

store_G_d:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),35]
	popj 17,

update_G_d:
	andi 2,777	; zero_extendqisi2
	ldb 4,[POINT 9,(1),35]
	add 4,2
	dpb 4,[POINT 9,(1),35]
	move 1,(1)
	lsh 1,33
	ash 1,-33
	popj 17,

addr_G_d:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_G_d:
	add 17,[2,,2]
	move 1,[POINT 9,<fp>,29]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_G_e:
	move 1,1(1)
	popj 17,

store_G_e:
	movem 2,1(1)
	popj 17,

update_G_e:
	move 4,2
	addb 4,1(1)
	move 1,4
	popj 17,

addr_G_e:
	addi 1,1
	popj 17,

stack_addr_G_e:
	add 17,[2,,2]
	movei 1,-1(17)
	addi 1,1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

ptr_H:
	add 17,[3,,3]
	movei 1,-2(17)
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_H_a:
	move 1,(1)
	ash 1,-24
	popj 17,

store_H_a:
	lsh 2,24
	ash 2,-24
	dpb 2,[POINT 16,(1),15]
	popj 17,

update_H_a:
	lsh 2,24
	ash 2,-24
	move 4,(1)
	ash 4,-24
	add 2,4
	dpb 2,[POINT 16,(1),15]
	move 1,(1)
	ash 1,-24
	popj 17,

addr_H_a:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

stack_addr_H_a:
	add 17,[3,,3]
	move 1,[POINT 18,<fp>,17]
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_H_b:
	hrre 1,(1)
	popj 17,

store_H_b:
	hrrm 2,(1)
	popj 17,

update_H_b:
	hrrz 4,(1)
	addi 4,(2)
	hrrm 4,(1)
	hrre 1,(1)
	popj 17,

addr_H_b:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_H_b:
	add 17,[3,,3]
	movei 1,POINT 18,<fp>,35
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_H_c:
	move 1,1(1)
	ash 1,-4
	popj 17,

store_H_c:
	lsh 2,4
	movem 2,1(1)
	popj 17,

update_H_c:
	move 4,1(1)
	ash 4,-4
	add 4,2
	lsh 4,4
	movem 4,1(1)
	move 1,1(1)
	ash 1,-4
	popj 17,

addr_H_c:
	addi 1,1
	popj 17,

stack_addr_H_c:
	add 17,[3,,3]
	movei 1,-2(17)
	addi 1,1
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_H_d:
	move 1,2(1)
	popj 17,

store_H_d:
	movem 2,2(1)
	popj 17,

update_H_d:
	move 4,2
	addb 4,2(1)
	move 1,4
	popj 17,

addr_H_d:
	addi 1,2
	popj 17,

stack_addr_H_d:
	add 17,[3,,3]
	movei 1,-2(17)
	addi 1,2
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

ptr_I:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_I_a:
	move 1,(1)
	lsh 1,-33
	popj 17,

store_I_a:
	dpb 2,[POINT 9,(1),8]
	popj 17,

update_I_a:
	ldb 4,[POINT 9,(1),8]
	add 4,2
	dpb 4,[POINT 9,(1),8]
	move 1,(1)
	lsh 1,-33
	popj 17,

addr_I_a:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_I_a:
	add 17,[2,,2]
	move 1,[POINT 9,<fp>,8]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_I_b:
	ldb 1,[POINT 9,(1),17]
	popj 17,

store_I_b:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,(1),17]
	popj 17,

update_I_b:
	andi 2,777	; zero_extendqisi2
	ldb 4,[POINT 9,(1),17]
	add 2,4
	dpb 2,[POINT 9,(1),17]
	ldb 1,[POINT 9,(1),17]
	popj 17,

addr_I_b:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_I_b:
	add 17,[2,,2]
	move 1,[POINT 9,<fp>,17]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_I_c:
	hrrz 1,(1)
	popj 17,

store_I_c:
	hrrm 2,(1)
	popj 17,

update_I_c:
	hrrz 4,(1)
	addi 4,(2)
	hrrm 4,(1)
	hrrz 1,(1)
	popj 17,

addr_I_c:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_I_c:
	add 17,[2,,2]
	movei 1,POINT 18,<fp>,35
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_I_d:
	move 1,1(1)
	popj 17,

store_I_d:
	movem 2,1(1)
	popj 17,

update_I_d:
	move 4,2
	addb 4,1(1)
	move 1,4
	popj 17,

addr_I_d:
	addi 1,1
	popj 17,

stack_addr_I_d:
	add 17,[2,,2]
	movei 1,-1(17)
	addi 1,1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

ptr_J:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_J_a:
	move 1,(1)
	popj 17,

store_J_a:
	dpb 2,1
	popj 17,

update_J_a:
	andi 2,777	; zero_extendqisi2
	add 2,(1)
	dpb 2,1
	move 1,(1)
	popj 17,

addr_J_a:
	hrrz 1,1
	tlo 1,2200
	popj 17,

stack_addr_J_a:
	add 17,[2,,2]
	move 1,[POINT 9,<fp>,8]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_J_b:
	move 4,1
	ldb 1,1
	move 3,1
	lsh 3,33
	tlo 3,(1)
	lsh 1,11
	ior 1,3
	addi 4,1
	ldb 4,4
	ior 1,4
	popj 17,

store_J_b:
	movem 2,(1)
	popj 17,

update_J_b:
	ldb 4,1
	move 3,4
	lsh 3,33
	tlo 3,(4)
	lsh 4,11
	ior 4,3
	move 3,1
	addi 3,1
	ldb 6,3
	ior 4,6
	add 4,2
	movem 4,(1)
	ldb 1,1
	move 4,1
	lsh 4,33
	tlo 4,(1)
	lsh 1,11
	ior 1,4
	ldb 3,3
	ior 1,3
	popj 17,

addr_J_b:
	popj 17,

stack_addr_J_b:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_J_c:
	move 1,1(1)
	popj 17,

store_J_c:
	addi 1,1
	dpb 2,1
	popj 17,

update_J_c:
	andi 2,777	; zero_extendqisi2
	add 2,1(1)
	idpb 2,1
	subi 1,1
	move 1,1(1)
	popj 17,

addr_J_c:
	addi 1,1
	movei 1,(1)
	tlo 1,2200
	popj 17,

stack_addr_J_c:
	add 17,[2,,2]
	move 1,[POINT 9,2(<fp>),8]
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

ptr_Outer:
	add 17,[3,,3]
	movei 1,-2(17)
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_Outer_head:
	move 1,(1)
	popj 17,

store_Outer_head:
	movem 2,(1)
	popj 17,

update_Outer_head:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

addr_Outer_head:
	popj 17,

stack_addr_Outer_head:
	add 17,[3,,3]
	movei 1,-2(17)
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_Outer_tail:
	move 1,2(1)
	ash 1,-33
	popj 17,

store_Outer_tail:
	addi 1,2
	dpb 2,[POINT 9,(1),8]
	popj 17,

update_Outer_tail:
	ldb 4,[POINT 9,2(1),8]
	add 4,2
	addi 1,2
	dpb 4,[POINT 9,(1),8]
	subi 1,2
	move 1,2(1)
	ash 1,-33
	popj 17,

addr_Outer_tail:
	addi 1,2
	movei 1,(1)
	tlo 1,2200
	popj 17,

stack_addr_Outer_tail:
	add 17,[3,,3]
	move 1,[POINT 9,2(<fp>),8]
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

ptr_Arr:
	add 17,[4,,4]
	movei 1,-3(17)
	pushj 17,scalar_memory_forms
	add 17,[-4,,-4]
	popj 17,

load_Arr_head:
	move 1,(1)
	popj 17,

store_Arr_head:
	movem 2,(1)
	popj 17,

update_Arr_head:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

addr_Arr_head:
	popj 17,

stack_addr_Arr_head:
	add 17,[4,,4]
	movei 1,-3(17)
	pushj 17,scalar_memory_forms
	add 17,[-4,,-4]
	popj 17,

ptr_Bits:
	add 17,[2,,2]
	movei 1,-1(17)
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_Bits_d:
	move 1,1(1)
	popj 17,

store_Bits_d:
	movem 2,1(1)
	popj 17,

update_Bits_d:
	move 4,2
	addb 4,1(1)
	move 1,4
	popj 17,

addr_Bits_d:
	addi 1,1
	popj 17,

stack_addr_Bits_d:
	add 17,[2,,2]
	movei 1,-1(17)
	addi 1,1
	pushj 17,scalar_memory_forms
	add 17,[-2,,-2]
	popj 17,

load_outer_q:
	move 1,1(1)
	ash 1,-33
	popj 17,

store_outer_q:
	addi 1,1
	dpb 2,[POINT 9,(1),8]
	popj 17,

load_outer_h:
	hrre 1,1(1)
	popj 17,

store_outer_h:
	hrrm 2,1(1)
	popj 17,

addr_outer_q:
	addi 1,1
	movei 1,(1)
	tlo 1,2200
	popj 17,

addr_outer_h:
	addi 1,1
	movei 1,(1)
	tlo 1,2200
	popj 17,

stack_outer_fields:
	add 17,[3,,3]
	move 1,[POINT 18,1(<fp>),17]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,1(<fp>),8]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,1(<fp>),26]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,2(<fp>),8]
	pushj 17,scalar_memory_forms
	add 17,[-3,,-3]
	popj 17,

load_arr_q:
	tlo 1,331100
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L304
%L303:
	ibp 1
	sojn 4,%L303	; decrement_and_branch_until_zero
%L304:
	addi 1,1
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_arr_q:
	andi 3,777	; zero_extendqisi2
	tlo 1,331100
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L308
%L307:
	ibp 1
	sojn 4,%L307	; decrement_and_branch_until_zero
%L308:
	addi 1,1
	dpb 3,1
	popj 17,

load_arr_h:
	tlo 1,222200
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L312
%L311:
	ibp 1
	sojn 4,%L311	; decrement_and_branch_until_zero
%L312:
	addi 1,2
	ldb 1,1
	hrre 1,1
	popj 17,

store_arr_h:
	hrrzi 3,(3)	; zero_extendhisi2
	tlo 1,222200
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L316
%L315:
	ibp 1
	sojn 4,%L315	; decrement_and_branch_until_zero
%L316:
	addi 1,2
	dpb 3,1	; movhi
	popj 17,

load_arr_c:
	tlo 1,331100
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L320
%L319:
	ibp 1
	sojn 4,%L319	; decrement_and_branch_until_zero
%L320:
	addi 1,3
	ldb 1,1
	popj 17,

store_arr_c:
	andi 3,777	; zero_extendqisi2
	tlo 1,331100
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L324
%L323:
	ibp 1
	sojn 4,%L323	; decrement_and_branch_until_zero
%L324:
	addi 1,3
	dpb 3,1
	popj 17,

addr_arr_q:
	tlo 1,331100
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L329
%L328:
	ibp 1
	sojn 4,%L328	; decrement_and_branch_until_zero
%L329:
	addi 1,1
	movei 1,(1)
	tlo 1,2200
	popj 17,

addr_arr_h:
	tlo 1,222200
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L335
%L334:
	ibp 1
	sojn 4,%L334	; decrement_and_branch_until_zero
%L335:
	addi 1,2
	movei 1,(1)
	tlo 1,2200
	popj 17,

addr_arr_c:
	tlo 1,331100
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L340
%L339:
	ibp 1
	sojn 4,%L339	; decrement_and_branch_until_zero
%L340:
	addi 1,3
	movei 1,(1)
	tlo 1,2200
	popj 17,

diff_arr_q:
	setzb 4,5
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_arr_h:
	setzb 4,5
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

diff_arr_c:
	setzb 4,5
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_bits_a:
	hlrz 1,(1)
	popj 17,

load_bits_b:
	move 1,(1)
	lsh 1,22
	ash 1,-33
	popj 17,

load_bits_c:
	ldb 1,[POINT 9,(1),35]
	popj 17,

store_bits:
	hrlm 2,(1)
	dpb 3,[POINT 9,(1),26]
	dpb 4,[POINT 9,(1),35]
	popj 17,

load_global_members:
	hlre 1,ga+1
	add 1,ga
	add 1,gb
	move 4,gb+1
	lsh 4,-33
	add 1,4
	hlre 4,gc
	add 1,4
	ldb 4,[POINT 9,gc,26]
	add 1,4
	move 4,gd
	lsh 4,-33
	add 1,4
	ldb 4,[POINT 9,gd,17]
	add 1,4
	add 1,ge
	move 4,ge+1
	ash 4,-33
	add 1,4
	hrre 4,ge+1
	add 1,4
	move 4,gf
	ash 4,-33
	add 1,4
	add 1,gf+1
	move 4,gf+2
	ash 4,-33
	add 1,4
	move 4,gg
	ash 4,-36
	add 1,4
	move 4,gg
	lsh 4,7
	ash 4,-35
	add 1,4
	move 4,gg
	lsh 4,20
	ash 4,-34
	add 1,4
	move 4,gg
	lsh 4,33
	ash 4,-33
	add 1,4
	add 1,gg+1
	move 4,gh
	ash 4,-24
	add 1,4
	hrre 4,gh
	add 1,4
	move 4,gh+1
	ash 4,-4
	add 1,4
	add 1,gh+2
	move 4,gi
	lsh 4,-33
	add 1,4
	ldb 4,[POINT 9,gi,17]
	add 1,4
	hrrz 4,gi
	add 1,4
	add 1,gi+1
	move 4,gj
	lsh 4,-33
	add 1,4
	ldb 4,gj
	move 3,4
	lsh 3,33
	tlo 3,(4)
	lsh 4,11
	ior 4,3
	ldb 6,gj+1
	ior 4,6
	add 1,4
	ldb 4,[POINT 9,gj+1,17]
	add 1,4
	add 1,go
	move 4,go+1
	ash 4,-33
	add 1,4
	hrre 4,go+1
	add 1,4
	move 4,go+2
	ash 4,-33
	add 1,4
	add 1,garr
	move 4,garr+1
	lsh 4,11
	ash 4,-33
	add 1,4
	hrre 4,garr+2
	add 1,4
	ldb 4,[POINT 9,garr+3,17]
	add 1,4
	hlrz 4,gbits
	add 1,4
	move 4,gbits
	lsh 4,22
	ash 4,-33
	add 1,4
	ldb 4,[POINT 9,gbits,35]
	add 1,4
	add 1,gbits+1
	popj 17,

load_volatile_members:
	hlrz 4,vga+1
	hrre 4,4
	move 1,vga
	add 1,4
	move 4,vge
	add 1,4
	ldb 4,[POINT 9,vge+1,8]
	lsh 4,33
	ash 4,-33
	add 1,4
	hrrz 4,vge+1
	hrre 4,4
	add 1,4
	move 4,vgarr
	add 1,4
	ldb 4,[POINT 9,vgarr+1,8]
	lsh 4,33
	ash 4,-33
	add 1,4
	hlrz 4,vgarr+2
	hrre 4,4
	add 1,4
	ldb 4,[POINT 9,vgarr+3,8]
	add 1,4
	popj 17,

store_global_members:
	movem 1,ga
	addi 1,1
	hrlm 1,ga+1
	sos 6,1
	addi 6,2
	movem 6,gb
	addi 1,3
	dpb 1,[POINT 9,gb+1,8]
	addi 1,1
	hrlm 1,gc
	addi 1,1
	dpb 1,[POINT 9,gc,26]
	addi 1,1
	dpb 1,[POINT 9,gd,8]
	addi 1,1
	dpb 1,[POINT 9,gd,17]
	subi 1,7
	addi 6,6
	movem 6,ge
	addi 1,11
	dpb 1,[POINT 9,ge+1,8]
	addi 1,1
	hrrm 1,ge+1
	subi 1,12
	move 4,1
	lsh 4,33
	add 4,[13000000000]
	movem 4,gf
	addi 6,4
	movem 6,gf+1
	addi 1,15
	dpb 1,[POINT 9,gf+2,8]
	addi 1,1
	dpb 1,[POINT 6,gg,5]
	addi 1,1
	dpb 1,[POINT 7,gg,13]
	addi 1,1
	dpb 1,[POINT 8,gg,23]
	addi 1,1
	dpb 1,[POINT 9,gg,35]
	subi 1,21
	addi 6,6
	movem 6,gg+1
	addi 1,23
	dpb 1,[POINT 16,gh,15]
	addi 1,1
	hrrm 1,gh
	subi 1,24
	move 4,1
	lsh 4,4
	addi 4,520
	movem 4,gh+1
	addi 6,4
	movem 6,gh+2
	addi 1,27
	dpb 1,[POINT 9,gi,8]
	addi 1,1
	dpb 1,[POINT 9,gi,17]
	addi 1,1
	hrrm 1,gi
	subi 1,31
	addi 6,4
	movem 6,gi+1
	addi 1,33
	dpb 1,gj
	subi 1,33
	addi 6,2
	movem 6,gj
	addi 1,35
	dpb 1,gj+1
	popj 17,

stack_component_mix:
	add 17,[21,,21]
	movem 10,-20(17)
	movem 11,-17(17)
	movem 1,-7(17)
	addi 1,1
	movei 3,-7(17)
	hrlm 1,1(3)
	sos 6,1
	addi 6,2
	movem 6,-5(17)
	addi 1,3
	movei 11,-5(17)
	idpb 1,[POINT 9,(11),8]
	subi 1,3
	subi 11,1
	hrrz 4,-1(17)
	tlo 4,4(1)
	addi 1,5
	dpb 1,[POINT 9,4,26]
	movem 4,-1(17)
	addi 1,1
	move 4,(17)
	dpb 1,[POINT 9,4,8]
	addi 1,1
	dpb 1,[POINT 9,4,17]
	subi 1,7
	movem 4,(17)
	addi 6,6
	movem 6,-3(17)
	addi 1,11
	movei 10,-3(17)
	idpb 1,[POINT 9,(10),8]
	subi 10,1
	addi 1,1
	hrrm 1,1(10)
	subi 1,12
	move 4,1
	lsh 4,33
	add 4,[13000000000]
	movem 4,-16(17)
	addi 6,4
	movem 6,-15(17)
	addi 1,15
	movem 1,-14(17)
	subi 1,15
	addi 6,2
	movem 6,-13(17)
	addi 1,17
	movem 1,-12(17)
	addi 1,1
	dpb 1,[POINT 9,-12(17),17]
	addi 1,1
	dpb 1,[POINT 9,-12(17),26]
	addi 1,1
	movem 1,-11(17)
	addi 1,1
	hrrm 1,-11(17)
	addi 1,1
	movem 1,-10(17)
	addi 1,1
	dpb 1,[POINT 9,-10(17),17]
	addi 1,1
	dpb 1,[POINT 9,-10(17),26]
	addi 1,1
	dpb 1,[POINT 9,-10(17),35]
	move 1,3
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,10(<fp>),17]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,12(<fp>),8]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,15(<fp>),17]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,15(<fp>),26]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,16(<fp>),8]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,16(<fp>),17]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,14(<fp>),8]
	pushj 17,scalar_memory_forms
	move 1,[POINT 18,14(<fp>),26]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,<fp>,8]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,2(<fp>),8]
	pushj 17,scalar_memory_forms
	move 1,[POINT 9,4(<fp>),17]
	pushj 17,scalar_memory_forms
	movei 1,POINT 18,5(<fp>),35
	pushj 17,scalar_memory_forms
	movei 1,POINT 9,6(<fp>),35
	pushj 17,scalar_memory_forms
	hlre 1,-6(17)
	add 1,-7(17)
	add 1,(11)
	move 4,1(11)
	lsh 4,-33
	add 1,4
	movei 3,-1(17)
	hlre 4,(3)
	add 1,4
	ldb 4,[POINT 9,(3),26]
	add 1,4
	movei 3,(17)
	move 4,(3)
	lsh 4,-33
	add 1,4
	ldb 4,[POINT 9,(3),17]
	add 1,4
	add 1,(10)
	move 4,1(10)
	ash 4,-33
	add 1,4
	hrre 4,1(10)
	add 1,4
	move 4,-16(17)
	ash 4,-33
	add 1,4
	add 1,-15(17)
	move 4,-14(17)
	ash 4,-33
	add 1,4
	add 1,-13(17)
	move 4,-12(17)
	ash 4,-33
	add 1,4
	move 4,-12(17)
	lsh 4,11
	ash 4,-33
	add 1,4
	move 4,-12(17)
	lsh 4,22
	ash 4,-33
	add 1,4
	hlre 4,-11(17)
	add 1,4
	hrre 4,-11(17)
	add 1,4
	move 4,-10(17)
	lsh 4,-33
	add 1,4
	ldb 4,[POINT 9,-10(17),17]
	add 1,4
	ldb 4,[POINT 9,-10(17),26]
	add 1,4
	move 4,-10(17)
	andi 4,777
	add 1,4
	move 10,-20(17)
	move 11,-17(17)
	add 17,[-21,,-21]
	popj 17,

component_branch:
	move 3,1(1)
	ash 3,-33
	move 4,2
	lsh 4,33
	ash 4,-33
	seto 6,
	camge 3,4
	jrst %L367
	hrre 3,1(1)
	hrre 4,2	; extendhisi2
	camn 3,4
	tdza 6,6
	movei 6,1
%L367:
	move 1,6
	popj 17,

component_call:
	push 17,10
	move 10,1
	move 1,(1)
	pushj 17,use_int
	move 1,1(10)
	lsh 1,11
	ash 1,-33
	pushj 17,use_int
	hrre 1,2(10)
	pushj 17,use_int
	ldb 1,[POINT 9,3(10),17]
	pushj 17,use_int
	movei 6,1
	add 6,10
	movei 1,(6)
	tlo 1,2200
	pushj 17,use_ptr
	movei 6,2
	add 6,10
	movei 1,(6)
	tlo 1,2200
	tlc 1,113300
	pushj 17,use_ptr
	addi 10,3
	movei 10,(10)
	tlo 10,2200
	move 1,10
	pop 17,10
	jrst use_ptr

	.globl	use_struct_ptr_bug
use_struct_ptr_bug:
	add 17,[23,,23]
	movem 16,-22(17)
	movei 0,-21(17)
	hrli 0,10
	blt 0,-14(17)
	move 11,1
	pushj 17,store_global_members
	movem 11,-4(17)
	move 3,11
	addi 3,1
	movei 6,-4(17)
	addi 6,1
	movem 6,(17)
	dpb 3,[POINT 9,(6),8]
	sos (17)
	move 4,11
	addi 4,2
	move 6,(17)
	hrrm 4,1(6)
	move 6,11
	addi 6,3
	movem 6,-13(17)
	addi 11,4
	movem 11,-12(17)
	addi 11,1
	hrrm 11,-12(17)
	addi 11,1
	movem 11,-11(17)
	subi 11,6
	addi 6,4
	movem 6,-10(17)
	addi 11,10
	movem 11,-7(17)
	addi 11,1
	dpb 11,[POINT 9,-7(17),17]
	addi 11,1
	dpb 11,[POINT 9,-7(17),26]
	addi 11,1
	movem 11,-6(17)
	addi 11,1
	hrrm 11,-6(17)
	addi 11,1
	movem 11,-5(17)
	addi 11,1
	dpb 11,[POINT 9,-5(17),17]
	addi 11,1
	dpb 11,[POINT 9,-5(17),26]
	addi 11,1
	dpb 11,[POINT 9,-5(17),35]
	subi 11,20
	movei 1,-2(17)
	move 2,11
	pushj 17,store_bits
	movei 14,-13(17)
	addi 11,21
	move 2,11
	lsh 2,33
	ash 2,-33
	move 1,14
	pushj 17,store_outer_q
	addi 11,1
	hrre 2,11	; extendhisi2
	move 1,14
	pushj 17,store_outer_h
	movei 12,-10(17)
	addi 11,1
	move 3,11
	lsh 3,33
	ash 3,-33
	move 1,12
	movei 2,1
	pushj 17,store_arr_q
	addi 11,1
	hrre 3,11	; extendhisi2
	move 1,12
	movei 2,1
	pushj 17,store_arr_h
	addi 11,1
	move 3,11
	andi 3,777	; zero_extendqisi2
	subi 11,25
	move 1,12
	movei 2,2
	pushj 17,store_arr_c
	move 1,12
	pushj 17,component_call
	pushj 17,load_global_members
	move 15,1
	pushj 17,load_volatile_members
	add 15,1
	move 1,11
	pushj 17,stack_component_mix
	add 15,1
	move 1,(17)
	pushj 17,load_E_b
	lsh 1,33
	ash 1,-33
	add 15,1
	move 1,(17)
	pushj 17,load_E_c
	hrre 1,1	; extendhisi2
	add 15,1
	move 1,(17)
	movei 2,1
	pushj 17,update_E_b
	lsh 1,33
	ash 1,-33
	add 15,1
	move 1,(17)
	movei 2,1
	pushj 17,update_E_c
	hrre 1,1	; extendhisi2
	add 15,1
	move 1,14
	pushj 17,load_outer_q
	lsh 1,33
	ash 1,-33
	add 15,1
	move 1,14
	pushj 17,load_outer_h
	hrre 1,1	; extendhisi2
	add 15,1
	move 1,12
	movei 2,1
	pushj 17,load_arr_q
	lsh 1,33
	ash 1,-33
	add 15,1
	move 1,12
	movei 2,1
	pushj 17,load_arr_h
	hrre 1,1	; extendhisi2
	add 15,1
	move 1,12
	movei 2,2
	pushj 17,load_arr_c
	add 15,1
	move 1,12
	pushj 17,diff_arr_q
	add 15,1
	move 1,12
	pushj 17,diff_arr_h
	add 15,1
	move 1,12
	pushj 17,diff_arr_c
	add 15,1
	move 1,(17)
	pushj 17,addr_E_b
	move 10,1
	move 1,14
	pushj 17,addr_outer_q
	came 10,1
	tdza 10,10
	movei 10,1
	add 15,10
	move 1,(17)
	pushj 17,addr_E_c
	move 10,1
	move 1,14
	pushj 17,addr_outer_h
	came 10,1
	tdza 10,10
	movei 10,1
	add 15,10
	move 1,12
	movei 2,0
	pushj 17,addr_arr_q
	move 10,1
	move 1,12
	movei 2,2
	pushj 17,addr_arr_q
	camn 10,1
	tdza 10,10
	movei 10,1
	add 15,10
	move 1,12
	movei 2,0
	pushj 17,addr_arr_h
	move 10,1
	move 1,12
	movei 2,1
	pushj 17,addr_arr_h
	camn 10,1
	tdza 10,10
	movei 10,1
	add 15,10
	movei 1,-2(17)
	pushj 17,load_bits_a
	move 14,1
	movei 1,-2(17)
	pushj 17,load_bits_b
	move 13,1
	movei 1,-2(17)
	pushj 17,load_bits_c
	move 16,1
	move 1,(17)
	move 2,11
	pushj 17,component_branch
	move 11,1
	move 1,12
	movei 2,0
	pushj 17,addr_arr_c
	move 10,1
	move 1,12
	movei 2,3
	pushj 17,addr_arr_c
	camn 10,1
	jrst %L446
	move 1,14
	add 1,15
	add 1,13
	add 1,16
	add 1,11
	addi 1,1
%L447:
	move 16,-22(17)
	movei 0,10
	hrli 0,-21(17)
	blt 0,15
	add 17,[-23,,-23]
	popj 17,
%L446:
	move 1,14
	add 1,15
	add 1,13
	add 1,16
	add 1,11
	jrst %L447

	.bss
ga:
	.space	8
gb:
	.space	8
gc:
	.space	4
gd:
	.space	4
ge:
	.space	8
gf:
	.space	12
gg:
	.space	8
gh:
	.space	12
gi:
	.space	8
gj:
	.space	8
go:
	.space	12
garr:
	.space	16
gbits:
	.space	8
vga:
	.space	8
vge:
	.space	8
vgarr:
	.space	16
