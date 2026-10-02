
scalar_memory_forms:
	addi 1,3
	popj 17,

bar:
	addi 1,24
	ibp 1
	ibp 1
	ibp 1
	popj 17,

baz:
	addi 1,24
	ibp 1
	ibp 1
	ibp 1
	popj 17,

baz1:
	ibp 1
	popj 17,

baz2:
	ibp 1
	ibp 1
	popj 17,

baz3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

baz4:
	addi 1,1
	popj 17,

baz5:
	addi 1,1
	ibp 1
	popj 17,

baz6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

baz7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

baz8:
	addi 1,2
	popj 17,

baz9:
	addi 1,2
	ibp 1
	popj 17,

s_add_0:
	popj 17,

s_add_1:
	addi 1,3
	popj 17,

s_add_2:
	addi 1,6
	popj 17,

s_add_3:
	addi 1,11
	popj 17,

s_add_7:
	addi 1,25
	popj 17,

s_add_0123:
	addi 1,371
	popj 17,

s_sub_1:
	subi 1,3
	popj 17,

s_sub_2:
	subi 1,6
	popj 17,

s_sub_7:
	subi 1,25
	popj 17,

s_sub_0123:
	subi 1,371
	popj 17,

s_global_base_add_1:
	movei 1,s_global+3
	popj 17,

s_global_base_add_2:
	movei 1,s_global+6
	popj 17,

q7_add_1:
	addi 1,2
	popj 17,

q7_add_2:
	addi 1,4
	popj 17,

q7_add_3:
	addi 1,6
	popj 17,

q7_add_4:
	addi 1,10
	popj 17,

q7_add_5:
	addi 1,12
	popj 17,

q7_add_7:
	addi 1,16
	popj 17,

q7_add_8:
	addi 1,20
	popj 17,

q7_add_9:
	addi 1,22
	popj 17,

q7_add_0123:
	addi 1,246
	popj 17,

q7_sub_1:
	subi 1,2
	popj 17,

q7_sub_2:
	subi 1,4
	popj 17,

q7_sub_0123:
	subi 1,246
	popj 17,

q8_add_1:
	addi 1,2
	popj 17,

q8_add_2:
	addi 1,4
	popj 17,

q8_add_0123:
	addi 1,246
	popj 17,

q9_add_1:
	addi 1,3
	popj 17,

q9_add_2:
	addi 1,6
	popj 17,

q9_add_0123:
	addi 1,371
	popj 17,

q10_add_1:
	addi 1,3
	popj 17,

q10_add_2:
	addi 1,6
	popj 17,

q10_add_0123:
	addi 1,371
	popj 17,

h3_add_1:
	addi 1,2
	popj 17,

h3_add_2:
	addi 1,4
	popj 17,

h3_add_3:
	addi 1,6
	popj 17,

h3_add_0123:
	addi 1,246
	popj 17,

h3_sub_1:
	subi 1,2
	popj 17,

h3_sub_0123:
	subi 1,246
	popj 17,

h4_add_1:
	addi 1,2
	popj 17,

h4_add_2:
	addi 1,4
	popj 17,

h4_add_0123:
	addi 1,246
	popj 17,

h5_add_1:
	addi 1,3
	popj 17,

h5_add_2:
	addi 1,6
	popj 17,

h5_add_0123:
	addi 1,371
	popj 17,

word_struct_add_1:
	addi 1,1
	popj 17,

word_struct_add_2:
	addi 1,2
	popj 17,

word_struct_add_0123:
	addi 1,123
	popj 17,

word_struct_sub_1:
	subi 1,1
	popj 17,

word3_struct_add_1:
	addi 1,3
	popj 17,

word3_struct_add_2:
	addi 1,6
	popj 17,

word3_struct_add_0123:
	addi 1,371
	popj 17,

mixed_qw_add_1:
	addi 1,2
	popj 17,

mixed_qw_add_2:
	addi 1,4
	popj 17,

mixed_qw_add_0123:
	addi 1,246
	popj 17,

mixed_qw_sub_1:
	subi 1,2
	popj 17,

mixed_hq_add_1:
	addi 1,2
	popj 17,

mixed_hq_add_2:
	addi 1,4
	popj 17,

mixed_hq_add_0123:
	addi 1,246
	popj 17,

nested_add_1:
	addi 1,4
	popj 17,

nested_add_2:
	addi 1,10
	popj 17,

nested_add_0123:
	addi 1,514
	popj 17,

q_add_0:
	popj 17,

q_add_1:
	ibp 1
	popj 17,

q_add_2:
	ibp 1
	ibp 1
	popj 17,

q_add_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

q_add_4:
	addi 1,1
	popj 17,

q_add_5:
	addi 1,1
	ibp 1
	popj 17,

q_add_6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

q_add_7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

q_add_8:
	addi 1,2
	popj 17,

q_add_9:
	addi 1,2
	ibp 1
	popj 17,

q_add_0123:
	addi 1,24
	ibp 1
	ibp 1
	ibp 1
	popj 17,

q_add_01000:
	addi 1,200
	popj 17,

q_sub_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

q_sub_2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

q_sub_3:
	subi 1,1
	ibp 1
	popj 17,

q_sub_4:
	subi 1,1
	popj 17,

q_sub_0123:
	subi 1,25
	ibp 1
	popj 17,

uq_add_1:
	ibp 1
	popj 17,

uq_add_2:
	ibp 1
	ibp 1
	popj 17,

uq_add_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

uq_add_4:
	addi 1,1
	popj 17,

uq_add_0123:
	addi 1,24
	ibp 1
	ibp 1
	ibp 1
	popj 17,

uq_sub_0123:
	subi 1,25
	ibp 1
	popj 17,

h_add_1:
	ibp 1
	popj 17,

h_add_2:
	addi 1,1
	popj 17,

h_add_3:
	addi 1,1
	ibp 1
	popj 17,

h_add_4:
	addi 1,2
	popj 17,

h_add_5:
	addi 1,2
	ibp 1
	popj 17,

h_add_0123:
	addi 1,51
	ibp 1
	popj 17,

h_add_01000:
	addi 1,400
	popj 17,

h_sub_1:
	subi 1,1
	ibp 1
	popj 17,

h_sub_2:
	subi 1,1
	popj 17,

h_sub_3:
	subi 1,2
	ibp 1
	popj 17,

h_sub_0123:
	subi 1,52
	ibp 1
	popj 17,

uh_add_1:
	ibp 1
	popj 17,

uh_add_2:
	addi 1,1
	popj 17,

uh_add_3:
	addi 1,1
	ibp 1
	popj 17,

uh_add_0123:
	addi 1,51
	ibp 1
	popj 17,

uh_sub_0123:
	subi 1,52
	ibp 1
	popj 17,

w_add_1:
	addi 1,1
	popj 17,

w_add_2:
	addi 1,2
	popj 17,

w_add_3:
	addi 1,3
	popj 17,

w_add_0123:
	addi 1,123
	popj 17,

w_add_01000:
	addi 1,1000
	popj 17,

w_sub_1:
	subi 1,1
	popj 17,

w_sub_0123:
	subi 1,123
	popj 17,

uw_add_1:
	addi 1,1
	popj 17,

uw_add_2:
	addi 1,2
	popj 17,

uw_add_0123:
	addi 1,123
	popj 17,

uw_sub_0123:
	subi 1,123
	popj 17,

c_add_1:
	ibp 1
	popj 17,

c_add_2:
	ibp 1
	ibp 1
	popj 17,

c_add_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

c_add_4:
	addi 1,1
	popj 17,

c_add_5:
	addi 1,1
	ibp 1
	popj 17,

c_add_0123:
	addi 1,24
	ibp 1
	ibp 1
	ibp 1
	popj 17,

c_sub_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

c_sub_2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

c_sub_0123:
	subi 1,25
	ibp 1
	popj 17,

q7_base_add_1:
	move 1,[POINT 9,q7_buf+2,8]
	popj 17,

q7_base_add_2:
	move 1,[POINT 9,q7_buf+4,8]
	popj 17,

q7_base_add_0123:
	move 1,[POINT 9,q7_buf+246,8]
	popj 17,

q8_base_add_1:
	move 1,[POINT 9,q8_buf+2,8]
	popj 17,

q9_base_add_1:
	move 1,[POINT 9,q9_buf+3,8]
	popj 17,

q10_base_add_1:
	move 1,[POINT 9,q10_buf+3,8]
	popj 17,

h3_base_add_1:
	move 1,[POINT 18,h3_buf+2,17]
	popj 17,

h4_base_add_1:
	move 1,[POINT 18,h4_buf+2,17]
	popj 17,

h5_base_add_1:
	move 1,[POINT 18,h5_buf+3,17]
	popj 17,

word_base_add_1:
	movei 1,word_buf+1
	popj 17,

word3_base_add_1:
	movei 1,word3_buf+3
	popj 17,

mixed_qw_base_add_1:
	movei 1,mixed_qw_buf+2
	popj 17,

mixed_hq_base_add_1:
	move 1,[POINT 18,mixed_hq_buf+2,17]
	popj 17,

nested_base_add_1:
	movei 1,nested_buf+4
	popj 17,

q_base_add_0123:
	move 1,[POINT 9,q_buf+24,35]
	popj 17,

h_base_add_0123:
	move 1,[POINT 18,h_buf+51,35]
	popj 17,

w_base_add_0123:
	movei 1,w_buf+123
	popj 17,

c_base_add_0123:
	move 1,[POINT 9,c_buf+24,35]
	popj 17,

q_load_add_1:
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_add_2:
	ibp 1
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_add_3:
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_add_4:
	addi 1,1
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_add_0123:
	addi 1,24
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_sub_1:
	subi 1,1
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_sub_0123:
	subi 1,25
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_store_add_1:
	idpb 2,1
	popj 17,

q_store_add_2:
	ibp 1
	idpb 2,1
	popj 17,

q_store_add_3:
	ibp 1
	ibp 1
	idpb 2,1
	popj 17,

q_store_add_4:
	addi 1,1
	dpb 2,1
	popj 17,

q_store_add_0123:
	addi 1,24
	ibp 1
	ibp 1
	idpb 2,1
	popj 17,

h_load_add_1:
	ibp 1
	ldb 1,1
	hrre 1,1
	popj 17,

h_load_add_2:
	addi 1,1
	ldb 1,1
	hrre 1,1
	popj 17,

h_load_add_0123:
	addi 1,51
	ibp 1
	ldb 1,1
	hrre 1,1
	popj 17,

h_store_add_1:
	ibp 1
	dpb 2,1	; movhi
	popj 17,

h_store_add_2:
	addi 1,1
	dpb 2,1	; movhi
	popj 17,

h_store_add_0123:
	addi 1,51
	ibp 1
	dpb 2,1	; movhi
	popj 17,

w_load_add_1:
	move 1,1(1)
	popj 17,

w_load_add_0123:
	move 1,123(1)
	popj 17,

w_store_add_1:
	movem 2,1(1)
	popj 17,

w_store_add_0123:
	movem 2,123(1)
	popj 17,

c_load_add_1:
	ildb 1,1
	popj 17,

c_load_add_2:
	ibp 1
	ildb 1,1
	popj 17,

c_load_add_0123:
	addi 1,24
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

c_store_add_1:
	idpb 2,1
	popj 17,

c_store_add_2:
	ibp 1
	idpb 2,1
	popj 17,

c_store_add_0123:
	addi 1,24
	ibp 1
	ibp 1
	idpb 2,1
	popj 17,

q7_load_field_add_1:
	move 1,2(1)
	ash 1,-33
	popj 17,

q7_load_field_add_2:
	move 1,5(1)
	lsh 1,22
	ash 1,-33
	popj 17,

q7_load_field_add_0123:
	move 1,246(1)
	lsh 1,33
	ash 1,-33
	popj 17,

q7_store_field_add_1:
	addi 1,2
	dpb 2,[POINT 9,(1),8]
	popj 17,

q7_store_field_add_2:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,5(1),26]
	popj 17,

q7_store_field_add_0123:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,246(1),35]
	popj 17,

h3_load_field_add_1:
	hlre 1,2(1)
	popj 17,

h3_load_field_add_2:
	hlre 1,5(1)
	popj 17,

h3_store_field_add_1:
	addi 1,2
	hrlm 2,(1)
	popj 17,

word3_load_field_add_1:
	move 1,4(1)
	popj 17,

word3_store_field_add_1:
	movem 2,5(1)
	popj 17,

mixed_qw_load_word_add_1:
	move 1,3(1)
	popj 17,

mixed_qw_load_byte_add_1:
	move 1,2(1)
	lsh 1,11
	ash 1,-33
	popj 17,

mixed_qw_store_byte_add_1:
	andi 2,777	; zero_extendqisi2
	dpb 2,[POINT 9,2(1),26]
	popj 17,

nested_load_tail_add_1:
	move 1,7(1)
	ash 1,-33
	popj 17,

nested_load_word_add_1:
	move 1,6(1)
	popj 17,

store_q7_add_1:
	addi 2,2
	movem 2,(1)
	popj 17,

store_q7_add_1_return:
	addi 2,2
	movem 2,(1)
	move 1,2
	popj 17,

store_q7_add_0123:
	addi 2,246
	movem 2,(1)
	popj 17,

store_q7_add_0123_return:
	addi 2,246
	movem 2,(1)
	move 1,2
	popj 17,

store_q_add_1:
	ibp 2
	movem 2,(1)
	popj 17,

store_q_add_1_return:
	ibp 2
	movem 2,(1)
	move 1,2
	popj 17,

store_q_add_0123:
	addi 2,24
	ibp 2
	ibp 2
	ibp 2
	movem 2,(1)
	popj 17,

store_q_add_0123_return:
	addi 2,24
	ibp 2
	ibp 2
	ibp 2
	movem 2,(1)
	move 1,2
	popj 17,

store_h_add_1:
	ibp 2
	movem 2,(1)
	popj 17,

store_h_add_1_return:
	ibp 2
	movem 2,(1)
	move 1,2
	popj 17,

store_w_add_1:
	addi 2,1
	movem 2,(1)
	popj 17,

store_w_add_1_return:
	addi 2,1
	movem 2,(1)
	move 1,2
	popj 17,

q7_global_ptr_add_1:
	move 1,q7_gp
	addi 1,2
	popj 17,

q7_global_ptr_add_0123:
	move 1,q7_gp
	addi 1,246
	popj 17,

q_global_ptr_add_1:
	move 1,q_gp
	ibp 1
	popj 17,

q_global_ptr_add_0123:
	move 1,q_gp
	addi 1,24
	ibp 1
	ibp 1
	ibp 1
	popj 17,

h_global_ptr_add_1:
	move 1,h_gp
	ibp 1
	popj 17,

h_global_ptr_add_0123:
	move 1,h_gp
	addi 1,51
	ibp 1
	popj 17,

w_global_ptr_add_1:
	move 1,w_gp
	addi 1,1
	popj 17,

w_global_ptr_add_0123:
	move 1,w_gp
	addi 1,123
	popj 17,

c_global_ptr_add_1:
	move 1,c_gp
	ibp 1
	popj 17,

c_global_ptr_add_0123:
	move 1,c_gp
	addi 1,24
	ibp 1
	ibp 1
	ibp 1
	popj 17,

q_add_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	addi 10,24
	ibp 10
	ibp 10
	ibp 10
	move 1,10
	pop 17,10
	popj 17,

h_add_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	addi 10,51
	ibp 10
	move 1,10
	pop 17,10
	popj 17,

w_add_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	addi 10,123
	move 1,10
	pop 17,10
	popj 17,

q7_add_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	addi 10,246
	move 1,10
	pop 17,10
	popj 17,

mixed_qw_add_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	addi 10,246
	move 1,10
	pop 17,10
	popj 17,

q_load_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	addi 10,24
	ibp 10
	ibp 10
	ildb 1,10
	trne 1,400
	orcmi 1,777
	pop 17,10
	popj 17,

h_load_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	addi 10,51
	ibp 10
	ldb 1,10
	hrre 1,1
	pop 17,10
	popj 17,

w_load_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,123(10)
	pop 17,10
	popj 17,

q7_field_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,247(10)
	ash 1,-33
	pop 17,10
	popj 17,

q7_select_add:
	addi 1,2
	jumpn 2,%L247
	addi 1,244
%L247:
	popj 17,

q_select_add:
	move 4,1
	ibp 1
	jumpn 2,%L249
	move 1,4
	addi 1,24
	ibp 1
	ibp 1
	ibp 1
%L249:
	popj 17,

h_select_add:
	move 4,1
	ibp 1
	jumpn 2,%L251
	move 1,4
	addi 1,51
	ibp 1
%L251:
	popj 17,

w_select_add:
	addi 1,1
	jumpn 2,%L253
	addi 1,122
%L253:
	popj 17,

q_pointer_compare:
	addi 1,24
	ibp 1
	ibp 1
	ibp 1
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

h_pointer_compare:
	addi 1,51
	ibp 1
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

w_pointer_compare:
	addi 1,123
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

q7_pointer_compare:
	addi 1,246
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.bss
s_global:
	.space	12
q7_buf:
	.space	256
q8_buf:
	.space	256
q9_buf:
	.space	384
q10_buf:
	.space	384
h3_buf:
	.space	256
h4_buf:
	.space	256
h5_buf:
	.space	384
word_buf:
	.space	128
word3_buf:
	.space	384
mixed_qw_buf:
	.space	256
mixed_hq_buf:
	.space	256
nested_buf:
	.space	512
q_buf:
	.space	256
uq_buf:
	.space	256
h_buf:
	.space	512
uh_buf:
	.space	512
w_buf:
	.space	1024
uw_buf:
	.space	1024
c_buf:
	.space	256
q7_gp:
	.space	4
q_gp:
	.space	4
h_gp:
	.space	4
w_gp:
	.space	4
c_gp:
	.space	4
