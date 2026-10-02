
skip_likely_l:
	skipge (2)
	movei 1,0
	popj 17,

skip_likely_e:
	skipn (2)
	movei 1,0
	popj 17,

skip_likely_le:
	skipg (2)
	movei 1,0
	popj 17,

skip_likely_ge:
	skipl (2)
	movei 1,0
	popj 17,

skip_likely_n:
	skipe (2)
	movei 1,0
	popj 17,

skip_likely_g:
	skiple (2)
	movei 1,0
	popj 17,

skip_unlikely_l:
	skipl (2)
%L14:
	popj 17,
	movei 1,0
	popj 17,

skip_unlikely_e:
	skipe (2)
%L17:
	popj 17,
	movei 1,0
	popj 17,

skip_unlikely_le:
	skiple (2)
%L20:
	popj 17,
	movei 1,0
	popj 17,

skip_unlikely_ge:
	skipge (2)
%L23:
	popj 17,
	movei 1,0
	popj 17,

skip_unlikely_n:
	skipn (2)
%L26:
	popj 17,
	movei 1,0
	popj 17,

skip_unlikely_g:
	skipg (2)
%L29:
	popj 17,
	movei 1,0
	popj 17,

skip_branch_l:
	skipl (1)
	move 2,3
	move 1,2
	popj 17,

skip_branch_e:
	skipe (1)
	move 2,3
	move 1,2
	popj 17,

skip_branch_le:
	skiple (1)
	move 2,3
	move 1,2
	popj 17,

skip_branch_ge:
	skipge (1)
	jrst %L39
%L37:
	move 1,2
	popj 17,
%L39:
	move 2,3
	jrst %L37

skip_branch_n:
	skipn (1)
	move 2,3
	move 1,2
	popj 17,

skip_branch_g:
	skipg (1)
	jrst %L44
%L42:
	move 1,2
	popj 17,
%L44:
	move 2,3
	jrst %L42

skip_bool_l:
	move 1,(1)
	lsh 1,-43
	popj 17,

skip_bool_e:
	skipe (1)
	tdza 1,1
	movei 1,1
	popj 17,

skip_bool_le:
	skiple (1)
	tdza 1,1
	movei 1,1
	popj 17,

skip_bool_ge:
	skipge (1)
	tdza 1,1
	movei 1,1
	popj 17,

skip_bool_n:
	skipe 1,(1)
	movei 1,1
	popj 17,

skip_bool_g:
	skipg (1)
	tdza 1,1
	movei 1,1
	popj 17,

skip_load_bool_l:
	move 1,(1)
	lsh 1,-43
	popj 17,

skip_load_bool_e:
	skipe (1)
	tdza 1,1
	movei 1,1
	popj 17,

skip_load_bool_le:
	skiple (1)
	tdza 1,1
	movei 1,1
	popj 17,

skip_load_bool_ge:
	skipge (1)
	tdza 1,1
	movei 1,1
	popj 17,

skip_load_bool_n:
	skipe 1,(1)
	movei 1,1
	popj 17,

skip_load_bool_g:
	skipg (1)
	tdza 1,1
	movei 1,1
	popj 17,

skip_move_l:
	skipge 1,(1)
	jrst %L59
%L58:
	move 1,2
	popj 17,
%L59:
	move 2,1
	jrst %L58

skip_move_e:
	skipn (1)
	movei 2,0
	move 1,2
	popj 17,

skip_move_le:
	skipg 1,(1)
	jrst %L64
%L63:
	move 1,2
	popj 17,
%L64:
	move 2,1
	jrst %L63

skip_move_ge:
	skipl 1,(1)
	move 2,1
	move 1,2
	popj 17,

skip_move_n:
	skipe 1,(1)
	move 2,1
	move 1,2
	popj 17,

skip_move_g:
	skiple 1,(1)
	move 2,1
	move 1,2
	popj 17,

skip_move_clear_l:
	skipge 1,(1)
	jrst %L73
%L72:
	add 1,2
	popj 17,
%L73:
	movei 2,0
	jrst %L72

skip_move_clear_e:
	skipn 1,(1)
	movei 2,0
	add 1,2
	popj 17,

skip_move_clear_le:
	skipg 1,(1)
	jrst %L78
%L77:
	add 1,2
	popj 17,
%L78:
	movei 2,0
	jrst %L77

skip_move_clear_ge:
	skipl 1,(1)
	movei 2,0
	add 1,2
	popj 17,

skip_move_clear_n:
	skipe 1,(1)
	movei 2,0
	add 1,2
	popj 17,

skip_move_clear_g:
	skiple 1,(1)
	movei 2,0
	add 1,2
	popj 17,

skip_orig_l:
	skipl (2)
	movei 1,0
	popj 17,

skip_orig_e:
	skipe (2)
	movei 1,0
	popj 17,

skip_orig_le:
	skiple (2)
	movei 1,0
	popj 17,

skip_orig_ge:
	skipge (2)
	movei 1,0
	popj 17,

skip_orig_n:
	skipn (2)
	movei 1,0
	popj 17,

skip_orig_g:
	skipg (2)
	movei 1,0
	popj 17,

skip_global_l:
	skipl skip_ga
%L98:
	popj 17,
	movei 1,0
	popj 17,

skip_global_e:
	skipn skip_ga
	movei 1,0
	popj 17,

skip_global_le:
	skiple skip_ga
%L103:
	popj 17,
	movei 1,0
	popj 17,

skip_global_ge:
	skipl skip_ga
	movei 1,0
	popj 17,

skip_global_n:
	skipe skip_ga
	movei 1,0
	popj 17,

skip_global_g:
	skiple skip_ga
	movei 1,0
	popj 17,

skip_array_l:
	andi 2,17
	add 1,2
	skipge (1)
	jrst %L114
%L112:
	move 1,3
	popj 17,
%L114:
	movei 3,0
	jrst %L112

skip_array_e:
	andi 2,17
	add 1,2
	skipn (1)
	movei 3,0
	move 1,3
	popj 17,

skip_array_le:
	andi 2,17
	add 1,2
	skipg (1)
	jrst %L121
%L119:
	move 1,3
	popj 17,
%L121:
	movei 3,0
	jrst %L119

skip_array_ge:
	andi 2,17
	add 1,2
	skipl (1)
	movei 3,0
	move 1,3
	popj 17,

skip_array_n:
	andi 2,17
	add 1,2
	skipe (1)
	movei 3,0
	move 1,3
	popj 17,

skip_array_g:
	andi 2,17
	add 1,2
	skiple (1)
	movei 3,0
	move 1,3
	popj 17,

skip_global_array_l:
	andi 1,17
	skipge skip_buf(1)
	jrst %L133
%L132:
	move 1,2
	popj 17,
%L133:
	movei 2,0
	jrst %L132

skip_global_array_e:
	andi 1,17
	skipn skip_buf(1)
	movei 2,0
	move 1,2
	popj 17,

skip_global_array_le:
	andi 1,17
	skipg skip_buf(1)
	jrst %L138
%L137:
	move 1,2
	popj 17,
%L138:
	movei 2,0
	jrst %L137

skip_global_array_ge:
	andi 1,17
	skipl skip_buf(1)
	movei 2,0
	move 1,2
	popj 17,

skip_global_array_n:
	andi 1,17
	skipe skip_buf(1)
	movei 2,0
	move 1,2
	popj 17,

skip_global_array_g:
	andi 1,17
	skiple skip_buf(1)
	movei 2,0
	move 1,2
	popj 17,

skip_struct_a_l:
	skipge (1)
	jrst %L147
%L146:
	move 1,2
	popj 17,
%L147:
	movei 2,0
	jrst %L146

skip_struct_a_e:
	skipn (1)
	movei 2,0
	move 1,2
	popj 17,

skip_struct_a_n:
	skipe (1)
	movei 2,0
	move 1,2
	popj 17,

skip_struct_a_g:
	skiple (1)
	movei 2,0
	move 1,2
	popj 17,

skip_struct_b_le:
	skipg 1(1)
	jrst %L156
%L155:
	move 1,2
	popj 17,
%L156:
	movei 2,0
	jrst %L155

skip_struct_b_ge:
	skipl 1(1)
	movei 2,0
	move 1,2
	popj 17,

skip_global_struct_a:
	skipn skip_gp
	movei 1,0
	popj 17,

skip_global_struct_b:
	skipe skip_gp+1
	movei 1,0
	popj 17,

skip_volatile_l:
	move 4,(1)
	jumpl 4,%L165
%L164:
	move 1,2
	popj 17,
%L165:
	movei 2,0
	jrst %L164

skip_volatile_e:
	move 4,(1)
	jumpn 4,%L167
	movei 2,0
%L167:
	move 1,2
	popj 17,

skip_volatile_n:
	move 4,(1)
	jumpe 4,%L169
	movei 2,0
%L169:
	move 1,2
	popj 17,

skip_volatile_g:
	move 4,(1)
	jumple 4,%L171
	movei 2,0
%L171:
	move 1,2
	popj 17,

skip_unsigned_e:
	skipn (1)
	movei 2,0
	move 1,2
	popj 17,

skip_unsigned_n:
	skipe (1)
	movei 2,0
	move 1,2
	popj 17,

skip_unsigned_bool_e:
	skipe (1)
	tdza 1,1
	movei 1,1
	popj 17,

skip_unsigned_bool_n:
	skipe 1,(1)
	movei 1,1
	popj 17,

skip_qi_e:
	ldb 1,1
	jumpn 1,%L179
	movei 2,0
%L179:
	move 1,2
	popj 17,

skip_qi_l:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	jumpl 4,%L182
%L181:
	move 1,2
	popj 17,
%L182:
	movei 2,0
	jrst %L181

skip_qi_g:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	jumple 4,%L184
	movei 2,0
%L184:
	move 1,2
	popj 17,

skip_uqi_e:
	ldb 1,1
	jumpn 1,%L186
	movei 2,0
%L186:
	move 1,2
	popj 17,

skip_uqi_n:
	ldb 1,1
	jumpe 1,%L188
	movei 2,0
%L188:
	move 1,2
	popj 17,

skip_hi_e:
	ldb 1,1
	jumpn 1,%L190
	movei 2,0
%L190:
	move 1,2
	popj 17,

skip_hi_l:
	ldb 4,1
	hrre 4,4
	jumpl 4,%L193
%L192:
	move 1,2
	popj 17,
%L193:
	movei 2,0
	jrst %L192

skip_hi_g:
	ldb 4,1
	hrre 4,4
	jumple 4,%L195
	movei 2,0
%L195:
	move 1,2
	popj 17,

skip_uhi_e:
	ldb 1,1
	jumpn 1,%L197
	movei 2,0
%L197:
	move 1,2
	popj 17,

skip_uhi_n:
	ldb 1,1
	jumpe 1,%L199
	movei 2,0
%L199:
	move 1,2
	popj 17,

skipa_select_mem:
	jumpe 1,%L200
	move 3,(2)
%L200:
	move 1,3
	popj 17,

skipa_select_global:
	jumpe 1,%L202
	move 2,skip_ga
%L202:
	move 1,2
	popj 17,

skipa_select_array:
	jumpe 1,%L205
	andi 3,17
	add 2,3
	move 1,(2)
%L204:
	popj 17,
%L205:
	move 1,4
	popj 17,

skipa_select_struct:
	jumpe 1,%L207
	move 3,(2)
%L207:
	move 1,3
	popj 17,

skipa_after_compare:
	movei 4,0
	skipe (1)
	move 4,2
	move 1,4
	popj 17,

skipa_after_compare_n:
	skipe 1,(1)
	move 2,1
	move 1,2
	popj 17,

	.bss
skip_ga:
	.space	4
skip_gb:
	.space	4
skip_buf:
	.space	64
skip_gp:
	.space	8
