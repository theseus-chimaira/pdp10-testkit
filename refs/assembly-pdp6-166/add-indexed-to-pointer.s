
add:
	add 1,(2)
	popj 17,

sub:
	sub 1,(2)
	popj 17,

add_mem_index:
	add 1,(2)
	popj 17,

sub_mem_index:
	sub 1,(2)
	popj 17,

add_volatile_mem_index:
	move 4,1
	move 1,(2)
	add 1,4
	popj 17,

sub_volatile_mem_index:
	move 4,(2)
	sub 1,4
	popj 17,

add_global_index:
	add 1,idx_ga
	popj 17,

sub_global_index:
	sub 1,idx_ga
	popj 17,

add_volatile_global_index:
	move 4,1
	move 1,idx_vga
	add 1,4
	popj 17,

sub_volatile_global_index:
	move 4,idx_vga
	sub 1,4
	popj 17,

add_array_index:
	andi 2,17
	add 1,idx_buf(2)
	popj 17,

sub_array_index:
	andi 2,17
	sub 1,idx_buf(2)
	popj 17,

add_struct_index:
	add 1,(2)
	popj 17,

sub_struct_index:
	sub 1,1(2)
	popj 17,

add_global_struct_index:
	add 1,idx_gp
	popj 17,

sub_global_struct_index:
	sub 1,idx_gp+1
	popj 17,

add_reg_index:
	add 1,2
	popj 17,

sub_reg_index:
	sub 1,2
	popj 17,

add_unsigned_reg_index:
	add 1,2
	popj 17,

sub_unsigned_reg_index:
	sub 1,2
	popj 17,

add_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

sub_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	sub 10,1
	move 1,10
	pop 17,10
	popj 17,

add_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,(2)
	pushj 17,clobber
	add 11,10
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sub_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,(2)
	pushj 17,clobber
	sub 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

add_const_0:
	popj 17,

add_const_1:
	addi 1,1
	popj 17,

add_const_2:
	addi 1,2
	popj 17,

add_const_7:
	addi 1,7
	popj 17,

add_const_0100:
	addi 1,100
	popj 17,

sub_const_1:
	subi 1,1
	popj 17,

sub_const_2:
	subi 1,2
	popj 17,

sub_const_7:
	subi 1,7
	popj 17,

sub_const_0100:
	subi 1,100
	popj 17,

add_to_loaded_pointer:
	move 1,(1)
	add 1,(2)
	popj 17,

sub_from_loaded_pointer:
	move 1,(1)
	sub 1,(2)
	popj 17,

add_to_global_pointer:
	move 6,ptr_gp
	add 6,(1)
	move 1,6
	popj 17,

sub_from_global_pointer:
	move 4,1
	move 1,ptr_gp+1
	sub 1,(4)
	popj 17,

add_loaded_pointer_reg:
	add 2,(1)
	move 1,2
	popj 17,

sub_loaded_pointer_reg:
	move 1,(1)
	sub 1,2
	popj 17,

store_add_ptr:
	add 2,(3)
	movem 2,(1)
	popj 17,

store_sub_ptr:
	sub 2,(3)
	movem 2,(1)
	popj 17,

store_add_ptr_return:
	add 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

store_sub_ptr_return:
	sub 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

store_add_global_ptr:
	add 1,(2)
	movem 1,ptr_gp
	popj 17,

store_sub_global_ptr:
	sub 1,(2)
	movem 1,ptr_gp+1
	popj 17,

load_add_mem_index:
	add 1,(2)
	move 1,(1)
	popj 17,

load_sub_mem_index:
	sub 1,(2)
	move 1,(1)
	popj 17,

store_through_add_mem_index:
	add 1,(2)
	movem 3,(1)
	popj 17,

store_through_sub_mem_index:
	sub 1,(2)
	movem 3,(1)
	popj 17,

load_add_global_index:
	add 1,idx_ga
	move 1,(1)
	popj 17,

load_sub_global_index:
	sub 1,idx_ga
	move 1,(1)
	popj 17,

store_add_global_index:
	add 1,idx_ga
	movem 2,(1)
	popj 17,

store_sub_global_index:
	sub 1,idx_ga
	movem 2,(1)
	popj 17,

word_base_add_index:
	move 1,(1)
	xmovei 1,word_buf(1)
	popj 17,

word_base_sub_index:
	move 4,1
	movei 1,word_buf+40
	sub 1,(4)
	popj 17,

word_base_load_add:
	move 4,(1)
	move 1,word_buf(4)
	popj 17,

word_base_load_sub:
	movei 4,word_buf+40
	sub 4,(1)
	move 1,(4)
	popj 17,

word_base_store_add:
	move 4,(1)
	movem 2,word_buf(4)
	popj 17,

word_base_store_sub:
	movei 4,word_buf+40
	sub 4,(1)
	movem 2,(4)
	popj 17,

uword_base_add_index:
	move 1,(1)
	xmovei 1,uword_buf(1)
	popj 17,

uword_base_sub_index:
	move 4,1
	movei 1,uword_buf+40
	sub 1,(4)
	popj 17,

uword_base_load_add:
	move 4,(1)
	move 1,uword_buf(4)
	popj 17,

qadd_mem_index:
	move 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L128
%L127:
	ibp 1
	sojn 3,%L127	; decrement_and_branch_until_zero
%L128:
	popj 17,

qsub_mem_index:
	movn 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L132
%L131:
	ibp 1
	sojn 3,%L131	; decrement_and_branch_until_zero
%L132:
	popj 17,

uqadd_mem_index:
	move 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L136
%L135:
	ibp 1
	sojn 3,%L135	; decrement_and_branch_until_zero
%L136:
	popj 17,

uqsub_mem_index:
	movn 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L140
%L139:
	ibp 1
	sojn 3,%L139	; decrement_and_branch_until_zero
%L140:
	popj 17,

qadd_reg_index:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L144
%L143:
	ibp 1
	sojn 4,%L143	; decrement_and_branch_until_zero
%L144:
	popj 17,

qsub_reg_index:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L148
%L147:
	ibp 1
	sojn 4,%L147	; decrement_and_branch_until_zero
%L148:
	popj 17,

qadd_global_index:
	move 4,idx_ga
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L152
%L151:
	ibp 1
	sojn 3,%L151	; decrement_and_branch_until_zero
%L152:
	popj 17,

qsub_global_index:
	movn 4,idx_ga
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L156
%L155:
	ibp 1
	sojn 3,%L155	; decrement_and_branch_until_zero
%L156:
	popj 17,

qadd_const_1:
	ibp 1
	popj 17,

qadd_const_2:
	ibp 1
	ibp 1
	popj 17,

qadd_const_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

qadd_const_4:
	addi 1,1
	popj 17,

qsub_const_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

qsub_const_2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

qsub_const_3:
	subi 1,1
	ibp 1
	popj 17,

qsub_const_4:
	subi 1,1
	popj 17,

qload_add_mem_index:
	move 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L168
%L167:
	ibp 1
	sojn 3,%L167	; decrement_and_branch_until_zero
%L168:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

qload_sub_mem_index:
	movn 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L172
%L171:
	ibp 1
	sojn 3,%L171	; decrement_and_branch_until_zero
%L172:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

qstore_add_mem_index:
	andi 3,777	; zero_extendqisi2
	move 4,(2)
	move 2,4
	andi 2,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L176
%L175:
	ibp 1
	sojn 2,%L175	; decrement_and_branch_until_zero
%L176:
	dpb 3,1
	popj 17,

qstore_sub_mem_index:
	andi 3,777	; zero_extendqisi2
	movn 4,(2)
	move 2,4
	andi 2,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L180
%L179:
	ibp 1
	sojn 2,%L179	; decrement_and_branch_until_zero
%L180:
	dpb 3,1
	popj 17,

qbase_add_index:
	move 4,(1)
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,q_buf,8]
	jumpe 3,%L185
%L184:
	ibp 1
	sojn 3,%L184	; decrement_and_branch_until_zero
%L185:
	popj 17,

qbase_sub_index:
	movn 4,(1)
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,q_buf+10,8]
	jumpe 3,%L190
%L189:
	ibp 1
	sojn 3,%L189	; decrement_and_branch_until_zero
%L190:
	popj 17,

qbase_load_add:
	move 4,(1)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,[POINT 9,q_buf,8]
	jumpe 3,%L195
%L194:
	ibp 4
	sojn 3,%L194	; decrement_and_branch_until_zero
%L195:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

qbase_store_add:
	andi 2,777	; zero_extendqisi2
	move 4,(1)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,[POINT 9,q_buf,8]
	jumpe 3,%L200
%L199:
	ibp 4
	sojn 3,%L199	; decrement_and_branch_until_zero
%L200:
	dpb 2,4
	popj 17,

uqbase_add_index:
	move 4,(1)
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,uq_buf,8]
	jumpe 3,%L205
%L204:
	ibp 1
	sojn 3,%L204	; decrement_and_branch_until_zero
%L205:
	popj 17,

uqbase_sub_index:
	movn 4,(1)
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,uq_buf+10,8]
	jumpe 3,%L210
%L209:
	ibp 1
	sojn 3,%L209	; decrement_and_branch_until_zero
%L210:
	popj 17,

uqbase_load_add:
	move 4,(1)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,[POINT 9,uq_buf,8]
	jumpe 3,%L215
%L214:
	ibp 4
	sojn 3,%L214	; decrement_and_branch_until_zero
%L215:
	ldb 1,4
	popj 17,

hadd_mem_index:
	move 4,(2)
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L219
%L218:
	ibp 1
	sojn 3,%L218	; decrement_and_branch_until_zero
%L219:
	popj 17,

hsub_mem_index:
	movn 4,(2)
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L223
%L222:
	ibp 1
	sojn 3,%L222	; decrement_and_branch_until_zero
%L223:
	popj 17,

uhadd_mem_index:
	move 4,(2)
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L227
%L226:
	ibp 1
	sojn 3,%L226	; decrement_and_branch_until_zero
%L227:
	popj 17,

uhsub_mem_index:
	movn 4,(2)
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L231
%L230:
	ibp 1
	sojn 3,%L230	; decrement_and_branch_until_zero
%L231:
	popj 17,

hadd_reg_index:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L235
%L234:
	ibp 1
	sojn 4,%L234	; decrement_and_branch_until_zero
%L235:
	popj 17,

hsub_reg_index:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L239
%L238:
	ibp 1
	sojn 4,%L238	; decrement_and_branch_until_zero
%L239:
	popj 17,

hadd_global_index:
	move 4,idx_ga
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L243
%L242:
	ibp 1
	sojn 3,%L242	; decrement_and_branch_until_zero
%L243:
	popj 17,

hsub_global_index:
	movn 4,idx_ga
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L247
%L246:
	ibp 1
	sojn 3,%L246	; decrement_and_branch_until_zero
%L247:
	popj 17,

hadd_const_1:
	ibp 1
	popj 17,

hadd_const_2:
	addi 1,1
	popj 17,

hadd_const_3:
	addi 1,1
	ibp 1
	popj 17,

hsub_const_1:
	subi 1,1
	ibp 1
	popj 17,

hsub_const_2:
	subi 1,1
	popj 17,

hsub_const_3:
	subi 1,2
	ibp 1
	popj 17,

hload_add_mem_index:
	move 4,(2)
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L257
%L256:
	ibp 1
	sojn 3,%L256	; decrement_and_branch_until_zero
%L257:
	ldb 1,1
	hrre 1,1
	popj 17,

hload_sub_mem_index:
	movn 4,(2)
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L261
%L260:
	ibp 1
	sojn 3,%L260	; decrement_and_branch_until_zero
%L261:
	ldb 1,1
	hrre 1,1
	popj 17,

hstore_add_mem_index:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,(2)
	move 2,4
	andi 2,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L265
%L264:
	ibp 1
	sojn 2,%L264	; decrement_and_branch_until_zero
%L265:
	dpb 3,1	; movhi
	popj 17,

hstore_sub_mem_index:
	hrrzi 3,(3)	; zero_extendhisi2
	movn 4,(2)
	move 2,4
	andi 2,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L269
%L268:
	ibp 1
	sojn 2,%L268	; decrement_and_branch_until_zero
%L269:
	dpb 3,1	; movhi
	popj 17,

hbase_add_index:
	move 4,(1)
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,h_buf,17]
	jumpe 3,%L274
%L273:
	ibp 1
	sojn 3,%L273	; decrement_and_branch_until_zero
%L274:
	popj 17,

hbase_sub_index:
	movn 4,(1)
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,h_buf+20,17]
	jumpe 3,%L279
%L278:
	ibp 1
	sojn 3,%L278	; decrement_and_branch_until_zero
%L279:
	popj 17,

hbase_load_add:
	move 4,(1)
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,[POINT 18,h_buf,17]
	jumpe 3,%L284
%L283:
	ibp 4
	sojn 3,%L283	; decrement_and_branch_until_zero
%L284:
	ldb 1,4
	hrre 1,1
	popj 17,

hbase_store_add:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,(1)
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,[POINT 18,h_buf,17]
	jumpe 3,%L289
%L288:
	ibp 4
	sojn 3,%L288	; decrement_and_branch_until_zero
%L289:
	dpb 2,4	; movhi
	popj 17,

uhbase_add_index:
	move 4,(1)
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,uh_buf,17]
	jumpe 3,%L294
%L293:
	ibp 1
	sojn 3,%L293	; decrement_and_branch_until_zero
%L294:
	popj 17,

uhbase_sub_index:
	movn 4,(1)
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,uh_buf+20,17]
	jumpe 3,%L299
%L298:
	ibp 1
	sojn 3,%L298	; decrement_and_branch_until_zero
%L299:
	popj 17,

uhbase_load_add:
	move 4,(1)
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,[POINT 18,uh_buf,17]
	jumpe 3,%L304
%L303:
	ibp 4
	sojn 3,%L303	; decrement_and_branch_until_zero
%L304:
	ldb 1,4
	popj 17,

cadd_mem_index:
	move 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L308
%L307:
	ibp 1
	sojn 3,%L307	; decrement_and_branch_until_zero
%L308:
	popj 17,

csub_mem_index:
	movn 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L312
%L311:
	ibp 1
	sojn 3,%L311	; decrement_and_branch_until_zero
%L312:
	popj 17,

cadd_reg_index:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L316
%L315:
	ibp 1
	sojn 4,%L315	; decrement_and_branch_until_zero
%L316:
	popj 17,

csub_reg_index:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L320
%L319:
	ibp 1
	sojn 4,%L319	; decrement_and_branch_until_zero
%L320:
	popj 17,

cadd_global_index:
	move 4,idx_ga
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L324
%L323:
	ibp 1
	sojn 3,%L323	; decrement_and_branch_until_zero
%L324:
	popj 17,

csub_global_index:
	movn 4,idx_ga
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L328
%L327:
	ibp 1
	sojn 3,%L327	; decrement_and_branch_until_zero
%L328:
	popj 17,

cload_add_mem_index:
	move 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L332
%L331:
	ibp 1
	sojn 3,%L331	; decrement_and_branch_until_zero
%L332:
	ldb 1,1
	popj 17,

cload_sub_mem_index:
	movn 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L336
%L335:
	ibp 1
	sojn 3,%L335	; decrement_and_branch_until_zero
%L336:
	ldb 1,1
	popj 17,

cstore_add_mem_index:
	andi 3,777	; zero_extendqisi2
	move 4,(2)
	move 2,4
	andi 2,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L340
%L339:
	ibp 1
	sojn 2,%L339	; decrement_and_branch_until_zero
%L340:
	dpb 3,1
	popj 17,

cstore_sub_mem_index:
	andi 3,777	; zero_extendqisi2
	movn 4,(2)
	move 2,4
	andi 2,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 2,%L344
%L343:
	ibp 1
	sojn 2,%L343	; decrement_and_branch_until_zero
%L344:
	dpb 3,1
	popj 17,

add_index_plus_1:
	addi 1,1
	add 1,(2)
	popj 17,

sub_index_plus_1:
	subi 1,1
	sub 1,(2)
	popj 17,

add_index_minus_1:
	add 1,(2)
	subi 1,1
	popj 17,

sub_index_minus_1:
	sub 1,(2)
	addi 1,1
	popj 17,

add_index_from_sum:
	add 2,3
	add 1,2
	popj 17,

sub_index_from_sum:
	add 2,3
	sub 1,2
	popj 17,

add_index_from_diff:
	sub 2,3
	add 1,2
	popj 17,

sub_index_from_diff:
	sub 2,3
	sub 1,2
	popj 17,

qadd_index_plus_1:
	move 4,(2)
	ibp 1
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L363
%L362:
	ibp 1
	sojn 3,%L362	; decrement_and_branch_until_zero
%L363:
	popj 17,

qsub_index_plus_1:
	subi 1,1
	ibp 1
	ibp 1
	movn 4,(2)
	ibp 1
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L367
%L366:
	ibp 1
	sojn 3,%L366	; decrement_and_branch_until_zero
%L367:
	popj 17,

hadd_index_plus_1:
	move 4,(2)
	ibp 1
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L371
%L370:
	ibp 1
	sojn 3,%L370	; decrement_and_branch_until_zero
%L371:
	popj 17,

hsub_index_plus_1:
	subi 1,1
	movn 4,(2)
	ibp 1
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L375
%L374:
	ibp 1
	sojn 3,%L374	; decrement_and_branch_until_zero
%L375:
	popj 17,

ptr_add_eq:
	add 1,(2)
	came 1,3
	tdza 1,1
	movei 1,1
	popj 17,

ptr_sub_eq:
	sub 1,(2)
	came 1,3
	tdza 1,1
	movei 1,1
	popj 17,

select_add_or_sub:
	jumpe 3,%L381
	add 1,(2)
%L380:
	popj 17,
%L381:
	sub 1,(2)
	popj 17,

select_two_adds:
	skipl (3)
	move 1,2
	add 1,(3)
	popj 17,

qselect_add_or_sub:
	move 6,1
	jumpe 3,%L390
	move 4,(2)
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L389
%L392:
	ibp 1
	sojn 3,%L392	; decrement_and_branch_until_zero
%L389:
	popj 17,
%L390:
	movn 4,(2)
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L389
%L395:
	ibp 1
	sojn 3,%L395	; decrement_and_branch_until_zero
	popj 17,

hselect_add_or_sub:
	move 6,1
	jumpe 3,%L398
	move 4,(2)
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L397
%L400:
	ibp 1
	sojn 3,%L400	; decrement_and_branch_until_zero
%L397:
	popj 17,
%L398:
	movn 4,(2)
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L397
%L403:
	ibp 1
	sojn 3,%L403	; decrement_and_branch_until_zero
	popj 17,

add_umem_index:
	add 1,(2)
	popj 17,

sub_umem_index:
	sub 1,(2)
	popj 17,

add_uglobal_index:
	add 1,uidx_ga
	popj 17,

sub_uglobal_index:
	sub 1,uidx_ga
	popj 17,

add_uarray_index:
	andi 2,17
	add 1,uidx_buf(2)
	popj 17,

sub_uarray_index:
	andi 2,17
	sub 1,uidx_buf(2)
	popj 17,

qadd_umem_index:
	move 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L420
%L419:
	ibp 1
	sojn 3,%L419	; decrement_and_branch_until_zero
%L420:
	popj 17,

qsub_umem_index:
	movn 4,(2)
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L424
%L423:
	ibp 1
	sojn 3,%L423	; decrement_and_branch_until_zero
%L424:
	popj 17,

qadd_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,(2)
	pushj 17,clobber
	move 4,11
	andi 4,3
	move 1,11
	ash 1,-2	; ashrsi3_pointer
	add 1,10
	jumpe 4,%L428
%L427:
	ibp 1
	sojn 4,%L427	; decrement_and_branch_until_zero
%L428:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

qsub_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,(2)
	pushj 17,clobber
	movn 10,10
	move 4,10
	andi 4,3
	move 1,10
	ash 1,-2	; ashrsi3_pointer
	add 1,11
	jumpe 4,%L432
%L431:
	ibp 1
	sojn 4,%L431	; decrement_and_branch_until_zero
%L432:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

hadd_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,(2)
	pushj 17,clobber
	move 4,11
	andi 4,1
	move 1,11
	ash 1,-1	; ashrsi3_pointer
	add 1,10
	jumpe 4,%L436
%L435:
	ibp 1
	sojn 4,%L435	; decrement_and_branch_until_zero
%L436:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

hsub_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,(2)
	pushj 17,clobber
	movn 10,10
	move 4,10
	andi 4,1
	move 1,10
	ash 1,-1	; ashrsi3_pointer
	add 1,11
	jumpe 4,%L440
%L439:
	ibp 1
	sojn 4,%L439	; decrement_and_branch_until_zero
%L440:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

cadd_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,(2)
	pushj 17,clobber
	move 4,11
	andi 4,3
	move 1,11
	ash 1,-2	; ashrsi3_pointer
	add 1,10
	jumpe 4,%L444
%L443:
	ibp 1
	sojn 4,%L443	; decrement_and_branch_until_zero
%L444:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

csub_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,(2)
	pushj 17,clobber
	movn 10,10
	move 4,10
	andi 4,3
	move 1,10
	ash 1,-2	; ashrsi3_pointer
	add 1,11
	jumpe 4,%L448
%L447:
	ibp 1
	sojn 4,%L447	; decrement_and_branch_until_zero
%L448:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
idx_ga:
	.space	4
idx_gb:
	.space	4
idx_vga:
	.space	4
idx_buf:
	.space	64
uidx_ga:
	.space	4
uidx_vga:
	.space	4
uidx_buf:
	.space	64
word_buf:
	.space	256
uword_buf:
	.space	256
q_buf:
	.space	64
uq_buf:
	.space	64
h_buf:
	.space	128
uh_buf:
	.space	128
idx_gp:
	.space	8
ptr_gp:
	.space	8
byte_ptr_gp:
	.space	8
