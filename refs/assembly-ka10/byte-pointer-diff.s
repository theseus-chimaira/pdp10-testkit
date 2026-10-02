
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

rdiff_char:
	move 4,2
	sub 4,1
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

rdiff_6:
	move 4,2
	sub 4,1
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

rdiff_7:
	move 4,2
	sub 4,1
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

rdiff_8:
	move 4,2
	sub 4,1
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

rdiff_9:
	move 4,2
	sub 4,1
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

rdiff_16:
	move 4,2
	sub 4,1
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

rdiff_18:
	move 4,2
	sub 4,1
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	popj 17,

span_char:
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
	jumpe 4,%L70
%L69:
	ibp 3
	sojn 4,%L69	; decrement_and_branch_until_zero
%L70:
	movem 3,vpc
	pushj 17,clobber
	move 4,vpc
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

span_uchar:
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
	jumpe 4,%L76
%L75:
	ibp 3
	sojn 4,%L75	; decrement_and_branch_until_zero
%L76:
	movem 3,vpuc
	pushj 17,clobber
	move 4,vpuc
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

span_6:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	jumple 2,%L82
%L81:
	ibp 4
	sojg 2,%L81	; decrement_and_branch_until_zero
%L82:
	jumpe 2,%L84
%L83:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L83
%L84:
	movem 4,vp6
	pushj 17,clobber
	move 4,vp6
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

spanu_6:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	jumple 2,%L90
%L89:
	ibp 4
	sojg 2,%L89	; decrement_and_branch_until_zero
%L90:
	jumpe 2,%L92
%L91:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L91
%L92:
	movem 4,vpu6
	pushj 17,clobber
	move 4,vpu6
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

span_7:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	jumple 2,%L98
%L97:
	ibp 4
	sojg 2,%L97	; decrement_and_branch_until_zero
%L98:
	jumpe 2,%L100
%L99:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L99
%L100:
	movem 4,vp7
	pushj 17,clobber
	move 4,vp7
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

spanu_7:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	jumple 2,%L106
%L105:
	ibp 4
	sojg 2,%L105	; decrement_and_branch_until_zero
%L106:
	jumpe 2,%L108
%L107:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L107
%L108:
	movem 4,vpu7
	pushj 17,clobber
	move 4,vpu7
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

span_8:
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
	jumpe 4,%L114
%L113:
	ibp 3
	sojn 4,%L113	; decrement_and_branch_until_zero
%L114:
	movem 3,vp8
	pushj 17,clobber
	move 4,vp8
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

spanu_8:
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
	jumpe 4,%L120
%L119:
	ibp 3
	sojn 4,%L119	; decrement_and_branch_until_zero
%L120:
	movem 3,vpu8
	pushj 17,clobber
	move 4,vpu8
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

span_9:
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
	jumpe 4,%L126
%L125:
	ibp 3
	sojn 4,%L125	; decrement_and_branch_until_zero
%L126:
	movem 3,vp9
	pushj 17,clobber
	move 4,vp9
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

spanu_9:
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
	jumpe 4,%L132
%L131:
	ibp 3
	sojn 4,%L131	; decrement_and_branch_until_zero
%L132:
	movem 3,vpu9
	pushj 17,clobber
	move 4,vpu9
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

span_16:
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
	jumpe 4,%L138
%L137:
	ibp 3
	sojn 4,%L137	; decrement_and_branch_until_zero
%L138:
	movem 3,vph16
	pushj 17,clobber
	move 4,vph16
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

spanu_16:
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
	jumpe 4,%L144
%L143:
	ibp 3
	sojn 4,%L143	; decrement_and_branch_until_zero
%L144:
	movem 3,vpuh16
	pushj 17,clobber
	move 4,vpuh16
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

span_18:
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
	jumpe 4,%L150
%L149:
	ibp 3
	sojn 4,%L149	; decrement_and_branch_until_zero
%L150:
	movem 3,vph18
	pushj 17,clobber
	move 4,vph18
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

spanu_18:
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
	jumpe 4,%L156
%L155:
	ibp 3
	sojn 4,%L155	; decrement_and_branch_until_zero
%L156:
	movem 3,vpuh18
	pushj 17,clobber
	move 4,vpuh18
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

span_word:
	push 17,10
	move 10,1
	add 2,1
	movem 2,vpw
	pushj 17,clobber
	move 1,vpw
	sub 1,10
	pop 17,10
	popj 17,

backspan_char:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L166
%L165:
	ibp 3
	sojn 4,%L165	; decrement_and_branch_until_zero
%L166:
	movem 3,vpc
	pushj 17,clobber
	move 4,vpc
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

backspan_6:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	movn 2,2
	jumple 2,%L172
%L171:
	ibp 4
	sojg 2,%L171	; decrement_and_branch_until_zero
%L172:
	jumpe 2,%L174
%L173:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L173
%L174:
	movem 4,vp6
	pushj 17,clobber
	move 4,vp6
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

backspan_7:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,1
	movn 2,2
	jumple 2,%L180
%L179:
	ibp 4
	sojg 2,%L179	; decrement_and_branch_until_zero
%L180:
	jumpe 2,%L182
%L181:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L181
%L182:
	movem 4,vp7
	pushj 17,clobber
	move 4,vp7
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

backspan_8:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L188
%L187:
	ibp 3
	sojn 4,%L187	; decrement_and_branch_until_zero
%L188:
	movem 3,vp8
	pushj 17,clobber
	move 4,vp8
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

backspan_9:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L194
%L193:
	ibp 3
	sojn 4,%L193	; decrement_and_branch_until_zero
%L194:
	movem 3,vp9
	pushj 17,clobber
	move 4,vp9
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

backspan_16:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movn 2,2
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L200
%L199:
	ibp 3
	sojn 4,%L199	; decrement_and_branch_until_zero
%L200:
	movem 3,vph16
	pushj 17,clobber
	move 4,vph16
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

backspan_18:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movn 2,2
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L206
%L205:
	ibp 3
	sojn 4,%L205	; decrement_and_branch_until_zero
%L206:
	movem 3,vph18
	pushj 17,clobber
	move 4,vph18
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

idx_char:
	sub 1,2
	popj 17,

idx_uchar:
	sub 1,2
	popj 17,

idx_6:
	sub 1,2
	popj 17,

idxu_6:
	sub 1,2
	popj 17,

idx_7:
	sub 1,2
	popj 17,

idxu_7:
	sub 1,2
	popj 17,

idx_8:
	sub 1,2
	popj 17,

idxu_8:
	sub 1,2
	popj 17,

idx_9:
	sub 1,2
	popj 17,

idxu_9:
	sub 1,2
	popj 17,

idx_16:
	sub 1,2
	ash 1,-1
	popj 17,

idxu_16:
	sub 1,2
	ash 1,-1
	popj 17,

idx_18:
	sub 1,2
	ash 1,-1
	popj 17,

idxu_18:
	sub 1,2
	ash 1,-1
	popj 17,

idx_word:
	sub 1,2
	ash 1,-2
	popj 17,

const_char:
	move 6,[POINT 9,cbuf+4,17]
	movem 6,vpc
	pushj 17,clobber
	move 6,[POINT 9,cbuf,26]
	movn 4,6
	move 1,vpc
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L289
%L288:
	ibp 1
	sojn 3,%L288	; decrement_and_branch_until_zero
%L289:
	popj 17,

const_uchar:
	move 6,[POINT 9,ucbuf+4,17]
	movem 6,vpuc
	pushj 17,clobber
	move 6,[POINT 9,ucbuf,26]
	movn 4,6
	move 1,vpuc
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L295
%L294:
	ibp 1
	sojn 3,%L294	; decrement_and_branch_until_zero
%L295:
	popj 17,

const_6:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,[POINT 6,b6,35]
	movem 6,vp6
	pushj 17,clobber
	move 4,vp6
	movei 1,0
	jumple 4,%L300
%L299:
	ibp 1
	sojg 4,%L299	; decrement_and_branch_until_zero
%L300:
	jumpe 4,%L302
%L301:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L301
%L302:
	move 6,[POINT 6,b6,5]
	movn 11,6
	move 10,1
	add 10,11
	move 6,[POINT 6,b6+1,5]
	movem 6,vp6
	pushj 17,clobber
	move 4,vp6
	move 1,10
	jumple 4,%L308
%L307:
	ibp 1
	sojg 4,%L307	; decrement_and_branch_until_zero
%L308:
	jumpe 4,%L310
%L309:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L309
%L310:
	add 11,1
	move 6,[POINT 6,b6+1,35]
	movem 6,vp6
	pushj 17,clobber
	move 4,vp6
	move 1,11
	jumple 4,%L316
%L315:
	ibp 1
	sojg 4,%L315	; decrement_and_branch_until_zero
%L316:
	jumpe 4,%L318
%L317:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L317
%L318:
	move 10,1
	move 6,[POINT 6,b6,35]
	movn 4,6
	jumple 4,%L321
%L320:
	ibp 10
	sojg 4,%L320	; decrement_and_branch_until_zero
%L321:
	jumpe 4,%L323
%L322:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L322
%L323:
	move 6,[POINT 6,b6+2,5]
	movem 6,vp6
	pushj 17,clobber
	move 4,vp6
	move 1,10
	jumple 4,%L327
%L326:
	ibp 1
	sojg 4,%L326	; decrement_and_branch_until_zero
%L327:
	jumpe 4,%L329
%L328:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L328
%L329:
	move 10,1
	move 6,[POINT 6,b6+1,5]
	movn 4,6
	jumple 4,%L332
%L331:
	ibp 10
	sojg 4,%L331	; decrement_and_branch_until_zero
%L332:
	jumpe 4,%L334
%L333:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L333
%L334:
	move 6,[POINT 6,b6+3,35]
	movem 6,vp6
	pushj 17,clobber
	move 4,vp6
	move 1,10
	jumple 4,%L338
%L337:
	ibp 1
	sojg 4,%L337	; decrement_and_branch_until_zero
%L338:
	jumpe 4,%L340
%L339:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L339
%L340:
	move 10,1
	move 6,[POINT 6,b6+2,35]
	movn 4,6
	jumple 4,%L343
%L342:
	ibp 10
	sojg 4,%L342	; decrement_and_branch_until_zero
%L343:
	jumpe 4,%L345
%L344:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L344
%L345:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

constu_6:
	move 6,[POINT 6,ub6+2,35]
	movem 6,vpu6
	pushj 17,clobber
	move 1,vpu6
	move 6,[POINT 6,ub6,17]
	movn 4,6
	jumple 4,%L351
%L350:
	ibp 1
	sojg 4,%L350	; decrement_and_branch_until_zero
%L351:
	jumpe 4,%L353
%L352:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L352
%L353:
	popj 17,

const_7:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,[POINT 7,b7,34]
	movem 6,vp7
	pushj 17,clobber
	move 4,vp7
	movei 1,0
	jumple 4,%L358
%L357:
	ibp 1
	sojg 4,%L357	; decrement_and_branch_until_zero
%L358:
	jumpe 4,%L360
%L359:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L359
%L360:
	move 6,[POINT 7,b7,6]
	movn 11,6
	move 10,1
	add 10,11
	move 6,[POINT 7,b7+1,6]
	movem 6,vp7
	pushj 17,clobber
	move 4,vp7
	move 1,10
	jumple 4,%L366
%L365:
	ibp 1
	sojg 4,%L365	; decrement_and_branch_until_zero
%L366:
	jumpe 4,%L368
%L367:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L367
%L368:
	add 11,1
	move 6,[POINT 7,b7+1,34]
	movem 6,vp7
	pushj 17,clobber
	move 4,vp7
	move 1,11
	jumple 4,%L374
%L373:
	ibp 1
	sojg 4,%L373	; decrement_and_branch_until_zero
%L374:
	jumpe 4,%L376
%L375:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L375
%L376:
	move 10,1
	move 6,[POINT 7,b7,34]
	movn 4,6
	jumple 4,%L379
%L378:
	ibp 10
	sojg 4,%L378	; decrement_and_branch_until_zero
%L379:
	jumpe 4,%L381
%L380:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L380
%L381:
	move 6,[POINT 7,b7+2,6]
	movem 6,vp7
	pushj 17,clobber
	move 4,vp7
	move 1,10
	jumple 4,%L385
%L384:
	ibp 1
	sojg 4,%L384	; decrement_and_branch_until_zero
%L385:
	jumpe 4,%L387
%L386:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L386
%L387:
	move 10,1
	move 6,[POINT 7,b7+1,6]
	movn 4,6
	jumple 4,%L390
%L389:
	ibp 10
	sojg 4,%L389	; decrement_and_branch_until_zero
%L390:
	jumpe 4,%L392
%L391:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L391
%L392:
	move 6,[POINT 7,b7+3,34]
	movem 6,vp7
	pushj 17,clobber
	move 4,vp7
	move 1,10
	jumple 4,%L396
%L395:
	ibp 1
	sojg 4,%L395	; decrement_and_branch_until_zero
%L396:
	jumpe 4,%L398
%L397:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L397
%L398:
	move 10,1
	move 6,[POINT 7,b7,27]
	movn 4,6
	jumple 4,%L401
%L400:
	ibp 10
	sojg 4,%L400	; decrement_and_branch_until_zero
%L401:
	jumpe 4,%L403
%L402:
	subi 10,1
	ibp 10
	ibp 10
	ibp 10
	ibp 10
	aojl 4,%L402
%L403:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

constu_7:
	move 6,[POINT 7,ub7+3,20]
	movem 6,vpu7
	pushj 17,clobber
	move 1,vpu7
	move 6,[POINT 7,ub7,20]
	movn 4,6
	jumple 4,%L409
%L408:
	ibp 1
	sojg 4,%L408	; decrement_and_branch_until_zero
%L409:
	jumpe 4,%L411
%L410:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L410
%L411:
	popj 17,

const_8:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,[POINT 8,b8,31]
	movem 6,vp8
	pushj 17,clobber
	move 4,vp8
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	jumpe 3,%L416
%L415:
	ibp 1
	sojn 3,%L415	; decrement_and_branch_until_zero
%L416:
	move 6,[POINT 8,b8,7]
	movn 11,6
	move 10,1
	add 10,11
	move 6,[POINT 8,b8+1,7]
	movem 6,vp8
	pushj 17,clobber
	move 4,vp8
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,10
	jumpe 3,%L422
%L421:
	ibp 4
	sojn 3,%L421	; decrement_and_branch_until_zero
%L422:
	add 11,4
	move 6,[POINT 8,b8+1,31]
	movem 6,vp8
	pushj 17,clobber
	move 4,vp8
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	add 2,11
	jumpe 3,%L428
%L427:
	ibp 2
	sojn 3,%L427	; decrement_and_branch_until_zero
%L428:
	move 6,[POINT 8,b8,31]
	movn 4,6
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L431
%L430:
	ibp 10
	sojn 3,%L430	; decrement_and_branch_until_zero
%L431:
	move 6,[POINT 8,b8+2,7]
	movem 6,vp8
	pushj 17,clobber
	move 4,vp8
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	add 2,10
	jumpe 3,%L435
%L434:
	ibp 2
	sojn 3,%L434	; decrement_and_branch_until_zero
%L435:
	move 6,[POINT 8,b8+1,7]
	movn 4,6
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L438
%L437:
	ibp 10
	sojn 3,%L437	; decrement_and_branch_until_zero
%L438:
	move 6,[POINT 8,b8+4,15]
	movem 6,vp8
	pushj 17,clobber
	move 4,vp8
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	add 2,10
	jumpe 3,%L442
%L441:
	ibp 2
	sojn 3,%L441	; decrement_and_branch_until_zero
%L442:
	move 6,[POINT 8,b8,23]
	movn 4,6
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L445
%L444:
	ibp 10
	sojn 3,%L444	; decrement_and_branch_until_zero
%L445:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

constu_8:
	move 6,[POINT 8,ub8+4,15]
	movem 6,vpu8
	pushj 17,clobber
	move 6,[POINT 8,ub8,23]
	movn 4,6
	move 1,vpu8
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L451
%L450:
	ibp 1
	sojn 3,%L450	; decrement_and_branch_until_zero
%L451:
	popj 17,

const_9:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,[POINT 9,b9,35]
	movem 6,vp9
	pushj 17,clobber
	move 4,vp9
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	jumpe 3,%L456
%L455:
	ibp 1
	sojn 3,%L455	; decrement_and_branch_until_zero
%L456:
	move 6,[POINT 9,b9,8]
	movn 11,6
	move 10,1
	add 10,11
	move 6,[POINT 9,b9+1,8]
	movem 6,vp9
	pushj 17,clobber
	move 4,vp9
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,10
	jumpe 3,%L462
%L461:
	ibp 4
	sojn 3,%L461	; decrement_and_branch_until_zero
%L462:
	add 11,4
	move 6,[POINT 9,b9+1,35]
	movem 6,vp9
	pushj 17,clobber
	move 4,vp9
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	add 2,11
	jumpe 3,%L468
%L467:
	ibp 2
	sojn 3,%L467	; decrement_and_branch_until_zero
%L468:
	move 6,[POINT 9,b9,35]
	movn 4,6
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L471
%L470:
	ibp 10
	sojn 3,%L470	; decrement_and_branch_until_zero
%L471:
	move 6,[POINT 9,b9+2,8]
	movem 6,vp9
	pushj 17,clobber
	move 4,vp9
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	add 2,10
	jumpe 3,%L475
%L474:
	ibp 2
	sojn 3,%L474	; decrement_and_branch_until_zero
%L475:
	move 6,[POINT 9,b9+1,8]
	movn 4,6
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L478
%L477:
	ibp 10
	sojn 3,%L477	; decrement_and_branch_until_zero
%L478:
	move 6,[POINT 9,b9+4,17]
	movem 6,vp9
	pushj 17,clobber
	move 4,vp9
	move 3,4
	andi 3,3
	move 2,4
	ash 2,-2	; ashrsi3_pointer
	add 2,10
	jumpe 3,%L482
%L481:
	ibp 2
	sojn 3,%L481	; decrement_and_branch_until_zero
%L482:
	move 6,[POINT 9,b9,26]
	movn 4,6
	move 3,4
	andi 3,3
	move 10,4
	ash 10,-2	; ashrsi3_pointer
	add 10,2
	jumpe 3,%L485
%L484:
	ibp 10
	sojn 3,%L484	; decrement_and_branch_until_zero
%L485:
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

constu_9:
	move 6,[POINT 9,ub9+4,17]
	movem 6,vpu9
	pushj 17,clobber
	move 6,[POINT 9,ub9,26]
	movn 4,6
	move 1,vpu9
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L491
%L490:
	ibp 1
	sojn 3,%L490	; decrement_and_branch_until_zero
%L491:
	popj 17,

const_16:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 6,[POINT 18,h16,35]
	movem 6,vph16
	pushj 17,clobber
	move 4,vph16
	move 10,4
	move 6,[POINT 18,h16,17]
	sub 10,6
	muli 10,4
	move 14,11
	ash 14,-1
	add 14,%BADLH(10)
	move 6,[POINT 18,h16+1,17]
	movem 6,vph16
	pushj 17,clobber
	move 4,vph16
	move 12,4
	move 6,[POINT 18,h16,17]
	sub 12,6
	muli 12,4
	move 4,13
	ash 4,-1
	add 4,%BADLH(12)
	add 14,4
	move 6,[POINT 18,h16+2,35]
	movem 6,vph16
	pushj 17,clobber
	move 6,[POINT 18,h16,35]
	movn 4,6
	move 2,vph16
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L505
%L504:
	ibp 2
	sojn 3,%L504	; decrement_and_branch_until_zero
%L505:
	ash 2,-1
	add 14,2
	move 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

constu_16:
	move 6,[POINT 18,uh16+4,35]
	movem 6,vpuh16
	pushj 17,clobber
	move 6,[POINT 18,uh16+1,17]
	movn 4,6
	move 1,vpuh16
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L511
%L510:
	ibp 1
	sojn 3,%L510	; decrement_and_branch_until_zero
%L511:
	ash 1,-1
	popj 17,

const_18:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 6,[POINT 18,h18,35]
	movem 6,vph18
	pushj 17,clobber
	move 4,vph18
	move 10,4
	move 6,[POINT 18,h18,17]
	sub 10,6
	muli 10,4
	move 14,11
	ash 14,-1
	add 14,%BADLH(10)
	move 6,[POINT 18,h18+1,17]
	movem 6,vph18
	pushj 17,clobber
	move 4,vph18
	move 12,4
	move 6,[POINT 18,h18,17]
	sub 12,6
	muli 12,4
	move 4,13
	ash 4,-1
	add 4,%BADLH(12)
	add 14,4
	move 6,[POINT 18,h18+2,35]
	movem 6,vph18
	pushj 17,clobber
	move 6,[POINT 18,h18,35]
	movn 4,6
	move 2,vph18
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L525
%L524:
	ibp 2
	sojn 3,%L524	; decrement_and_branch_until_zero
%L525:
	ash 2,-1
	add 14,2
	move 1,14
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

constu_18:
	move 6,[POINT 18,uh18+4,35]
	movem 6,vpuh18
	pushj 17,clobber
	move 6,[POINT 18,uh18+1,17]
	movn 4,6
	move 1,vpuh18
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L531
%L530:
	ibp 1
	sojn 3,%L530	; decrement_and_branch_until_zero
%L531:
	ash 1,-1
	popj 17,

const_word:
	movei 6,wbuf+21
	movem 6,vpw
	pushj 17,clobber
	move 1,vpw
	movei 6,wbuf+2
	sub 1,6
	popj 17,

sum_selected_diffs:
	add 17,[11,,11]
	movem 16,-10(17)
	movei 0,-7(17)
	hrli 0,10
	blt 0,-2(17)
	move 12,1
	move 10,2
	movem 3,-1(17)
	move 14,1
	andi 14,3
	move 4,14
	move 16,1
	ash 16,-2	; ashrsi3_pointer
	move 1,16
	add 1,[POINT 9,cbuf,8]
	jumpe 14,%L548
%L547:
	ibp 1
	sojn 4,%L547	; decrement_and_branch_until_zero
%L548:
	move 13,10
	andi 13,3
	move 4,13
	move 15,10
	ash 15,-2	; ashrsi3_pointer
	move 2,15
	add 2,[POINT 9,cbuf,8]
	jumpe 13,%L552
%L551:
	ibp 2
	sojn 4,%L551	; decrement_and_branch_until_zero
%L552:
	pushj 17,diff_char
	movem 1,(17)
	move 1,[POINT 6,b6,5]
	move 4,12
	jumple 12,%L568
%L567:
	ibp 1
	sojg 4,%L567	; decrement_and_branch_until_zero
%L568:
	jumpe 4,%L570
%L569:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L569
%L570:
	move 2,[POINT 6,b6,5]
	move 4,10
	jumple 10,%L574
%L573:
	ibp 2
	sojg 4,%L573	; decrement_and_branch_until_zero
%L574:
	jumpe 4,%L576
%L575:
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	aojl 4,%L575
%L576:
	pushj 17,diff_6
	move 11,1
	add 11,(17)
	move 1,[POINT 7,b7,6]
	move 4,12
	jumple 12,%L592
%L591:
	ibp 1
	sojg 4,%L591	; decrement_and_branch_until_zero
%L592:
	jumpe 4,%L594
%L593:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L593
%L594:
	move 2,[POINT 7,b7,6]
	move 4,10
	jumple 10,%L598
%L597:
	ibp 2
	sojg 4,%L597	; decrement_and_branch_until_zero
%L598:
	jumpe 4,%L600
%L599:
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	aojl 4,%L599
%L600:
	pushj 17,diff_7
	add 11,1
	move 4,14
	move 1,16
	add 1,[POINT 8,b8,7]
	jumpe 14,%L612
%L611:
	ibp 1
	sojn 4,%L611	; decrement_and_branch_until_zero
%L612:
	move 4,13
	move 2,15
	add 2,[POINT 8,b8,7]
	jumpe 13,%L616
%L615:
	ibp 2
	sojn 4,%L615	; decrement_and_branch_until_zero
%L616:
	pushj 17,diff_8
	add 11,1
	move 1,16
	add 1,[POINT 9,b9,8]
	skipn 4,14
	jrst %L628
%L627:
	ibp 1
	sojn 4,%L627	; decrement_and_branch_until_zero
%L628:
	move 2,15
	add 2,[POINT 9,b9,8]
	skipn 4,13
	jrst %L632
%L631:
	ibp 2
	sojn 4,%L631	; decrement_and_branch_until_zero
%L632:
	pushj 17,diff_9
	add 11,1
	move 14,12
	andi 14,17
	andi 12,1
	move 4,12
	move 1,14
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,h16,17]
	jumpe 12,%L644
%L643:
	ibp 1
	sojn 4,%L643	; decrement_and_branch_until_zero
%L644:
	move 13,10
	andi 13,17
	andi 10,1
	move 4,10
	move 2,13
	ash 2,-1	; ashrsi3_pointer
	add 2,[POINT 18,h16,17]
	jumpe 10,%L648
%L647:
	ibp 2
	sojn 4,%L647	; decrement_and_branch_until_zero
%L648:
	pushj 17,diff_16
	add 11,1
	move 1,14
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,h18,17]
	skipn 4,12
	jrst %L660
%L659:
	ibp 1
	sojn 4,%L659	; decrement_and_branch_until_zero
%L660:
	move 2,13
	ash 2,-1	; ashrsi3_pointer
	add 2,[POINT 18,h18,17]
	skipn 4,10
	jrst %L664
%L663:
	ibp 2
	sojn 4,%L663	; decrement_and_branch_until_zero
%L664:
	pushj 17,diff_18
	add 11,1
	move 1,[POINT 9,cbuf+6,8]
	move 2,-1(17)
	pushj 17,span_char
	add 11,1
	move 1,[POINT 6,b6+4,5]
	move 2,-1(17)
	pushj 17,span_6
	add 11,1
	move 1,[POINT 7,b7+4,34]
	move 2,-1(17)
	pushj 17,span_7
	add 11,1
	move 1,[POINT 8,b8+6,7]
	move 2,-1(17)
	pushj 17,span_8
	add 11,1
	move 1,[POINT 9,b9+6,8]
	move 2,-1(17)
	pushj 17,span_9
	add 11,1
	move 10,-1(17)
	andi 10,7
	move 1,[POINT 18,h16+10,17]
	move 2,10
	pushj 17,span_16
	add 11,1
	move 1,[POINT 18,h18+10,17]
	move 2,10
	pushj 17,span_18
	add 11,1
	move 1,11
	move 16,-10(17)
	movei 0,10
	hrli 0,-7(17)
	blt 0,15
	add 17,[-11,,-11]
	popj 17,

compare_diff_6:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	camg 1,3
	tdza 1,1
	movei 1,1
	popj 17,

compare_diff_9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	camle 1,3
	tdza 1,1
	movei 1,1
	popj 17,

compare_diff_18:
	move 4,1
	sub 4,2
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	came 1,3
	tdza 1,1
	movei 1,1
	popj 17,

	.globl	use_byte_pointer_diffs
use_byte_pointer_diffs:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 14,1
	pushj 17,f
	move 12,1
	add 12,14
	andi 12,17
	addi 12,5
	move 13,12
	andi 13,17
	subi 12,5
	move 11,14
	andi 11,7
	move 1,[POINT 9,cbuf+4,17]
	move 2,[POINT 9,cbuf,26]
	pushj 17,diff_char
	move 10,1
	move 1,[POINT 9,ucbuf+4,17]
	move 2,[POINT 9,ucbuf,26]
	pushj 17,diff_uchar
	add 10,1
	move 1,[POINT 6,b6+2,35]
	move 2,[POINT 6,b6,17]
	pushj 17,diff_6
	add 10,1
	move 1,[POINT 6,ub6+2,35]
	move 2,[POINT 6,ub6,17]
	pushj 17,diffu_6
	add 10,1
	move 1,[POINT 7,b7+3,20]
	move 2,[POINT 7,b7,20]
	pushj 17,diff_7
	add 10,1
	move 1,[POINT 7,ub7+3,20]
	move 2,[POINT 7,ub7,20]
	pushj 17,diffu_7
	add 10,1
	move 1,[POINT 8,b8+4,15]
	move 2,[POINT 8,b8,23]
	pushj 17,diff_8
	add 10,1
	move 1,[POINT 8,ub8+4,15]
	move 2,[POINT 8,ub8,23]
	pushj 17,diffu_8
	add 10,1
	move 1,[POINT 9,b9+4,17]
	move 2,[POINT 9,b9,26]
	pushj 17,diff_9
	add 10,1
	move 1,[POINT 9,ub9+4,17]
	move 2,[POINT 9,ub9,26]
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
	movei 1,wbuf+21
	movei 2,wbuf+2
	pushj 17,diff_word
	add 10,1
	move 1,[POINT 9,cbuf+4,17]
	move 2,[POINT 9,cbuf,26]
	pushj 17,rdiff_char
	add 10,1
	move 1,[POINT 6,b6+2,35]
	move 2,[POINT 6,b6,17]
	pushj 17,rdiff_6
	add 10,1
	move 1,[POINT 7,b7+3,20]
	move 2,[POINT 7,b7,20]
	pushj 17,rdiff_7
	add 10,1
	move 1,[POINT 8,b8+4,15]
	move 2,[POINT 8,b8,23]
	pushj 17,rdiff_8
	add 10,1
	move 1,[POINT 9,b9+4,17]
	move 2,[POINT 9,b9,26]
	pushj 17,rdiff_9
	add 10,1
	move 1,[POINT 18,h16+4,35]
	move 2,[POINT 18,h16+1,17]
	pushj 17,rdiff_16
	add 10,1
	move 1,[POINT 18,h18+4,35]
	move 2,[POINT 18,h18+1,17]
	pushj 17,rdiff_18
	add 10,1
	move 1,[POINT 9,cbuf+6,8]
	move 2,11
	pushj 17,span_char
	add 10,1
	move 1,[POINT 9,ucbuf+6,8]
	move 2,11
	pushj 17,span_uchar
	add 10,1
	move 1,[POINT 6,b6+4,5]
	move 2,11
	pushj 17,span_6
	add 10,1
	move 1,[POINT 6,ub6+4,5]
	move 2,11
	pushj 17,spanu_6
	add 10,1
	move 1,[POINT 7,b7+4,34]
	move 2,11
	pushj 17,span_7
	add 10,1
	move 1,[POINT 7,ub7+4,34]
	move 2,11
	pushj 17,spanu_7
	add 10,1
	move 1,[POINT 8,b8+6,7]
	move 2,11
	pushj 17,span_8
	add 10,1
	move 1,[POINT 8,ub8+6,7]
	move 2,11
	pushj 17,spanu_8
	add 10,1
	move 1,[POINT 9,b9+6,8]
	move 2,11
	pushj 17,span_9
	add 10,1
	move 1,[POINT 9,ub9+6,8]
	move 2,11
	pushj 17,spanu_9
	add 10,1
	move 1,[POINT 18,h16+10,17]
	move 2,11
	pushj 17,span_16
	add 10,1
	move 1,[POINT 18,uh16+10,17]
	move 2,11
	pushj 17,spanu_16
	add 10,1
	move 1,[POINT 18,h18+10,17]
	move 2,11
	pushj 17,span_18
	add 10,1
	move 1,[POINT 18,uh18+10,17]
	move 2,11
	pushj 17,spanu_18
	add 10,1
	movei 1,wbuf+20
	move 2,11
	pushj 17,span_word
	add 10,1
	move 1,[POINT 9,cbuf+6,8]
	move 2,11
	pushj 17,backspan_char
	add 10,1
	move 1,[POINT 6,b6+4,5]
	move 2,11
	pushj 17,backspan_6
	add 10,1
	move 1,[POINT 7,b7+4,34]
	move 2,11
	pushj 17,backspan_7
	add 10,1
	move 1,[POINT 8,b8+6,7]
	move 2,11
	pushj 17,backspan_8
	add 10,1
	move 1,[POINT 9,b9+6,8]
	move 2,11
	pushj 17,backspan_9
	add 10,1
	move 1,[POINT 18,h16+10,17]
	move 2,11
	pushj 17,backspan_16
	add 10,1
	move 1,[POINT 18,h18+10,17]
	move 2,11
	pushj 17,backspan_18
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idx_char
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idx_uchar
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idx_6
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idxu_6
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idx_7
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idxu_7
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idx_8
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idxu_8
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idx_9
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idxu_9
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idx_16
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idxu_16
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idx_18
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idxu_18
	add 10,1
	move 1,12
	move 2,13
	pushj 17,idx_word
	add 10,1
	pushj 17,const_char
	add 10,1
	pushj 17,const_uchar
	add 10,1
	pushj 17,const_6
	add 10,1
	pushj 17,constu_6
	add 10,1
	pushj 17,const_7
	add 10,1
	pushj 17,constu_7
	add 10,1
	pushj 17,const_8
	add 10,1
	pushj 17,constu_8
	add 10,1
	pushj 17,const_9
	add 10,1
	pushj 17,constu_9
	add 10,1
	pushj 17,const_16
	add 10,1
	pushj 17,constu_16
	add 10,1
	pushj 17,const_18
	add 10,1
	pushj 17,constu_18
	add 10,1
	pushj 17,const_word
	add 10,1
	move 1,12
	move 2,13
	move 3,11
	pushj 17,sum_selected_diffs
	add 10,1
	move 1,[POINT 6,b6+2,35]
	move 2,[POINT 6,b6,17]
	move 3,14
	pushj 17,compare_diff_6
	add 10,1
	move 1,[POINT 9,b9+4,17]
	move 2,[POINT 9,b9,26]
	move 3,14
	pushj 17,compare_diff_9
	add 10,1
	andi 14,17
	move 1,[POINT 18,h18+4,35]
	move 2,[POINT 18,h18+1,17]
	move 3,14
	pushj 17,compare_diff_18
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.bss
cbuf:
	.space	48
ucbuf:
	.space	48
b6:
	.space	48
ub6:
	.space	48
b7:
	.space	48
ub7:
	.space	48
b8:
	.space	48
ub8:
	.space	48
b9:
	.space	48
ub9:
	.space	48
h16:
	.space	64
uh16:
	.space	64
h18:
	.space	64
uh18:
	.space	64
wbuf:
	.space	128
vpc:
	.space	4
vpuc:
	.space	4
vp6:
	.space	4
vpu6:
	.space	4
vp7:
	.space	4
vpu7:
	.space	4
vp8:
	.space	4
vpu8:
	.space	4
vp9:
	.space	4
vpu9:
	.space	4
vph16:
	.space	4
vpuh16:
	.space	4
vph18:
	.space	4
vpuh18:
	.space	4
vpw:
	.space	4
