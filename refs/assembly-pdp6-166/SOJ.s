
sojl_loop:
%L2:
	add 1,2
	sojl 2,%L2	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

soje_loop:
%L7:
	add 1,2
	soje 2,%L7	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojle_loop:
%L12:
	add 1,2
	sojle 2,%L12	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojge_loop:
%L17:
	add 1,2
	sojge 2,%L17	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojn_loop:
	move 3,1
	move 1,2
	move 4,2
	jumpn 2,%L27
	movei 4,1
%L27:
	subi 4,1
%L26:
	add 3,1
	subi 1,1
	sojge 4,%L26	; doloop_end
	add 1,3
	popj 17,

sojg_loop:
%L29:
	add 1,2
	sojg 2,%L29	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

soja_loop:
%L34:
	add 1,2
	subi 2,1
	trne 1,1
	jrst %L34
	add 1,2
	popj 17,

soj_plain_dec:
	subi 2,1
	add 1,2
	popj 17,

sojl_if:
	sojl 2,%L39	; decrement_and_branch_until_zero
%L38:
	popj 17,
%L39:
	add 1,2
	popj 17,

soje_if:
	popj 17,

sojle_if:
	sojle 2,%L44	; decrement_and_branch_until_zero
%L43:
	popj 17,
%L44:
	add 1,2
	popj 17,

sojge_if:
	sojl 2,%L46	; decrement_and_branch_until_zero
	add 1,2
%L46:
	popj 17,

sojn_if:
	soje 2,%L48	; decrement_and_branch_until_zero
	add 1,2
%L48:
	popj 17,

sojg_if:
	sojle 2,%L50	; decrement_and_branch_until_zero
	add 1,2
%L50:
	popj 17,

sojl_goto:
	sojl 2,%L54	; decrement_and_branch_until_zero
%L51:
	popj 17,
%L53:
%L54:
	add 1,2
	popj 17,

soje_goto:
%L57:
	popj 17,

sojle_goto:
	sojle 2,%L61	; decrement_and_branch_until_zero
%L58:
	popj 17,
%L60:
%L61:
	add 1,2
	popj 17,

sojge_goto:
	sojl 2,%L62	; decrement_and_branch_until_zero
%L64:
	add 1,2
%L62:
	popj 17,

sojn_goto:
	soje 2,%L65	; decrement_and_branch_until_zero
%L67:
	add 1,2
%L65:
	popj 17,

sojg_goto:
	sojle 2,%L68	; decrement_and_branch_until_zero
%L70:
	add 1,2
%L68:
	popj 17,

sojge_for_sum:
	movei 4,0
	sojl 1,%L78	; decrement_and_branch_until_zero
%L76:
	add 4,1
	sojge 1,%L76	; decrement_and_branch_until_zero
%L78:
	move 1,4
	popj 17,

sojg_for_sum:
	movei 4,0
	sojle 1,%L86	; decrement_and_branch_until_zero
%L84:
	add 4,1
	sojg 1,%L84	; decrement_and_branch_until_zero
%L86:
	move 1,4
	popj 17,

sojn_for_sum:
	movei 3,0
	soje 1,%L94	; decrement_and_branch_until_zero
	move 4,1
	subi 4,1
%L95:
	add 3,1
	subi 1,1
	sojge 4,%L95	; doloop_end
%L94:
	move 1,3
	popj 17,

soje_once:
	sojn 2,%L102	; decrement_and_branch_until_zero
%L100:
	add 1,2
	soje 2,%L100	; decrement_and_branch_until_zero
%L102:
	add 1,2
	popj 17,

sojl_once:
	sojl 2,%L107	; decrement_and_branch_until_zero
%L109:
	add 1,2
	popj 17,
%L107:
	add 1,2
	sojl 2,%L107	; decrement_and_branch_until_zero
	jrst %L109

sojle_once:
	sojle 2,%L114	; decrement_and_branch_until_zero
%L116:
	add 1,2
	popj 17,
%L114:
	add 1,2
	sojle 2,%L114	; decrement_and_branch_until_zero
	jrst %L116

sojge_once:
	sojl 2,%L123	; decrement_and_branch_until_zero
%L121:
	add 1,2
	sojge 2,%L121	; decrement_and_branch_until_zero
%L123:
	add 1,2
	popj 17,

sojn_once:
	soje 2,%L130	; decrement_and_branch_until_zero
	move 4,2
	subi 4,1
%L131:
	add 1,2
	subi 2,1
	sojge 4,%L131	; doloop_end
%L130:
	add 1,2
	popj 17,

sojg_once:
	sojle 2,%L138	; decrement_and_branch_until_zero
%L136:
	add 1,2
	sojg 2,%L136	; decrement_and_branch_until_zero
%L138:
	add 1,2
	popj 17,

sojl_likely:
%L140:
	add 1,2
	sojl 2,%L140	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

soje_likely:
%L145:
	add 1,2
	soje 2,%L145	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojle_likely:
%L150:
	add 1,2
	sojle 2,%L150	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojge_likely:
%L155:
	add 1,2
	sojge 2,%L155	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojn_likely:
	move 3,1
	move 1,2
	move 4,2
	jumpn 2,%L165
	movei 4,1
%L165:
	subi 4,1
%L164:
	add 3,1
	subi 1,1
	sojge 4,%L164	; doloop_end
	add 1,3
	popj 17,

sojg_likely:
%L167:
	add 1,2
	sojg 2,%L167	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojl_unlikely:
%L172:
	add 1,2
	sojl 2,%L172	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

soje_unlikely:
%L177:
	add 1,2
	soje 2,%L177	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojle_unlikely:
%L182:
	add 1,2
	sojle 2,%L182	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojge_unlikely:
%L187:
	add 1,2
	sojge 2,%L187	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojn_unlikely:
	move 3,1
	move 1,2
	move 4,2
	jumpn 2,%L197
	movei 4,1
%L197:
	subi 4,1
%L196:
	add 3,1
	subi 1,1
	sojge 4,%L196	; doloop_end
	add 1,3
	popj 17,

sojg_unlikely:
%L199:
	add 1,2
	sojg 2,%L199	; decrement_and_branch_until_zero
	add 1,2
	popj 17,

sojge_global_bound:
	move 4,soj_ga
%L204:
	add 4,1
	sojge 1,%L204	; decrement_and_branch_until_zero
	movem 4,soj_ga
	add 4,1
	move 1,4
	popj 17,

sojg_global_bound:
	move 4,soj_gb
%L209:
	add 4,1
	sojg 1,%L209	; decrement_and_branch_until_zero
	movem 4,soj_gb
	add 4,1
	move 1,4
	popj 17,

sojn_global_count:
	move 3,1
	move 2,soj_ga
	move 4,1
	jumpn 1,%L219
	movei 4,1
%L219:
	subi 4,1
%L218:
	xor 2,3
	subi 3,1
	sojge 4,%L218	; doloop_end
	movem 2,soj_ga
	add 2,3
	move 1,2
	popj 17,

soje_global_count:
	move 4,soj_gb
%L221:
	xor 4,1
	soje 1,%L221	; decrement_and_branch_until_zero
	movem 4,soj_gb
	add 4,1
	move 1,4
	popj 17,

sojl_nested:
%L226:
	jumpe 3,%L229
	add 1,2
%L228:
	sojl 2,%L226	; decrement_and_branch_until_zero
	add 1,2
	popj 17,
%L229:
	xor 1,2
	jrst %L228

sojg_nested:
%L233:
	jumpe 3,%L236
	add 1,2
%L235:
	sojg 2,%L233	; decrement_and_branch_until_zero
	add 1,2
	popj 17,
%L236:
	xor 1,2
	jrst %L235

	.bss
soj_ga:
	.space	4
soj_gb:
	.space	4
