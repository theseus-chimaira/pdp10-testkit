
diff_char:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_uchar:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

diffu_6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

diff_7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

diffu_7:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

diff_8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

diffu_8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

diff_9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diffu_9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

diff_16:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

diffu_16:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

diff_18:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

diffu_18:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

diff_word:
	sub 1,2
	popj 17,

table_char:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L49
%L48:
	ibp 3
	sojn 4,%L48	; decrement_and_branch_until_zero
%L49:
	movem 3,vc9
	pushj 17,clobber
	move 4,vc9
	move 10,4
	sub 10,12
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

table_uchar:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L55
%L54:
	ibp 3
	sojn 4,%L54	; decrement_and_branch_until_zero
%L55:
	movem 3,vuc9
	pushj 17,clobber
	move 4,vuc9
	move 10,4
	sub 10,12
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

table_6:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	jumple 2,%L61
%L60:
	ibp 4
	sojg 2,%L60	; decrement_and_branch_until_zero
%L61:
	jumpe 2,%L63
%L62:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L62
%L63:
	movem 4,vc6
	pushj 17,clobber
	move 4,vc6
	move 10,4
	sub 10,12
	muli 10,14
	move 1,11
	ash 1,-1
	add 1,%BADL6(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

tableu_6:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	jumple 2,%L69
%L68:
	ibp 4
	sojg 2,%L68	; decrement_and_branch_until_zero
%L69:
	jumpe 2,%L71
%L70:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L70
%L71:
	movem 4,vuc6
	pushj 17,clobber
	move 4,vuc6
	move 10,4
	sub 10,12
	muli 10,14
	move 1,11
	ash 1,-1
	add 1,%BADL6(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

table_7:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	jumple 2,%L77
%L76:
	ibp 4
	sojg 2,%L76	; decrement_and_branch_until_zero
%L77:
	jumpe 2,%L79
%L78:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L78
%L79:
	movem 4,vc7
	pushj 17,clobber
	move 4,vc7
	move 10,4
	sub 10,12
	muli 10,12
	move 1,11
	ash 1,-1
	add 1,%BADL7(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

tableu_7:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	jumple 2,%L85
%L84:
	ibp 4
	sojg 2,%L84	; decrement_and_branch_until_zero
%L85:
	jumpe 2,%L87
%L86:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L86
%L87:
	movem 4,vuc7
	pushj 17,clobber
	move 4,vuc7
	move 10,4
	sub 10,12
	muli 10,12
	move 1,11
	ash 1,-1
	add 1,%BADL7(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

table_8:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L93
%L92:
	ibp 3
	sojn 4,%L92	; decrement_and_branch_until_zero
%L93:
	movem 3,vc8
	pushj 17,clobber
	move 4,vc8
	move 10,4
	sub 10,12
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL8(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

tableu_8:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L99
%L98:
	ibp 3
	sojn 4,%L98	; decrement_and_branch_until_zero
%L99:
	movem 3,vuc8
	pushj 17,clobber
	move 4,vuc8
	move 10,4
	sub 10,12
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL8(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

table_9:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L105
%L104:
	ibp 3
	sojn 4,%L104	; decrement_and_branch_until_zero
%L105:
	movem 3,vx9
	pushj 17,clobber
	move 4,vx9
	move 10,4
	sub 10,12
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

tableu_9:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L111
%L110:
	ibp 3
	sojn 4,%L110	; decrement_and_branch_until_zero
%L111:
	movem 3,vux9
	pushj 17,clobber
	move 4,vux9
	move 10,4
	sub 10,12
	muli 10,10
	move 1,11
	ash 1,-1
	add 1,%BADL9(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

table_16:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L117
%L116:
	ibp 3
	sojn 4,%L116	; decrement_and_branch_until_zero
%L117:
	movem 3,vh16
	pushj 17,clobber
	move 4,vh16
	move 10,4
	sub 10,12
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

tableu_16:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L123
%L122:
	ibp 3
	sojn 4,%L122	; decrement_and_branch_until_zero
%L123:
	movem 3,vuh16
	pushj 17,clobber
	move 4,vuh16
	move 10,4
	sub 10,12
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

table_18:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L129
%L128:
	ibp 3
	sojn 4,%L128	; decrement_and_branch_until_zero
%L129:
	movem 3,vh18
	pushj 17,clobber
	move 4,vh18
	move 10,4
	sub 10,12
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

tableu_18:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L135
%L134:
	ibp 3
	sojn 4,%L134	; decrement_and_branch_until_zero
%L135:
	movem 3,vuh18
	pushj 17,clobber
	move 4,vuh18
	move 10,4
	sub 10,12
	muli 10,4
	move 1,11
	ash 1,-1
	add 1,%BADLH(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

table_word:
	push 17,10
	move 10,1
	add 2,1
	movem 2,vwords
	pushj 17,clobber
	move 1,vwords
	sub 1,10
	pop 17,10
	popj 17,

fixed_6:
	push 17,10
	move 6,[POINT 6,c6+1,5]
	movem 6,vc6
	pushj 17,clobber
	move 4,vc6
	movei 3,0
	jumple 4,%L146
%L145:
	ibp 3
	sojg 4,%L145	; decrement_and_branch_until_zero
%L146:
	jumpe 4,%L148
%L147:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L147
%L148:
	move 10,3
	move 6,[POINT 6,c6,35]
	movn 4,6
	jumple 4,%L151
%L150:
	ibp 10
	sojg 4,%L150	; decrement_and_branch_until_zero
%L151:
	jumpe 4,%L153
%L152:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L152
%L153:
	move 6,[POINT 6,c6+2,5]
	movem 6,vc6
	pushj 17,clobber
	move 4,vc6
	move 3,10
	jumple 4,%L157
%L156:
	ibp 3
	sojg 4,%L156	; decrement_and_branch_until_zero
%L157:
	jumpe 4,%L159
%L158:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L158
%L159:
	move 10,3
	move 6,[POINT 6,c6+1,35]
	movn 4,6
	jumple 4,%L162
%L161:
	ibp 10
	sojg 4,%L161	; decrement_and_branch_until_zero
%L162:
	jumpe 4,%L164
%L163:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L163
%L164:
	move 6,[POINT 6,c6+3,35]
	movem 6,vc6
	pushj 17,clobber
	move 4,vc6
	move 1,10
	jumple 4,%L168
%L167:
	ibp 1
	sojg 4,%L167	; decrement_and_branch_until_zero
%L168:
	jumpe 4,%L170
%L169:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L169
%L170:
	move 6,[POINT 6,c6,5]
	sub 1,6
	pop 17,10
	popj 17,

fixed_7:
	push 17,10
	move 6,[POINT 7,c7+1,6]
	movem 6,vc7
	pushj 17,clobber
	move 4,vc7
	movei 3,0
	jumple 4,%L177
%L176:
	ibp 3
	sojg 4,%L176	; decrement_and_branch_until_zero
%L177:
	jumpe 4,%L179
%L178:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L178
%L179:
	move 4,[POINT 7,c7,6]
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	move 10,3
	movn 4,4
	jumple 4,%L182
%L181:
	ibp 10
	sojg 4,%L181	; decrement_and_branch_until_zero
%L182:
	jumpe 4,%L184
%L183:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L183
%L184:
	move 6,[POINT 7,c7+2,6]
	movem 6,vc7
	pushj 17,clobber
	move 4,vc7
	move 3,10
	jumple 4,%L188
%L187:
	ibp 3
	sojg 4,%L187	; decrement_and_branch_until_zero
%L188:
	jumpe 4,%L190
%L189:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L189
%L190:
	move 4,[POINT 7,c7+1,6]
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	move 10,3
	movn 4,4
	jumple 4,%L193
%L192:
	ibp 10
	sojg 4,%L192	; decrement_and_branch_until_zero
%L193:
	jumpe 4,%L195
%L194:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L194
%L195:
	move 4,[POINT 7,c7+4,6]
	ibp 4
	ibp 4
	ibp 4
	movem 4,vc7
	pushj 17,clobber
	move 4,vc7
	move 1,10
	jumple 4,%L199
%L198:
	ibp 1
	sojg 4,%L198	; decrement_and_branch_until_zero
%L199:
	jumpe 4,%L201
%L200:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L200
%L201:
	move 6,[POINT 7,c7,6]
	sub 1,6
	pop 17,10
	popj 17,

fixed_8:
	push 17,10
	move 6,[POINT 8,c8+1,7]
	movem 6,vc8
	pushj 17,clobber
	move 4,vc8
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	jumpe 3,%L208
%L207:
	ibp 2
	sojn 3,%L207	; decrement_and_branch_until_zero
%L208:
	move 4,[POINT 8,c8,7]
	ibp 4
	ibp 4
	ibp 4
	movn 4,4
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L211
%L210:
	ibp 10
	sojn 3,%L210	; decrement_and_branch_until_zero
%L211:
	move 6,[POINT 8,c8+2,7]
	movem 6,vc8
	pushj 17,clobber
	move 4,vc8
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	add 2,10
	jumpe 3,%L215
%L214:
	ibp 2
	sojn 3,%L214	; decrement_and_branch_until_zero
%L215:
	move 4,[POINT 8,c8+1,7]
	ibp 4
	ibp 4
	ibp 4
	movn 4,4
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L218
%L217:
	ibp 10
	sojn 3,%L217	; decrement_and_branch_until_zero
%L218:
	move 4,[POINT 8,c8+5,7]
	ibp 4
	ibp 4
	ibp 4
	movem 4,vc8
	pushj 17,clobber
	move 4,vc8
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,10
	jumpe 3,%L222
%L221:
	ibp 1
	sojn 3,%L221	; decrement_and_branch_until_zero
%L222:
	move 6,[POINT 8,c8,7]
	sub 1,6
	pop 17,10
	popj 17,

fixed_9:
	push 17,10
	move 6,[POINT 9,x9+1,8]
	movem 6,vx9
	pushj 17,clobber
	move 4,vx9
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	jumpe 3,%L229
%L228:
	ibp 2
	sojn 3,%L228	; decrement_and_branch_until_zero
%L229:
	move 6,[POINT 9,x9,35]
	movn 4,6
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L232
%L231:
	ibp 10
	sojn 3,%L231	; decrement_and_branch_until_zero
%L232:
	move 6,[POINT 9,x9+2,8]
	movem 6,vx9
	pushj 17,clobber
	move 4,vx9
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	add 2,10
	jumpe 3,%L236
%L235:
	ibp 2
	sojn 3,%L235	; decrement_and_branch_until_zero
%L236:
	move 6,[POINT 9,x9+1,35]
	movn 4,6
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L239
%L238:
	ibp 10
	sojn 3,%L238	; decrement_and_branch_until_zero
%L239:
	move 6,[POINT 9,x9+5,35]
	movem 6,vx9
	pushj 17,clobber
	move 4,vx9
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,10
	jumpe 3,%L243
%L242:
	ibp 1
	sojn 3,%L242	; decrement_and_branch_until_zero
%L243:
	move 6,[POINT 9,x9,8]
	sub 1,6
	pop 17,10
	popj 17,

fixed_h:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 6,[POINT 18,h16+1,17]
	movem 6,vh16
	pushj 17,clobber
	move 6,[POINT 18,h16,35]
	movn 4,6
	move 10,vh16
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 10,4
	jumpe 3,%L251
%L250:
	ibp 10
	sojn 3,%L250	; decrement_and_branch_until_zero
%L251:
	ash 10,-1
	move 13,10
	move 6,[POINT 18,h18+1,17]
	movem 6,vh18
	pushj 17,clobber
	move 6,[POINT 18,h18,35]
	movn 4,6
	move 10,vh18
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 10,4
	jumpe 3,%L256
%L255:
	ibp 10
	sojn 3,%L255	; decrement_and_branch_until_zero
%L256:
	ash 10,-1
	add 10,13
	move 6,[POINT 18,h18+10,35]
	movem 6,vh18
	pushj 17,clobber
	move 4,vh18
	move 11,4
	move 6,[POINT 18,h18,17]
	sub 11,6
	muli 11,4
	move 4,12
	ash 4,-1
	add 4,%BADLH(11)
	add 10,4
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

indexed_6:
	sub 1,2
	popj 17,

indexed_7:
	sub 1,2
	popj 17,

indexed_8:
	sub 1,2
	popj 17,

indexed_9:
	sub 1,2
	popj 17,

indexed_h:
	sub 1,2
	ash 1,-1
	popj 17,

diff_gate_6:
	move 4,1
	sub 4,2
	muli 4,14
	move 2,5
	ash 2,-1
	add 2,%BADL6(4)
	move 4,2
	addi 4,1
	move 1,2
	subi 1,1
	camle 2,3
	move 1,4
	popj 17,

diff_gate_9:
	move 4,1
	sub 4,2
	muli 4,10
	move 2,5
	ash 2,-1
	add 2,%BADL9(4)
	move 1,2
	addi 1,2
	camle 2,3
	subi 1,4
	popj 17,

diff_gate_h:
	move 4,1
	sub 4,2
	muli 4,4
	move 2,5
	ash 2,-1
	add 2,%BADLH(4)
	move 1,2
	addi 1,3
	came 2,3
	subi 1,6
	popj 17,

	.globl	use_byteptr_runtime_tables
use_byteptr_runtime_tables:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	pushj 17,f
	move 12,1
	add 12,13
	andi 12,17
	addi 12,5
	move 14,12
	andi 14,17
	subi 12,5
	move 11,13
	andi 11,7
	move 1,[POINT 9,c9+4,17]
	move 2,[POINT 9,c9,26]
	pushj 17,diff_char
	move 10,1
	move 1,[POINT 9,uc9+4,17]
	move 2,[POINT 9,uc9,26]
	pushj 17,diff_uchar
	add 10,1
	move 1,[POINT 6,c6+2,35]
	move 2,[POINT 6,c6,17]
	pushj 17,diff_6
	add 10,1
	move 1,[POINT 6,uc6+2,35]
	move 2,[POINT 6,uc6,17]
	pushj 17,diffu_6
	add 10,1
	move 1,[POINT 7,c7+3,6]
	ibp 1
	ibp 1
	move 2,[POINT 7,c7,6]
	ibp 2
	ibp 2
	pushj 17,diff_7
	add 10,1
	move 1,[POINT 7,uc7+3,6]
	ibp 1
	ibp 1
	move 2,[POINT 7,uc7,6]
	ibp 2
	ibp 2
	pushj 17,diffu_7
	add 10,1
	move 1,[POINT 8,c8+4,7]
	ibp 1
	move 2,[POINT 8,c8,7]
	ibp 2
	ibp 2
	pushj 17,diff_8
	add 10,1
	move 1,[POINT 8,uc8+4,7]
	ibp 1
	move 2,[POINT 8,uc8,7]
	ibp 2
	ibp 2
	pushj 17,diffu_8
	add 10,1
	move 1,[POINT 9,x9+4,17]
	move 2,[POINT 9,x9,26]
	pushj 17,diff_9
	add 10,1
	move 1,[POINT 9,ux9+4,17]
	move 2,[POINT 9,ux9,26]
	pushj 17,diffu_9
	add 10,1
	move 1,[POINT 18,h16+4,35]
	move 2,[POINT 18,h16+1,17]
	pushj 17,diff_16
	add 10,1
	move 1,[POINT 18,uh16+4,35]
	move 2,[POINT 18,uh16+1,17]
	pushj 17,diffu_16
	add 10,1
	move 1,[POINT 18,h18+4,35]
	move 2,[POINT 18,h18+1,17]
	pushj 17,diff_18
	add 10,1
	move 1,[POINT 18,uh18+4,35]
	move 2,[POINT 18,uh18+1,17]
	pushj 17,diffu_18
	add 10,1
	movei 1,words+21
	movei 2,words+2
	pushj 17,diff_word
	add 10,1
	move 1,[POINT 9,c9+6,8]
	move 2,11
	pushj 17,table_char
	add 10,1
	move 1,[POINT 9,uc9+6,8]
	move 2,11
	pushj 17,table_uchar
	add 10,1
	move 1,[POINT 6,c6+4,5]
	move 2,11
	pushj 17,table_6
	add 10,1
	move 1,[POINT 6,uc6+4,5]
	move 2,11
	pushj 17,tableu_6
	add 10,1
	move 1,[POINT 7,c7+4,6]
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	move 2,11
	pushj 17,table_7
	add 10,1
	move 1,[POINT 7,uc7+4,6]
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	move 2,11
	pushj 17,tableu_7
	add 10,1
	move 1,[POINT 8,c8+6,7]
	move 2,11
	pushj 17,table_8
	add 10,1
	move 1,[POINT 8,uc8+6,7]
	move 2,11
	pushj 17,tableu_8
	add 10,1
	move 1,[POINT 9,x9+6,8]
	move 2,11
	pushj 17,table_9
	add 10,1
	move 1,[POINT 9,ux9+6,8]
	move 2,11
	pushj 17,tableu_9
	add 10,1
	move 1,[POINT 18,h16+10,17]
	move 2,11
	pushj 17,table_16
	add 10,1
	move 1,[POINT 18,uh16+10,17]
	move 2,11
	pushj 17,tableu_16
	add 10,1
	move 1,[POINT 18,h18+10,17]
	move 2,11
	pushj 17,table_18
	add 10,1
	move 1,[POINT 18,uh18+10,17]
	move 2,11
	pushj 17,tableu_18
	add 10,1
	movei 1,words+20
	move 2,11
	pushj 17,table_word
	add 10,1
	pushj 17,fixed_6
	add 10,1
	pushj 17,fixed_7
	add 10,1
	pushj 17,fixed_8
	add 10,1
	pushj 17,fixed_9
	add 10,1
	pushj 17,fixed_h
	add 10,1
	move 1,12
	move 2,14
	pushj 17,indexed_6
	add 10,1
	move 1,12
	move 2,14
	pushj 17,indexed_7
	add 10,1
	move 1,12
	move 2,14
	pushj 17,indexed_8
	add 10,1
	move 1,12
	move 2,14
	pushj 17,indexed_9
	add 10,1
	move 1,12
	move 2,14
	pushj 17,indexed_h
	add 10,1
	move 1,[POINT 6,c6+2,35]
	move 2,[POINT 6,c6,17]
	move 3,13
	pushj 17,diff_gate_6
	add 10,1
	move 1,[POINT 9,x9+4,17]
	move 2,[POINT 9,x9,26]
	move 3,13
	pushj 17,diff_gate_9
	add 10,1
	andi 13,17
	move 1,[POINT 18,h18+4,35]
	move 2,[POINT 18,h18+1,17]
	move 3,13
	pushj 17,diff_gate_h
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.bss
c9:
	.space	48
uc9:
	.space	48
c6:
	.space	48
uc6:
	.space	48
c7:
	.space	48
uc7:
	.space	48
c8:
	.space	48
uc8:
	.space	48
x9:
	.space	48
ux9:
	.space	48
h16:
	.space	64
uh16:
	.space	64
h18:
	.space	64
uh18:
	.space	64
words:
	.space	128
vc9:
	.space	4
vuc9:
	.space	4
vc6:
	.space	4
vuc6:
	.space	4
vc7:
	.space	4
vuc7:
	.space	4
vc8:
	.space	4
vuc8:
	.space	4
vx9:
	.space	4
vux9:
	.space	4
vh16:
	.space	4
vuh16:
	.space	4
vh18:
	.space	4
vuh18:
	.space	4
vwords:
	.space	4
