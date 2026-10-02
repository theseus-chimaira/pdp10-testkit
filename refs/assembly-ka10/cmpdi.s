
make_dint:
	push 17,10
	move 5,1
	ash 1,-43
	move 4,1
	lshc 4,45
	tlne 4,400000
	tlo 5,400000
	move 7,2
	movei 6,0
	move 2,5
	add 2,7
	move 3,2
	tlc 3,400000
	move 10,5
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,4
	add 1,6
	add 1,3
	pop 17,10
	popj 17,

make_udint:
	push 17,10
	move 5,1
	movei 4,0
	lshc 4,45
	tlne 4,400000
	tlo 5,400000
	move 7,2
	movei 6,0
	move 2,5
	add 2,7
	move 3,2
	tlc 3,400000
	move 10,5
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,4
	add 1,6
	add 1,3
	pop 17,10
	popj 17,

cmpdi_eq:
	movei 6,0
	camn 1,3
	jrst %L5
%L4:
	move 1,6
	popj 17,
%L5:
	came 2,4
	jrst %L4
	movei 6,1
	jrst %L4

cmpdi_ne:
	movei 6,0
	camn 1,3
	jrst %L9
%L8:
	movei 6,1
%L7:
	move 1,6
	popj 17,
%L9:
	came 2,4
	jrst %L8
	jrst %L7

cmpdi_lt:
	movei 6,0
	camle 3,1
	jrst %L12
	camn 3,1
	jrst %L13
%L11:
	move 1,6
	popj 17,
%L13:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L11
%L12:
	movei 6,1
	jrst %L11

cmpdi_le:
	move 4,3
	move 5,4
	movei 6,0
	camle 1,4
	jrst %L15
	camn 1,4
	jrst %L17
%L16:
	movei 6,1
%L15:
	move 1,6
	popj 17,
%L17:
	move 3,2
	tlc 3,400000
	move 4,5
	tlc 4,400000
	camg 3,4
	jrst %L16
	jrst %L15

cmpdi_gt:
	move 4,3
	move 5,4
	movei 6,0
	camle 1,4
	jrst %L20
	camn 1,4
	jrst %L21
%L19:
	move 1,6
	popj 17,
%L21:
	move 3,2
	tlc 3,400000
	move 4,5
	tlc 4,400000
	camg 3,4
	jrst %L19
%L20:
	movei 6,1
	jrst %L19

cmpdi_ge:
	movei 6,0
	camle 3,1
	jrst %L23
	camn 3,1
	jrst %L25
%L24:
	movei 6,1
%L23:
	move 1,6
	popj 17,
%L25:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L24
	jrst %L23

cmpdi_ueq:
	movei 6,0
	camn 1,3
	jrst %L28
%L27:
	move 1,6
	popj 17,
%L28:
	came 2,4
	jrst %L27
	movei 6,1
	jrst %L27

cmpdi_une:
	movei 6,0
	camn 1,3
	jrst %L32
%L31:
	movei 6,1
%L30:
	move 1,6
	popj 17,
%L32:
	came 2,4
	jrst %L31
	jrst %L30

cmpdi_ult:
	move 6,3
	move 7,4
	movei 5,0
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	jrst %L35
	camn 6,1
	jrst %L36
%L34:
	move 1,5
	popj 17,
%L36:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L34
%L35:
	movei 5,1
	jrst %L34

cmpdi_ule:
	move 6,3
	move 7,4
	movei 5,0
	move 3,1
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camle 3,4
	jrst %L38
	camn 1,6
	jrst %L40
%L39:
	movei 5,1
%L38:
	move 1,5
	popj 17,
%L40:
	move 3,2
	tlc 3,400000
	move 4,7
	tlc 4,400000
	camg 3,4
	jrst %L39
	jrst %L38

cmpdi_ugt:
	move 6,3
	move 7,4
	movei 5,0
	move 3,1
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camle 3,4
	jrst %L43
	camn 1,6
	jrst %L44
%L42:
	move 1,5
	popj 17,
%L44:
	move 3,2
	tlc 3,400000
	move 4,7
	tlc 4,400000
	camg 3,4
	jrst %L42
%L43:
	movei 5,1
	jrst %L42

cmpdi_uge:
	move 6,3
	move 7,4
	movei 5,0
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	jrst %L46
	camn 6,1
	jrst %L48
%L47:
	movei 5,1
%L46:
	move 1,5
	popj 17,
%L48:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L47
	jrst %L46

cmpdi_eq_zero:
	movei 4,0
	ior 1,2
	jumpn 1,%L50
	movei 4,1
%L50:
	move 1,4
	popj 17,

cmpdi_ne_zero:
	movei 4,0
	ior 1,2
	jumpe 1,%L52
	movei 4,1
%L52:
	move 1,4
	popj 17,

cmpdi_lt_zero:
	movei 4,0
	jumpl 1,%L55
	jumpn 1,%L54
	cail 2,0
	cail 2,0
	jrst %L54
%L55:
	movei 4,1
%L54:
	move 1,4
	popj 17,

cmpdi_le_zero:
	movei 4,0
	jumple 1,%L59
%L57:
	move 1,4
	popj 17,
%L59:
	jumpn 1,%L58
	cail 2,0
	cail 2,1
	jrst %L57
%L58:
	movei 4,1
	jrst %L57

cmpdi_gt_zero:
	movei 4,0
	jumple 1,%L63
%L62:
	movei 4,1
%L61:
	move 1,4
	popj 17,
%L63:
	jumpn 1,%L61
	cail 2,0
	cail 2,1
	jrst %L62
	jrst %L61

cmpdi_ge_zero:
	movei 4,0
	jumpl 1,%L65
	jumpn 1,%L66
	cail 2,0
	cail 2,0
%L66:
	movei 4,1
%L65:
	move 1,4
	popj 17,

cmpdi_ueq_zero:
	movei 4,0
	ior 1,2
	jumpn 1,%L68
	movei 4,1
%L68:
	move 1,4
	popj 17,

cmpdi_une_zero:
	movei 4,0
	ior 1,2
	jumpe 1,%L70
	movei 4,1
%L70:
	move 1,4
	popj 17,

cmpdi_ugt_zero:
	movei 4,0
	ior 1,2
	jumpe 1,%L72
	movei 4,1
%L72:
	move 1,4
	popj 17,

cmpdi_uge_zero:
	movei 1,1
	popj 17,

cmpdi_eq_one:
	movei 4,0
	jumpn 1,%L75
	cain 2,1
	jrst %L76
%L75:
	move 1,4
	popj 17,
%L76:
	movei 4,1
	jrst %L75

cmpdi_ne_one:
	movei 4,0
	jumpn 1,%L79
	caie 2,1
%L79:
	movei 4,1
	move 1,4
	popj 17,

cmpdi_lt_one:
	movei 4,0
	jumple 1,%L83
%L81:
	move 1,4
	popj 17,
%L83:
	jumpn 1,%L82
	cail 2,0
	cail 2,1
	jrst %L81
%L82:
	movei 4,1
	jrst %L81

cmpdi_ge_one:
	movei 4,0
	jumple 1,%L87
%L86:
	movei 4,1
%L85:
	move 1,4
	popj 17,
%L87:
	jumpn 1,%L85
	cail 2,0
	cail 2,1
	jrst %L86
	jrst %L85

cmpdi_eq_minus_one:
	movei 4,0
	camn 1,[-1]
	jrst %L90
%L89:
	move 1,4
	popj 17,
%L90:
	came 2,[-1]
	jrst %L89
	movei 4,1
	jrst %L89

cmpdi_lt_minus_one:
	movei 3,0
	camge 1,[-1]
	jrst %L93
	camn 1,[-1]
	jrst %L94
%L92:
	move 1,3
	popj 17,
%L94:
	move 4,2
	tlc 4,400000
	caml 4,[377777777777]
	jrst %L92
%L93:
	movei 3,1
	jrst %L92

cmpdi_ge_minus_one:
	movei 3,0
	camge 1,[-1]
	jrst %L96
	camn 1,[-1]
	jrst %L98
%L97:
	movei 3,1
%L96:
	move 1,3
	popj 17,
%L98:
	move 4,2
	tlc 4,400000
	caml 4,[377777777777]
	jrst %L97
	jrst %L96

cmpdi_eq_low18:
	movei 4,0
	jumpn 1,%L100
	cain 2,777777
	jrst %L101
%L100:
	move 1,4
	popj 17,
%L101:
	movei 4,1
	jrst %L100

cmpdi_lt_low18:
	movei 4,0
	jumple 1,%L105
%L103:
	move 1,4
	popj 17,
%L105:
	jumpn 1,%L104
	cail 2,0
	cail 2,777777
	jrst %L103
%L104:
	movei 4,1
	jrst %L103

cmpdi_ge_low18:
	movei 4,0
	jumple 1,%L109
%L108:
	movei 4,1
%L107:
	move 1,4
	popj 17,
%L109:
	jumpn 1,%L107
	cail 2,0
	cail 2,777777
	jrst %L108
	jrst %L107

cmpdi_eq_word_cross:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,1
	movei 2,0
	pushj 17,make_dint
	movei 4,0
	camn 10,1
	jrst %L112
%L111:
	move 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L112:
	came 11,2
	jrst %L111
	movei 4,1
	jrst %L111

cmpdi_lt_word_cross:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,1
	movei 2,0
	pushj 17,make_dint
	movei 6,0
	camle 1,10
	jrst %L115
	camn 1,10
	jrst %L116
%L114:
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L116:
	move 3,2
	tlc 3,400000
	move 4,11
	tlc 4,400000
	camg 3,4
	jrst %L114
%L115:
	movei 6,1
	jrst %L114

cmpdi_ge_word_cross:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,1
	movei 2,0
	pushj 17,make_dint
	movei 6,0
	camle 1,10
	jrst %L118
	camn 1,10
	jrst %L120
%L119:
	movei 6,1
%L118:
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L120:
	move 3,2
	tlc 3,400000
	move 4,11
	tlc 4,400000
	camg 3,4
	jrst %L119
	jrst %L118

cmpdi_eq_large_const:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,123456
	movei 2,654321
	pushj 17,make_dint
	movei 4,0
	camn 10,1
	jrst %L123
%L122:
	move 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L123:
	came 11,2
	jrst %L122
	movei 4,1
	jrst %L122

cmpdi_lt_large_const:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,123456
	movei 2,654321
	pushj 17,make_dint
	movei 6,0
	camle 1,10
	jrst %L126
	camn 1,10
	jrst %L127
%L125:
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L127:
	move 3,2
	tlc 3,400000
	move 4,11
	tlc 4,400000
	camg 3,4
	jrst %L125
%L126:
	movei 6,1
	jrst %L125

cmpdi_gt_large_const:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,123456
	movei 2,654321
	pushj 17,make_dint
	movei 6,0
	camle 10,1
	jrst %L130
	camn 10,1
	jrst %L131
%L129:
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L131:
	move 3,11
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L129
%L130:
	movei 6,1
	jrst %L129

cmpdi_ult_large_const:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,123456
	movei 2,654321
	pushj 17,make_udint
	movei 6,0
	move 3,1
	tlc 3,400000
	move 4,10
	tlc 4,400000
	camle 3,4
	jrst %L134
	camn 1,10
	jrst %L135
%L133:
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L135:
	move 3,2
	tlc 3,400000
	move 4,11
	tlc 4,400000
	camg 3,4
	jrst %L133
%L134:
	movei 6,1
	jrst %L133

cmpdi_uge_large_const:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,123456
	movei 2,654321
	pushj 17,make_udint
	movei 6,0
	move 3,1
	tlc 3,400000
	move 4,10
	tlc 4,400000
	camle 3,4
	jrst %L137
	camn 1,10
	jrst %L139
%L138:
	movei 6,1
%L137:
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L139:
	move 3,2
	tlc 3,400000
	move 4,11
	tlc 4,400000
	camg 3,4
	jrst %L138
	jrst %L137

cmpdi_mem_eq:
	movei 4,0
	move 6,(1)
	camn 6,(2)
	jrst %L142
%L141:
	move 1,4
	popj 17,
%L142:
	move 1,1(1)
	came 1,1(2)
	jrst %L141
	movei 4,1
	jrst %L141

cmpdi_mem_ne:
	movei 4,0
	move 6,(1)
	camn 6,(2)
	jrst %L146
%L145:
	movei 4,1
%L144:
	move 1,4
	popj 17,
%L146:
	move 1,1(1)
	came 1,1(2)
	jrst %L145
	jrst %L144

cmpdi_mem_lt:
	movei 6,0
	move 3,(2)
	move 4,(1)
	camle 3,4
	jrst %L149
	camn 3,4
	jrst %L150
%L148:
	move 1,6
	popj 17,
%L150:
	move 3,1(2)
	tlc 3,400000
	move 4,1(1)
	tlc 4,400000
	camg 3,4
	jrst %L148
%L149:
	movei 6,1
	jrst %L148

cmpdi_mem_le:
	movei 6,0
	move 3,(1)
	move 4,(2)
	camle 3,4
	jrst %L152
	camn 3,4
	jrst %L154
%L153:
	movei 6,1
%L152:
	move 1,6
	popj 17,
%L154:
	move 3,1(1)
	tlc 3,400000
	move 4,1(2)
	tlc 4,400000
	camg 3,4
	jrst %L153
	jrst %L152

cmpdi_mem_gt:
	movei 6,0
	move 3,(1)
	move 4,(2)
	camle 3,4
	jrst %L157
	camn 3,4
	jrst %L158
%L156:
	move 1,6
	popj 17,
%L158:
	move 3,1(1)
	tlc 3,400000
	move 4,1(2)
	tlc 4,400000
	camg 3,4
	jrst %L156
%L157:
	movei 6,1
	jrst %L156

cmpdi_mem_ge:
	movei 6,0
	move 3,(2)
	move 4,(1)
	camle 3,4
	jrst %L160
	camn 3,4
	jrst %L162
%L161:
	movei 6,1
%L160:
	move 1,6
	popj 17,
%L162:
	move 3,1(2)
	tlc 3,400000
	move 4,1(1)
	tlc 4,400000
	camg 3,4
	jrst %L161
	jrst %L160

cmpdi_umem_lt:
	movei 5,0
	move 7,(2)
	move 6,(1)
	move 3,7
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camle 3,4
	jrst %L165
	camn 7,6
	jrst %L166
%L164:
	move 1,5
	popj 17,
%L166:
	move 3,1(2)
	tlc 3,400000
	move 4,1(1)
	tlc 4,400000
	camg 3,4
	jrst %L164
%L165:
	movei 5,1
	jrst %L164

cmpdi_umem_le:
	movei 5,0
	move 7,(1)
	move 6,(2)
	move 3,7
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camle 3,4
	jrst %L168
	camn 7,6
	jrst %L170
%L169:
	movei 5,1
%L168:
	move 1,5
	popj 17,
%L170:
	move 3,1(1)
	tlc 3,400000
	move 4,1(2)
	tlc 4,400000
	camg 3,4
	jrst %L169
	jrst %L168

cmpdi_umem_gt:
	movei 5,0
	move 7,(1)
	move 6,(2)
	move 3,7
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camle 3,4
	jrst %L173
	camn 7,6
	jrst %L174
%L172:
	move 1,5
	popj 17,
%L174:
	move 3,1(1)
	tlc 3,400000
	move 4,1(2)
	tlc 4,400000
	camg 3,4
	jrst %L172
%L173:
	movei 5,1
	jrst %L172

cmpdi_umem_ge:
	movei 5,0
	move 7,(2)
	move 6,(1)
	move 3,7
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camle 3,4
	jrst %L176
	camn 7,6
	jrst %L178
%L177:
	movei 5,1
%L176:
	move 1,5
	popj 17,
%L178:
	move 3,1(2)
	tlc 3,400000
	move 4,1(1)
	tlc 4,400000
	camg 3,4
	jrst %L177
	jrst %L176

cmpdi_reg_mem_eq:
	movei 4,0
	move 6,(3)
	camn 6,1
	jrst %L181
%L180:
	move 1,4
	popj 17,
%L181:
	move 3,1(3)
	came 3,2
	jrst %L180
	movei 4,1
	jrst %L180

cmpdi_reg_mem_lt:
	movei 6,0
	move 4,(3)
	camle 4,1
	jrst %L184
	camn 4,1
	jrst %L185
%L183:
	move 1,6
	popj 17,
%L185:
	move 3,1(3)
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L183
%L184:
	movei 6,1
	jrst %L183

cmpdi_reg_mem_ge:
	movei 6,0
	move 4,(3)
	camle 4,1
	jrst %L187
	camn 4,1
	jrst %L189
%L188:
	movei 6,1
%L187:
	move 1,6
	popj 17,
%L189:
	move 3,1(3)
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L188
	jrst %L187

cmpdi_mem_reg_lt:
	move 4,2
	move 5,3
	movei 2,0
	move 3,(1)
	camge 3,4
	jrst %L192
	camn 3,4
	jrst %L193
%L191:
	move 1,2
	popj 17,
%L193:
	move 3,1(1)
	tlc 3,400000
	move 4,5
	tlc 4,400000
	caml 3,4
	jrst %L191
%L192:
	movei 2,1
	jrst %L191

cmpdi_mem_reg_ge:
	move 4,2
	move 5,3
	movei 2,0
	move 3,(1)
	camge 3,4
	jrst %L195
	camn 3,4
	jrst %L197
%L196:
	movei 2,1
%L195:
	move 1,2
	popj 17,
%L197:
	move 3,1(1)
	tlc 3,400000
	move 4,5
	tlc 4,400000
	caml 3,4
	jrst %L196
	jrst %L195

cmpdi_volatile_eq:
	movei 6,0
	move 3,(1)
	move 4,(2)
	camn 3,4
	jrst %L200
%L199:
	move 1,6
	popj 17,
%L200:
	move 3,1(1)
	move 4,1(2)
	came 3,4
	jrst %L199
	movei 6,1
	jrst %L199

cmpdi_volatile_lt:
	movei 6,0
	move 3,(2)
	move 4,(1)
	camle 3,4
	jrst %L203
	move 3,(2)
	move 4,(1)
	camn 3,4
	jrst %L204
%L202:
	move 1,6
	popj 17,
%L204:
	move 3,1(2)
	move 4,1(1)
	tlc 3,400000
	tlc 4,400000
	camle 3,4
	jrst %L203
	move 4,1(2)
	move 4,1(1)
	jrst %L202
%L203:
	movei 6,1
	jrst %L202

cmpdi_volatile_ge:
	movei 6,0
	move 3,(2)
	move 4,(1)
	camle 3,4
	jrst %L206
	move 3,(2)
	move 4,(1)
	camn 3,4
	jrst %L208
%L207:
	movei 6,1
%L206:
	move 1,6
	popj 17,
%L208:
	move 3,1(2)
	move 4,1(1)
	tlc 3,400000
	tlc 4,400000
	camle 3,4
	jrst %L206
	move 4,1(2)
	move 4,1(1)
	jrst %L207

cmpdi_global_eq:
	movei 4,0
	move 6,cmpdi_ga
	camn 6,1
	jrst %L211
%L210:
	move 1,4
	popj 17,
%L211:
	move 6,cmpdi_ga+1
	came 6,2
	jrst %L210
	movei 4,1
	jrst %L210

cmpdi_global_lt:
	movei 6,0
	move 4,cmpdi_ga
	camge 4,1
	jrst %L214
	camn 4,1
	jrst %L215
%L213:
	move 1,6
	popj 17,
%L215:
	move 3,cmpdi_ga+1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	caml 3,4
	jrst %L213
%L214:
	movei 6,1
	jrst %L213

cmpdi_global_ge:
	movei 6,0
	move 4,cmpdi_gb
	camge 4,1
	jrst %L217
	camn 4,1
	jrst %L219
%L218:
	movei 6,1
%L217:
	move 1,6
	popj 17,
%L219:
	move 3,cmpdi_gb+1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	caml 3,4
	jrst %L218
	jrst %L217

cmpdi_uglobal_lt:
	movei 7,0
	move 6,cmpdi_uga
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	jrst %L222
	camn 6,1
	jrst %L223
%L221:
	move 1,7
	popj 17,
%L223:
	move 3,cmpdi_uga+1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	caml 3,4
	jrst %L221
%L222:
	movei 7,1
	jrst %L221

cmpdi_uglobal_ge:
	movei 7,0
	move 6,cmpdi_ugb
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	jrst %L225
	camn 6,1
	jrst %L227
%L226:
	movei 7,1
%L225:
	move 1,7
	popj 17,
%L227:
	move 3,cmpdi_ugb+1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	caml 3,4
	jrst %L226
	jrst %L225

cmpdi_array_eq:
	movei 6,0
	andi 2,17
	lsh 2,1
	add 2,1
	move 7,(2)
	camn 7,3
	jrst %L231
%L229:
	move 1,6
	popj 17,
%L231:
	move 2,1(2)
	came 2,4
	jrst %L229
	movei 6,1
	jrst %L229

cmpdi_array_lt:
	move 4,3
	move 5,4
	movei 6,0
	andi 2,17
	lsh 2,1
	add 2,1
	move 3,(2)
	camge 3,4
	jrst %L235
	camn 3,4
	jrst %L236
%L233:
	move 1,6
	popj 17,
%L236:
	move 3,1(2)
	tlc 3,400000
	move 4,5
	tlc 4,400000
	caml 3,4
	jrst %L233
%L235:
	movei 6,1
	jrst %L233

cmpdi_array_ge:
	move 4,3
	move 5,4
	movei 6,0
	andi 2,17
	lsh 2,1
	add 2,1
	move 3,(2)
	camge 3,4
	jrst %L238
	camn 3,4
	jrst %L241
%L240:
	movei 6,1
%L238:
	move 1,6
	popj 17,
%L241:
	move 3,1(2)
	tlc 3,400000
	move 4,5
	tlc 4,400000
	caml 3,4
	jrst %L240
	jrst %L238

cmpdi_uarray_lt:
	move 6,3
	move 7,4
	movei 5,0
	andi 2,17
	lsh 2,1
	add 2,1
	move 1,(2)
	move 3,1
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camge 3,4
	jrst %L245
	camn 1,6
	jrst %L246
%L243:
	move 1,5
	popj 17,
%L246:
	move 3,1(2)
	tlc 3,400000
	move 4,7
	tlc 4,400000
	caml 3,4
	jrst %L243
%L245:
	movei 5,1
	jrst %L243

cmpdi_uarray_ge:
	move 6,3
	move 7,4
	movei 5,0
	andi 2,17
	lsh 2,1
	add 2,1
	move 1,(2)
	move 3,1
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camge 3,4
	jrst %L248
	camn 1,6
	jrst %L251
%L250:
	movei 5,1
%L248:
	move 1,5
	popj 17,
%L251:
	move 3,1(2)
	tlc 3,400000
	move 4,7
	tlc 4,400000
	caml 3,4
	jrst %L250
	jrst %L248

cmpdi_global_array_eq:
	movei 6,0
	andi 1,17
	lsh 1,1
	xmovei 4,cmpdi_buf(1)
	move 1,cmpdi_buf(1)
	camn 1,2
	jrst %L254
%L253:
	move 1,6
	popj 17,
%L254:
	move 4,1(4)
	came 4,3
	jrst %L253
	movei 6,1
	jrst %L253

cmpdi_global_array_lt:
	move 4,2
	move 5,3
	movei 6,0
	andi 1,17
	lsh 1,1
	xmovei 2,cmpdi_buf(1)
	move 3,cmpdi_buf(1)
	camge 3,4
	jrst %L257
	camn 3,4
	jrst %L258
%L256:
	move 1,6
	popj 17,
%L258:
	move 3,1(2)
	tlc 3,400000
	move 4,5
	tlc 4,400000
	caml 3,4
	jrst %L256
%L257:
	movei 6,1
	jrst %L256

cmpdi_global_uarray_lt:
	push 17,10
	move 6,2
	move 7,3
	movei 10,0
	andi 1,17
	lsh 1,1
	xmovei 5,cmpdi_ubuf(1)
	move 2,cmpdi_ubuf(1)
	move 3,2
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camge 3,4
	jrst %L261
	camn 2,6
	jrst %L262
%L260:
	move 1,10
	pop 17,10
	popj 17,
%L262:
	move 3,1(5)
	tlc 3,400000
	move 4,7
	tlc 4,400000
	caml 3,4
	jrst %L260
%L261:
	movei 10,1
	jrst %L260

cmpdi_struct_eq:
	movei 4,0
	move 6,(1)
	camn 6,2
	jrst %L265
%L264:
	move 1,4
	popj 17,
%L265:
	move 1,1(1)
	came 1,3
	jrst %L264
	movei 4,1
	jrst %L264

cmpdi_struct_lt:
	move 4,2
	move 5,3
	movei 2,0
	move 3,(1)
	camge 3,4
	jrst %L268
	camn 3,4
	jrst %L269
%L267:
	move 1,2
	popj 17,
%L269:
	move 3,1(1)
	tlc 3,400000
	move 4,5
	tlc 4,400000
	caml 3,4
	jrst %L267
%L268:
	movei 2,1
	jrst %L267

cmpdi_struct_ge:
	move 4,2
	move 5,3
	movei 2,0
	move 3,2(1)
	camge 3,4
	jrst %L271
	camn 3,4
	jrst %L273
%L272:
	movei 2,1
%L271:
	move 1,2
	popj 17,
%L273:
	move 3,3(1)
	tlc 3,400000
	move 4,5
	tlc 4,400000
	caml 3,4
	jrst %L272
	jrst %L271

cmpdi_ustruct_lt:
	move 6,2
	move 7,3
	movei 5,0
	move 2,(1)
	move 3,2
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camge 3,4
	jrst %L276
	camn 2,6
	jrst %L277
%L275:
	move 1,5
	popj 17,
%L277:
	move 3,1(1)
	tlc 3,400000
	move 4,7
	tlc 4,400000
	caml 3,4
	jrst %L275
%L276:
	movei 5,1
	jrst %L275

cmpdi_ustruct_ge:
	move 6,2
	move 7,3
	movei 5,0
	move 2,2(1)
	move 3,2
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camge 3,4
	jrst %L279
	camn 2,6
	jrst %L281
%L280:
	movei 5,1
%L279:
	move 1,5
	popj 17,
%L281:
	move 3,3(1)
	tlc 3,400000
	move 4,7
	tlc 4,400000
	caml 3,4
	jrst %L280
	jrst %L279

cmpdi_global_struct_eq:
	movei 4,0
	move 6,cmpdi_gp
	camn 6,1
	jrst %L284
%L283:
	move 1,4
	popj 17,
%L284:
	move 6,cmpdi_gp+1
	came 6,2
	jrst %L283
	movei 4,1
	jrst %L283

cmpdi_global_struct_lt:
	movei 6,0
	move 4,cmpdi_gp
	camge 4,1
	jrst %L287
	camn 4,1
	jrst %L288
%L286:
	move 1,6
	popj 17,
%L288:
	move 3,cmpdi_gp+1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	caml 3,4
	jrst %L286
%L287:
	movei 6,1
	jrst %L286

cmpdi_global_ustruct_lt:
	movei 7,0
	move 6,cmpdi_ugp
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camge 3,4
	jrst %L291
	camn 6,1
	jrst %L292
%L290:
	move 1,7
	popj 17,
%L292:
	move 3,cmpdi_ugp+1
	tlc 3,400000
	move 4,2
	tlc 4,400000
	caml 3,4
	jrst %L290
%L291:
	movei 7,1
	jrst %L290

cmpdi_branch:
	push 17,10
	move 6,3
	move 7,4
	move 5,-2(17)
	move 10,-3(17)
	camle 6,1
	jrst %L295
	camn 6,1
	jrst %L297
%L294:
	camn 1,6
	jrst %L298
%L296:
	move 4,10
%L293:
	move 1,4
	pop 17,10
	popj 17,
%L298:
	move 4,5
	add 4,10
	came 2,7
	jrst %L296
	jrst %L293
%L297:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L294
%L295:
	move 4,5
	jrst %L293

cmpdi_branch_all:
	move 6,3
	move 7,4
	camle 6,1
	jrst %L301
	camn 6,1
	jrst %L304
%L300:
	camle 1,6
	jrst %L303
	camn 1,6
	jrst %L305
%L302:
	movei 1,0
%L299:
	popj 17,
%L305:
	move 3,2
	tlc 3,400000
	move 4,7
	tlc 4,400000
	camg 3,4
	jrst %L302
%L303:
	movei 1,1
	popj 17,
%L304:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L300
%L301:
	seto 1,
	popj 17,

cmpdi_branch_inverted:
	push 17,10
	move 6,3
	move 7,4
	move 5,-2(17)
	move 10,-3(17)
	camle 6,1
	jrst %L308
	camn 6,1
	jrst %L310
%L307:
	camn 1,6
	jrst %L311
%L309:
	move 4,10
%L306:
	move 1,4
	pop 17,10
	popj 17,
%L311:
	move 4,5
	add 4,10
	came 2,7
	jrst %L309
	jrst %L306
%L310:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L307
%L308:
	move 4,5
	jrst %L306

cmpdi_branch_zero:
	move 6,4
	jumpl 1,%L314
	jumpn 1,%L313
	cail 2,0
	cail 2,0
	jrst %L313
%L314:
	move 1,3
%L312:
	popj 17,
%L313:
	move 4,1
	ior 4,2
	move 1,3
	add 1,6
	jumpe 4,%L312
	move 1,6
	popj 17,

cmpdi_branch_const:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	move 12,3
	move 13,4
	movei 1,1
	movei 2,0
	pushj 17,make_dint
	camle 1,10
	jrst %L318
	camn 1,10
	jrst %L320
%L317:
	camn 10,1
	jrst %L321
%L319:
	move 3,13
%L316:
	move 1,3
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L321:
	move 3,12
	add 3,13
	came 11,2
	jrst %L319
	jrst %L316
%L320:
	move 3,2
	tlc 3,400000
	move 4,11
	tlc 4,400000
	camg 3,4
	jrst %L317
%L318:
	move 3,12
	jrst %L316

cmpdi_unsigned_branch:
	move 6,3
	move 7,4
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	jrst %L323
	camn 6,1
	jrst %L325
%L324:
	move 1,-1(17)
%L322:
	popj 17,
%L325:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L324
%L323:
	move 1,-2(17)
	popj 17,

cmpdi_unsigned_branch_all:
	push 17,10
	move 6,3
	move 7,4
	move 10,6
	tlc 10,400000
	move 5,1
	tlc 5,400000
	camle 10,5
	jrst %L328
	camn 6,1
	jrst %L331
%L327:
	camle 5,10
	jrst %L330
	camn 1,6
	jrst %L332
%L329:
	movei 1,0
%L326:
	pop 17,10
	popj 17,
%L332:
	move 3,2
	tlc 3,400000
	move 4,7
	tlc 4,400000
	camg 3,4
	jrst %L329
%L330:
	movei 1,1
	jrst %L326
%L331:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L327
%L328:
	seto 1,
	jrst %L326

cmpdi_unsigned_branch_inverted:
	move 6,3
	move 7,4
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	jrst %L334
	camn 6,1
	jrst %L336
%L335:
	move 1,-1(17)
%L333:
	popj 17,
%L336:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L335
%L334:
	move 1,-2(17)
	popj 17,

cmpdi_select_eq:
	camn 1,3
	jrst %L340
%L338:
	move 6,-2(17)
%L339:
	move 1,6
	popj 17,
%L340:
	move 6,-1(17)
	came 2,4
	jrst %L338
	jrst %L339

cmpdi_select_ne:
	camn 1,3
	jrst %L345
%L344:
	move 6,-1(17)
%L343:
	move 1,6
	popj 17,
%L345:
	move 6,-2(17)
	came 2,4
	jrst %L344
	jrst %L343

cmpdi_select_lt:
	camle 3,1
	jrst %L349
	camn 3,1
	jrst %L350
%L347:
	move 1,-2(17)
%L348:
	popj 17,
%L350:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L347
%L349:
	move 1,-1(17)
	popj 17,

cmpdi_select_ge:
	camle 3,1
	jrst %L352
	camn 3,1
	jrst %L355
%L354:
	move 1,-1(17)
%L353:
	popj 17,
%L355:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L354
%L352:
	move 1,-2(17)
	popj 17,

cmpdi_use_as_value_eq:
	movei 6,0
	camn 1,3
	jrst %L358
%L357:
	aos 1,6
	popj 17,
%L358:
	came 2,4
	jrst %L357
	movei 6,1
	jrst %L357

cmpdi_use_as_value_lt:
	movei 6,0
	camle 3,1
	jrst %L361
	camn 3,1
	jrst %L362
%L360:
	aos 1,6
	popj 17,
%L362:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L360
%L361:
	movei 6,1
	jrst %L360

cmpdi_use_as_value_ult:
	move 6,3
	move 7,4
	movei 5,0
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	jrst %L365
	camn 6,1
	jrst %L366
%L364:
	aos 1,5
	popj 17,
%L366:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L364
%L365:
	movei 5,1
	jrst %L364

cmpdi_and_condition:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,-4(17)
	move 11,-3(17)
	move 6,-6(17)
	move 7,-5(17)
	camle 3,1
	jrst %L369
	camn 3,1
	jrst %L371
%L368:
	movei 1,0
%L367:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L371:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L368
%L369:
	camn 10,6
	jrst %L372
%L370:
	movei 1,1
	jrst %L367
%L372:
	came 11,7
	jrst %L370
	jrst %L368

cmpdi_or_condition:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,-4(17)
	move 11,-3(17)
	move 6,-6(17)
	move 7,-5(17)
	camle 3,1
	jrst %L375
	camn 3,1
	jrst %L377
%L376:
	camn 10,6
	jrst %L378
%L374:
	movei 1,0
%L373:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L378:
	came 11,7
	jrst %L374
%L375:
	movei 1,1
	jrst %L373
%L377:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camle 3,4
	jrst %L375
	jrst %L376

cmpdi_mixed_signed_unsigned:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,-4(17)
	move 11,-3(17)
	move 6,-6(17)
	move 7,-5(17)
	camle 3,1
	jrst %L381
	camn 3,1
	jrst %L383
%L380:
	movei 1,0
%L379:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L383:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L380
%L381:
	move 3,6
	tlc 3,400000
	move 4,10
	tlc 4,400000
	camle 3,4
	jrst %L380
	camn 6,10
	jrst %L384
%L382:
	movei 1,1
	jrst %L379
%L384:
	move 3,7
	tlc 3,400000
	move 4,11
	tlc 4,400000
	camle 3,4
	jrst %L380
	jrst %L382

cmpdi_after_add:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,-6(17)
	move 13,-5(17)
	move 11,2
	add 11,4
	move 6,11
	tlc 6,400000
	move 7,2
	tlc 7,400000
	caml 6,7
	tdza 6,6
	movei 6,1
	move 10,1
	add 10,3
	add 10,6
	movei 1,0
	camle 12,10
	jrst %L387
	camn 12,10
	jrst %L388
%L386:
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L388:
	move 3,13
	tlc 3,400000
	move 4,11
	tlc 4,400000
	camg 3,4
	jrst %L386
%L387:
	movei 1,1
	jrst %L386

cmpdi_after_sub:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,-6(17)
	move 13,-5(17)
	move 11,2
	sub 11,4
	move 6,11
	tlc 6,400000
	move 7,2
	tlc 7,400000
	camg 6,7
	tdza 6,6
	movei 6,1
	move 10,1
	sub 10,3
	sub 10,6
	movei 1,0
	camn 10,12
	jrst %L391
%L390:
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L391:
	came 11,13
	jrst %L390
	movei 1,1
	jrst %L390

cmpdi_after_shift:
	tlne 1,200000
	tloa 1,400000
	tlz 1,400000
	ashc 1,1
	movei 6,0
	camle 3,1
	jrst %L393
	camn 3,1
	jrst %L395
%L394:
	movei 6,1
%L393:
	move 1,6
	popj 17,
%L395:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L394
	jrst %L393

cmpdi_unsigned_after_shift:
	move 6,3
	move 7,4
	ashc 1,-1
	tlze 1,400000
	tlz 2,400000
	movei 5,0
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	jrst %L398
	camn 6,1
	jrst %L399
%L397:
	move 1,5
	popj 17,
%L399:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L397
%L398:
	movei 5,1
	jrst %L397

cmpdi_call_pressure:
	push 17,10
	movei 10,0
	camle 3,1
	jrst %L402
	camn 3,1
	jrst %L403
%L401:
	move 1,10
	pushj 17,sink_int
	move 1,10
	pop 17,10
	popj 17,
%L403:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L401
%L402:
	movei 10,1
	jrst %L401

cmpdi_branch_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,-3(17)
	move 10,-4(17)
	camle 3,1
	jrst %L406
	camn 3,1
	jrst %L407
%L405:
	move 1,10
	pushj 17,sink_int
	move 1,10
%L404:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L407:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L405
%L406:
	move 1,11
	pushj 17,sink_int
	move 1,11
	jrst %L404

cmpdi_loop_count_less:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 6,2
	move 2,3
	move 3,4
	setzb 1,5
	caml 1,6
	jrst %L418
	move 11,3
	tlc 11,400000
	move 7,6
	subi 7,1
%L419:
	move 4,5
	andi 4,17
	lsh 4,1
	add 4,10
	move 6,(4)
	camge 6,2
	jrst %L415
	camn 6,2
	jrst %L420
%L411:
	addi 5,1
	sojge 7,%L419	; doloop_end
%L418:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L420:
	move 4,1(4)
	tlc 4,400000
	caml 4,11
	jrst %L411
%L415:
	aoja 1,%L411

cmpdi_loop_find_eq:
	move 5,1
	movei 7,0
	caml 7,2
	jrst %L430
%L428:
	move 6,7
	andi 6,17
	lsh 6,1
	add 6,5
	move 1,(6)
	camn 1,3
	jrst %L431
%L424:
	addi 7,1
	camge 7,2
	jrst %L428
%L430:
	seto 1,
%L421:
	popj 17,
%L431:
	move 1,7
	move 6,1(6)
	came 6,4
	jrst %L424
	popj 17,

cmpdi_loop_find_ge:
	push 17,10
	move 5,1
	move 7,2
	move 2,3
	move 3,4
	movei 1,0
	caml 1,7
	jrst %L442
	move 10,3
	tlc 10,400000
%L440:
	move 4,1
	andi 4,17
	lsh 4,1
	add 4,5
	move 6,(4)
	camge 6,2
	jrst %L435
	came 6,2
	jrst %L432
	move 4,1(4)
	tlc 4,400000
	caml 4,10
	jrst %L432
%L435:
	addi 1,1
	camge 1,7
	jrst %L440
%L442:
	seto 1,
%L432:
	pop 17,10
	popj 17,

cmpdi_unsigned_loop_count_less:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 10,3
	move 11,4
	setzb 1,3
	caml 1,2
	jrst %L453
	move 5,10
	tlc 5,400000
	move 13,11
	tlc 13,400000
	subi 2,1
%L454:
	move 6,3
	andi 6,17
	lsh 6,1
	add 6,12
	move 7,(6)
	move 4,7
	tlc 4,400000
	camge 4,5
	jrst %L450
	camn 7,10
	jrst %L455
%L446:
	addi 3,1
	sojge 2,%L454	; doloop_end
%L453:
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L455:
	move 4,1(6)
	tlc 4,400000
	caml 4,13
	jrst %L446
%L450:
	aoja 1,%L446

cmpdi_unsigned_loop_find_ge:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 10,2
	move 2,3
	move 3,4
	movei 1,0
	caml 1,10
	jrst %L466
	move 5,2
	tlc 5,400000
	move 12,3
	tlc 12,400000
%L464:
	move 6,1
	andi 6,17
	lsh 6,1
	add 6,11
	move 7,(6)
	move 4,7
	tlc 4,400000
	camge 4,5
	jrst %L459
	came 7,2
	jrst %L456
	move 4,1(6)
	tlc 4,400000
	caml 4,12
	jrst %L456
%L459:
	addi 1,1
	camge 1,10
	jrst %L464
%L466:
	seto 1,
%L456:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

cmpdi_struct_loop_count:
	push 17,10
	setzb 5,7
	caml 5,2
	jrst %L476
	subi 2,1
%L477:
	move 6,7
	andi 6,17
	lsh 6,2
	add 6,1
	move 10,(6)
	camn 10,3
	jrst %L478
%L470:
	addi 7,1
	sojge 2,%L477	; doloop_end
%L476:
	move 1,5
	pop 17,10
	popj 17,
%L478:
	move 6,1(6)
	came 6,4
	jrst %L470
	aoja 5,%L470

cmpdi_compare_then_store:
	move 6,3
	move 7,4
	camle 6,1
	jrst %L481
	camn 6,1
	jrst %L486
%L480:
	camle 1,6
	jrst %L484
	camn 1,6
	jrst %L487
%L483:
	movei 1,0
%L482:
	movem 1,@-1(17)
	popj 17,
%L487:
	move 3,2
	tlc 3,400000
	move 4,7
	tlc 4,400000
	camg 3,4
	jrst %L483
%L484:
	movei 1,1
	jrst %L482
%L486:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L480
%L481:
	seto 1,
	jrst %L482

cmpdi_compare_then_update:
	move 6,-1(17)
	camn 1,3
	jrst %L491
%L489:
	sos (6)
%L490:
	move 1,(6)
	popj 17,
%L491:
	came 2,4
	jrst %L489
	aos (6)
	jrst %L490

cmpdi_eq_orig:
	movei 6,0
	camn 1,3
	jrst %L494
%L493:
	move 1,6
	popj 17,
%L494:
	came 2,4
	jrst %L493
	movei 6,1
	jrst %L493

cmpdi_ne_orig:
	movei 6,0
	camn 1,3
	jrst %L498
%L497:
	movei 6,1
%L496:
	move 1,6
	popj 17,
%L498:
	came 2,4
	jrst %L497
	jrst %L496

cmpdi_lt_orig:
	movei 6,0
	camle 3,1
	jrst %L501
	camn 3,1
	jrst %L502
%L500:
	move 1,6
	popj 17,
%L502:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L500
%L501:
	movei 6,1
	jrst %L500

cmpdi_le_orig:
	move 4,3
	move 5,4
	movei 6,0
	camle 1,4
	jrst %L504
	camn 1,4
	jrst %L506
%L505:
	movei 6,1
%L504:
	move 1,6
	popj 17,
%L506:
	move 3,2
	tlc 3,400000
	move 4,5
	tlc 4,400000
	camg 3,4
	jrst %L505
	jrst %L504

cmpdi_gt_orig:
	move 4,3
	move 5,4
	movei 6,0
	camle 1,4
	jrst %L509
	camn 1,4
	jrst %L510
%L508:
	move 1,6
	popj 17,
%L510:
	move 3,2
	tlc 3,400000
	move 4,5
	tlc 4,400000
	camg 3,4
	jrst %L508
%L509:
	movei 6,1
	jrst %L508

cmpdi_ge_orig:
	movei 6,0
	camle 3,1
	jrst %L512
	camn 3,1
	jrst %L514
%L513:
	movei 6,1
%L512:
	move 1,6
	popj 17,
%L514:
	move 3,4
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L513
	jrst %L512

cmpdi_ult_orig:
	move 6,3
	move 7,4
	movei 5,0
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	jrst %L517
	camn 6,1
	jrst %L518
%L516:
	move 1,5
	popj 17,
%L518:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L516
%L517:
	movei 5,1
	jrst %L516

cmpdi_ule_orig:
	move 6,3
	move 7,4
	movei 5,0
	move 3,1
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camle 3,4
	jrst %L520
	camn 1,6
	jrst %L522
%L521:
	movei 5,1
%L520:
	move 1,5
	popj 17,
%L522:
	move 3,2
	tlc 3,400000
	move 4,7
	tlc 4,400000
	camg 3,4
	jrst %L521
	jrst %L520

cmpdi_ugt_orig:
	move 6,3
	move 7,4
	movei 5,0
	move 3,1
	tlc 3,400000
	move 4,6
	tlc 4,400000
	camle 3,4
	jrst %L525
	camn 1,6
	jrst %L526
%L524:
	move 1,5
	popj 17,
%L526:
	move 3,2
	tlc 3,400000
	move 4,7
	tlc 4,400000
	camg 3,4
	jrst %L524
%L525:
	movei 5,1
	jrst %L524

cmpdi_uge_orig:
	move 6,3
	move 7,4
	movei 5,0
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	jrst %L528
	camn 6,1
	jrst %L530
%L529:
	movei 5,1
%L528:
	move 1,5
	popj 17,
%L530:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L529
	jrst %L528

	.bss
cmpdi_ga:
	.space	8
cmpdi_gb:
	.space	8
cmpdi_uga:
	.space	8
cmpdi_ugb:
	.space	8
cmpdi_buf:
	.space	128
cmpdi_ubuf:
	.space	128
cmpdi_gp:
	.space	16
cmpdi_ugp:
	.space	16
