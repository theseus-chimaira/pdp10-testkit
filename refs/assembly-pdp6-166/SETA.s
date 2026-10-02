
seta_reg:
	popj 17,

seta_reg_2:
	popj 17,

seta_reg_phi:
	move 4,1
	move 1,2
	jumpe 3,%L4
	move 1,4
%L4:
	popj 17,

seta_from_global:
	move 1,seta_ga
	popj 17,

seta_from_global_b:
	move 1,seta_gb
	popj 17,

seta_from_array:
	andi 1,17
	move 1,seta_buf(1)
	popj 17,

seta_from_mem:
	move 1,(1)
	popj 17,

seta_from_struct_a:
	move 1,(1)
	popj 17,

seta_from_struct_b:
	move 1,1(1)
	popj 17,

seta_from_global_struct_a:
	move 1,seta_gp
	popj 17,

seta_from_global_struct_b:
	move 1,seta_gp+1
	popj 17,

seta_from_indirect:
	move 1,@(1)
	popj 17,

seta_from_volatile:
	move 1,(1)
	popj 17,

setam_mem:
	movem 1,(2)
	popj 17,

setam_global:
	movem 1,seta_ga
	popj 17,

setam_global_b:
	movem 1,seta_gb
	popj 17,

setam_array:
	andi 3,17
	add 2,3
	movem 1,(2)
	popj 17,

setam_global_array:
	andi 2,17
	movem 1,seta_buf(2)
	popj 17,

setam_struct_a:
	movem 1,(2)
	popj 17,

setam_struct_b:
	movem 1,1(2)
	popj 17,

setam_global_struct_a:
	movem 1,seta_gp
	popj 17,

setam_global_struct_b:
	movem 1,seta_gp+1
	popj 17,

setam_indirect:
	movem 1,@(2)
	popj 17,

setam_volatile:
	movem 1,(2)
	popj 17,

setab_mem:
	movem 1,(2)
	popj 17,

setab_mem_reload:
	movem 1,(2)
	popj 17,

setab_global:
	movem 1,seta_ga
	popj 17,

setab_global_reload:
	movem 1,seta_ga
	popj 17,

setab_global_b:
	movem 1,seta_gb
	popj 17,

setab_array:
	andi 3,17
	add 2,3
	movem 1,(2)
	popj 17,

setab_array_reload:
	andi 3,17
	add 2,3
	movem 1,(2)
	popj 17,

setab_global_array:
	andi 2,17
	movem 1,seta_buf(2)
	popj 17,

setab_global_array_reload:
	andi 2,17
	movem 1,seta_buf(2)
	popj 17,

setab_struct_a:
	movem 1,(2)
	popj 17,

setab_struct_a_reload:
	movem 1,(2)
	popj 17,

setab_struct_b:
	movem 1,1(2)
	popj 17,

setab_struct_b_reload:
	movem 1,1(2)
	popj 17,

setab_global_struct_a:
	movem 1,seta_gp
	popj 17,

setab_global_struct_a_reload:
	movem 1,seta_gp
	popj 17,

setab_global_struct_b:
	movem 1,seta_gp+1
	popj 17,

setab_global_struct_b_reload:
	movem 1,seta_gp+1
	popj 17,

setab_indirect:
	movem 1,@(2)
	popj 17,

setab_volatile:
	movem 1,(2)
	popj 17,

useta_reg:
	popj 17,

useta_from_global:
	move 1,seta_uga
	popj 17,

useta_from_mem:
	move 1,(1)
	popj 17,

useta_from_array:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

useta_from_struct_a:
	move 1,(1)
	popj 17,

useta_from_global_struct_a:
	move 1,seta_ugp
	popj 17,

usetam_mem:
	movem 1,(2)
	popj 17,

usetam_global:
	movem 1,seta_uga
	popj 17,

usetam_array:
	andi 3,17
	add 2,3
	movem 1,(2)
	popj 17,

usetam_global_array:
	andi 2,17
	movem 1,seta_ubuf(2)
	popj 17,

usetam_struct_a:
	movem 1,(2)
	popj 17,

usetab_mem:
	movem 1,(2)
	popj 17,

usetab_mem_reload:
	movem 1,(2)
	popj 17,

usetab_global:
	movem 1,seta_uga
	popj 17,

usetab_global_reload:
	movem 1,seta_uga
	popj 17,

usetab_array:
	andi 3,17
	add 2,3
	movem 1,(2)
	popj 17,

usetab_global_array:
	andi 2,17
	movem 1,seta_ubuf(2)
	popj 17,

seta_qi:
	lsh 1,33
	ash 1,-33
	popj 17,

seta_uqi:
	andi 1,777	; zero_extendqisi2
	popj 17,

seta_hi:
	hrre 1,1
	popj 17,

seta_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

setam_qi:
	dpb 1,2
	popj 17,

setam_uqi:
	dpb 1,2
	popj 17,

setam_hi:
	dpb 1,2	; movhi
	popj 17,

setam_uhi:
	dpb 1,2	; movhi
	popj 17,

setab_qi:
	andi 1,777	; zero_extendqisi2
	dpb 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

setab_uqi:
	andi 1,777	; zero_extendqisi2
	dpb 1,2
	popj 17,

setab_hi:
	hrrzi 1,(1)	; zero_extendhisi2
	dpb 1,2	; movhi
	hrre 1,1	; extendhisi2
	popj 17,

setab_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	dpb 1,2	; movhi
	popj 17,

seta_select:
	jumpn 3,%L81
	move 1,2
%L81:
	popj 17,

seta_after_call:
	push 17,10
	move 10,1
	pushj 17,f
	move 1,10
	pop 17,10
	popj 17,

seta_store_two:
	movem 1,(2)
	movem 1,(3)
	popj 17,

seta_store_chain:
	movem 1,(2)
	popj 17,

setab_bothaa:
	movem 1,(2)
	popj 17,

setab_bothab:
	movem 1,(2)
	popj 17,

setab_bothba:
	movem 1,(2)
	popj 17,

setab_bothbb:
	movem 1,(2)
	popj 17,

usetab_bothaa:
	movem 1,(2)
	popj 17,

usetab_bothab:
	movem 1,(2)
	popj 17,

usetab_bothba:
	movem 1,(2)
	popj 17,

usetab_bothbb:
	movem 1,(2)
	popj 17,

	.bss
seta_ga:
	.space	4
seta_gb:
	.space	4
seta_uga:
	.space	4
seta_buf:
	.space	64
seta_ubuf:
	.space	64
seta_gp:
	.space	8
seta_ugp:
	.space	8
