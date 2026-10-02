
switch_dense:
	jumpl 1,%L9
	caile 1,5
	jrst %L9
	jrst @%L10(1)
%L10:
	.word	.3
	.word	.4
	.word	.5
	.word	.6
	.word	.7
	.word	.8
%L3:
	movei 1,12
%L1:
	popj 17,
%L9:
	seto 1,
	popj 17,
%L4:
	movei 1,13
	popj 17,
%L5:
	movei 1,14
	popj 17,
%L6:
	movei 1,15
	popj 17,
%L7:
	movei 1,16
	popj 17,
%L8:
	movei 1,17
	popj 17,

switch_dense_sint:
	jumpl 1,%L21
	caile 1,7
	jrst %L21
	jrst @%L22(1)
%L22:
	.word	.13
	.word	.14
	.word	.15
	.word	.16
	.word	.17
	.word	.18
	.word	.19
	.word	.20
%L13:
	movei 1,10
%L11:
	popj 17,
%L21:
	seto 1,
	popj 17,
%L14:
	movei 1,11
	popj 17,
%L15:
	movei 1,12
	popj 17,
%L16:
	movei 1,13
	popj 17,
%L17:
	movei 1,14
	popj 17,
%L18:
	movei 1,15
	popj 17,
%L19:
	movei 1,16
	popj 17,
%L20:
	movei 1,17
	popj 17,

switch_dense_offset:
	subi 1,12
	jumpl 1,%L31
	caile 1,5
	jrst %L31
	jrst @%L32(1)
%L32:
	.word	.25
	.word	.26
	.word	.27
	.word	.28
	.word	.29
	.word	.30
%L25:
	movei 1,144
%L23:
	popj 17,
%L31:
	seto 1,
	popj 17,
%L26:
	movei 1,145
	popj 17,
%L27:
	movei 1,146
	popj 17,
%L28:
	movei 1,147
	popj 17,
%L29:
	movei 1,150
	popj 17,
%L30:
	movei 1,151
	popj 17,

switch_dense_negative:
	addi 1,3
	jumpl 1,%L42
	caile 1,6
	jrst %L42
	jrst @%L43(1)
%L43:
	.word	.35
	.word	.36
	.word	.37
	.word	.38
	.word	.39
	.word	.40
	.word	.41
%L35:
	movei 1,36
%L33:
	popj 17,
%L42:
	seto 1,
	popj 17,
%L36:
	movei 1,37
	popj 17,
%L37:
	movei 1,40
	popj 17,
%L38:
	movei 1,41
	popj 17,
%L39:
	movei 1,42
	popj 17,
%L40:
	movei 1,43
	popj 17,
%L41:
	movei 1,44
	popj 17,

switch_dense_octal:
	subi 1,20
	jumpl 1,%L53
	caile 1,6
	jrst %L53
	jrst @%L54(1)
%L54:
	.word	.46
	.word	.47
	.word	.48
	.word	.49
	.word	.50
	.word	.51
	.word	.52
%L46:
	movei 1,1
%L44:
	popj 17,
%L53:
	movei 1,0
	popj 17,
%L47:
	movei 1,2
	popj 17,
%L48:
	movei 1,3
	popj 17,
%L49:
	movei 1,4
	popj 17,
%L50:
	movei 1,5
	popj 17,
%L51:
	movei 1,6
	popj 17,
%L52:
	movei 1,7
	popj 17,

switch_dense_large_low:
	subi 1,123400
	jumpl 1,%L63
	caile 1,5
	jrst %L63
	jrst @%L64(1)
%L64:
	.word	.57
	.word	.58
	.word	.59
	.word	.60
	.word	.61
	.word	.62
%L57:
	movei 1,1
%L55:
	popj 17,
%L63:
	seto 1,
	popj 17,
%L58:
	movei 1,2
	popj 17,
%L59:
	movei 1,3
	popj 17,
%L60:
	movei 1,4
	popj 17,
%L61:
	movei 1,5
	popj 17,
%L62:
	movei 1,6
	popj 17,

switch_dense_with_hole:
	jumpl 1,%L73
	caile 1,6
	jrst %L73
	jrst @%L74(1)
%L74:
	.word	.67
	.word	.68
	.word	.69
	.word	.73
	.word	.70
	.word	.71
	.word	.72
%L67:
	movei 1,12
%L65:
	popj 17,
%L68:
	movei 1,13
	popj 17,
%L69:
	movei 1,14
	popj 17,
%L73:
	seto 1,
	popj 17,
%L70:
	movei 1,16
	popj 17,
%L71:
	movei 1,17
	popj 17,
%L72:
	movei 1,20
	popj 17,

switch_dense_many:
	jumpl 1,%L89
	caile 1,13
	jrst %L89
	jrst @%L90(1)
%L90:
	.word	.77
	.word	.78
	.word	.79
	.word	.80
	.word	.81
	.word	.82
	.word	.83
	.word	.84
	.word	.85
	.word	.86
	.word	.87
	.word	.88
%L77:
	movei 1,144
%L75:
	popj 17,
%L89:
	seto 1,
	popj 17,
%L78:
	movei 1,145
	popj 17,
%L79:
	movei 1,146
	popj 17,
%L80:
	movei 1,147
	popj 17,
%L81:
	movei 1,150
	popj 17,
%L82:
	movei 1,151
	popj 17,
%L83:
	movei 1,152
	popj 17,
%L84:
	movei 1,153
	popj 17,
%L85:
	movei 1,154
	popj 17,
%L86:
	movei 1,155
	popj 17,
%L87:
	movei 1,156
	popj 17,
%L88:
	movei 1,157
	popj 17,

switch_sparse:
	movei 4,3
	jumpe 1,%L91
	jumple 1,%L101
	movei 4,4
	cain 1,24
	jrst %L91
	movei 4,5
	caie 1,400
%L98:
	movei 4,0
%L91:
	move 1,4
	popj 17,
%L101:
	movei 4,1
	camn 1,[-24]
	jrst %L91
	movei 4,2
	camn 1,[-1]
	jrst %L91
	jrst %L98

switch_sparse_large:
	movei 4,1
	cain 1,123456
	jrst %L102
	caile 1,123456
	jrst %L111
	seto 4,
	camn 1,[-123456]
	jrst %L102
	movei 4,0
	jumpe 1,%L102
%L109:
	hrroi 4,777776
%L102:
	move 1,4
	popj 17,
%L111:
	movei 4,3
	cain 1,777777
	jrst %L102
	movei 4,2
	came 1,[123456123]
	jrst %L109
	jrst %L102

switch_sparse_no_default:
	movei 4,0
	cain 1,12
	jrst %L115
	caile 1,12
	jrst %L119
	camn 1,[-12]
	jrst %L114
%L113:
	move 1,4
	popj 17,
%L114:
	movei 4,1
	jrst %L113
%L119:
	caie 1,1000
	jrst %L113
	movei 4,3
	jrst %L113
%L115:
	movei 4,2
	jrst %L113

switch_one_case:
	movei 4,1
	jumpe 1,%L120
	seto 4,
%L120:
	move 1,4
	popj 17,

switch_two_cases:
	movei 4,12
	jumpe 1,%L125
	movei 4,13
	caie 1,1
	seto 4,
%L125:
	move 1,4
	popj 17,

switch_three_cases:
	movei 4,2
	jumpe 1,%L131
	jumple 1,%L139
	movei 4,3
	caie 1,1
%L136:
	movei 4,0
%L131:
	move 1,4
	popj 17,
%L139:
	movei 4,1
	camn 1,[-1]
	jrst %L131
	jrst %L136

switch_grouped:
	jumpl 1,%L148
	caile 1,5
	jrst %L148
	jrst @%L149(1)
%L149:
	.word	.143
	.word	.143
	.word	.145
	.word	.145
	.word	.147
	.word	.147
%L143:
	movei 1,12
%L140:
	popj 17,
%L148:
	seto 1,
	popj 17,
%L145:
	movei 1,24
	popj 17,
%L147:
	movei 1,36
	popj 17,

switch_grouped_negative:
	addi 1,4
	jumpl 1,%L158
	caile 1,5
	jrst %L158
	jrst @%L159(1)
%L159:
	.word	.153
	.word	.153
	.word	.155
	.word	.155
	.word	.157
	.word	.157
%L153:
	movei 1,1
%L150:
	popj 17,
%L158:
	movei 1,0
	popj 17,
%L155:
	movei 1,2
	popj 17,
%L157:
	movei 1,3
	popj 17,

switch_fallthrough:
	movei 4,0
	jumpl 1,%L166
	caile 1,3
	jrst %L166
	jrst @%L167(1)
%L167:
	.word	.162
	.word	.163
	.word	.165
	.word	.165
%L162:
	movei 4,1
%L163:
	addi 4,2
%L161:
	move 1,4
	popj 17,
%L166:
	seto 4,
	jrst %L161
%L165:
	movei 4,4
	jrst %L161

switch_fallthrough_dense:
	movei 4,0
	jumpl 1,%L175
	caile 1,4
	jrst %L175
	jrst @%L176(1)
%L176:
	.word	.170
	.word	.171
	.word	.172
	.word	.173
	.word	.174
%L170:
	movei 4,1
%L171:
	addi 4,2
%L172:
	addi 4,3
%L169:
	move 1,4
	popj 17,
%L175:
	seto 4,
	jrst %L169
%L173:
	movei 4,4
%L174:
	addi 4,5
	jrst %L169

switch_assign_result:
	jumpl 1,%L184
	caile 1,4
	jrst %L184
	jrst @%L185(1)
%L185:
	.word	.179
	.word	.180
	.word	.181
	.word	.182
	.word	.183
%L179:
	addi 2,12
%L178:
	move 1,2
	popj 17,
%L184:
	seto 2,
	jrst %L178
%L180:
	addi 2,13
	jrst %L178
%L181:
	addi 2,14
	jrst %L178
%L182:
	addi 2,15
	jrst %L178
%L183:
	addi 2,16
	jrst %L178

switch_assign_no_default:
	jumpl 1,%L187
	caile 1,3
	jrst %L187
	jrst @%L192(1)
%L192:
	.word	.188
	.word	.189
	.word	.190
	.word	.191
%L188:
	addi 2,1
%L187:
	move 1,2
	popj 17,
%L189:
	addi 2,2
	jrst %L187
%L190:
	addi 2,3
	jrst %L187
%L191:
	addi 2,4
	jrst %L187

switch_side_effects:
	jumpl 1,%L200
	caile 1,3
	jrst %L200
	jrst @%L201(1)
%L201:
	.word	.196
	.word	.197
	.word	.198
	.word	.199
%L196:
	aos 4,(2)
%L203:
	move 1,4
%L194:
	popj 17,
%L200:
	setom (2)
	seto 1,
	popj 17,
%L197:
	move 4,(2)
	addi 4,2
%L202:
	movem 4,(2)
	jrst %L203
%L198:
	move 4,(2)
	addi 4,3
	jrst %L202
%L199:
	move 4,(2)
	addi 4,4
	jrst %L202

switch_side_effects_join:
	jumpl 1,%L210
	caile 1,3
	jrst %L210
	jrst @%L211(1)
%L211:
	.word	.206
	.word	.207
	.word	.208
	.word	.209
%L206:
	aos (2)
	movei 1,12
%L205:
	add 1,(2)
	popj 17,
%L210:
	setom (2)
	seto 1,
	jrst %L205
%L207:
	movei 6,2
	addm 6,(2)
	movei 1,13
	jrst %L205
%L208:
	movei 6,3
	addm 6,(2)
	movei 1,14
	jrst %L205
%L209:
	movei 6,4
	addm 6,(2)
	movei 1,15
	jrst %L205

switch_with_call:
	push 17,10
	jumpl 1,%L218
	caile 1,3
	jrst %L218
	jrst @%L219(1)
%L219:
	.word	.214
	.word	.215
	.word	.216
	.word	.217
%L214:
	movei 10,12
%L213:
	move 1,10
	pushj 17,sink_int
	move 1,10
	pop 17,10
	popj 17,
%L218:
	seto 10,
	jrst %L213
%L215:
	movei 10,13
	jrst %L213
%L216:
	movei 10,14
	jrst %L213
%L217:
	movei 10,15
	jrst %L213

switch_call_in_cases:
	jumpl 1,%L226
	caile 1,3
	jrst %L226
	jrst @%L227(1)
%L227:
	.word	.222
	.word	.223
	.word	.224
	.word	.225
%L222:
	movei 1,0
	pushj 17,sink_int
	movei 1,12
%L220:
	popj 17,
%L226:
	seto 1,
	pushj 17,sink_int
	seto 1,
	popj 17,
%L223:
	movei 1,1
	pushj 17,sink_int
	movei 1,13
	popj 17,
%L224:
	movei 1,2
	pushj 17,sink_int
	movei 1,14
	popj 17,
%L225:
	movei 1,3
	pushj 17,sink_int
	movei 1,15
	popj 17,

switch_mem_input:
	skipge 1,(1)
	jrst %L234
	caile 1,3
	jrst %L234
	jrst @%L235(1)
%L235:
	.word	.230
	.word	.231
	.word	.232
	.word	.233
%L230:
	movei 1,12
%L228:
	popj 17,
%L234:
	seto 1,
	popj 17,
%L231:
	movei 1,13
	popj 17,
%L232:
	movei 1,14
	popj 17,
%L233:
	movei 1,15
	popj 17,

switch_volatile_input:
	move 1,(1)
	jumpl 1,%L242
	caile 1,3
	jrst %L242
	jrst @%L243(1)
%L243:
	.word	.238
	.word	.239
	.word	.240
	.word	.241
%L238:
	movei 1,12
%L236:
	popj 17,
%L242:
	seto 1,
	popj 17,
%L239:
	movei 1,13
	popj 17,
%L240:
	movei 1,14
	popj 17,
%L241:
	movei 1,15
	popj 17,

switch_expr_input:
	add 1,2
	jumpl 1,%L251
	caile 1,4
	jrst %L251
	jrst @%L252(1)
%L252:
	.word	.246
	.word	.247
	.word	.248
	.word	.249
	.word	.250
%L246:
	movei 1,1
%L244:
	popj 17,
%L251:
	seto 1,
	popj 17,
%L247:
	movei 1,2
	popj 17,
%L248:
	movei 1,3
	popj 17,
%L249:
	movei 1,4
	popj 17,
%L250:
	movei 1,5
	popj 17,

switch_masked_input:
	andi 1,7
	jumpl 1,%L262
	caile 1,6
	jrst %L262
	jrst @%L263(1)
%L263:
	.word	.255
	.word	.256
	.word	.257
	.word	.258
	.word	.259
	.word	.260
	.word	.261
%L255:
	movei 1,10
%L253:
	popj 17,
%L262:
	movei 1,17
	popj 17,
%L256:
	movei 1,11
	popj 17,
%L257:
	movei 1,12
	popj 17,
%L258:
	movei 1,13
	popj 17,
%L259:
	movei 1,14
	popj 17,
%L260:
	movei 1,15
	popj 17,
%L261:
	movei 1,16
	popj 17,

switch_shifted_input:
	ldb 1,[POINT 3,1,34]
	jumpl 1,%L274
	caile 1,7
	jrst %L274
	jrst @%L275(1)
%L275:
	.word	.266
	.word	.267
	.word	.268
	.word	.269
	.word	.270
	.word	.271
	.word	.272
	.word	.273
%L266:
	movei 1,0
%L264:
	popj 17,
%L274:
	seto 1,
	popj 17,
%L267:
	movei 1,12
	popj 17,
%L268:
	movei 1,24
	popj 17,
%L269:
	movei 1,36
	popj 17,
%L270:
	movei 1,50
	popj 17,
%L271:
	movei 1,62
	popj 17,
%L272:
	movei 1,74
	popj 17,
%L273:
	movei 1,106
	popj 17,

switch_char_input:
	andi 1,777	; zero_extendqisi2
	jumpl 1,%L282
	caile 1,3
	jrst %L282
	jrst @%L283(1)
%L283:
	.word	.278
	.word	.279
	.word	.280
	.word	.281
%L278:
	movei 1,12
%L276:
	popj 17,
%L282:
	seto 1,
	popj 17,
%L279:
	movei 1,13
	popj 17,
%L280:
	movei 1,14
	popj 17,
%L281:
	movei 1,15
	popj 17,

switch_qint_input:
	lsh 1,33
	ash 1,-33
	addi 1,2
	jumpl 1,%L291
	caile 1,4
	jrst %L291
	jrst @%L292(1)
%L292:
	.word	.286
	.word	.287
	.word	.288
	.word	.289
	.word	.290
%L286:
	movei 1,1
%L284:
	popj 17,
%L291:
	movei 1,0
	popj 17,
%L287:
	movei 1,2
	popj 17,
%L288:
	movei 1,3
	popj 17,
%L289:
	movei 1,4
	popj 17,
%L290:
	movei 1,5
	popj 17,

switch_uqint_input:
	andi 1,777	; zero_extendqisi2
	jumpl 1,%L300
	caile 1,4
	jrst %L300
	jrst @%L301(1)
%L301:
	.word	.295
	.word	.296
	.word	.297
	.word	.298
	.word	.299
%L295:
	movei 1,12
%L293:
	popj 17,
%L300:
	seto 1,
	popj 17,
%L296:
	movei 1,13
	popj 17,
%L297:
	movei 1,14
	popj 17,
%L298:
	movei 1,15
	popj 17,
%L299:
	movei 1,16
	popj 17,

switch_hint_input:
	hrre 1,1
	addi 1,2
	jumpl 1,%L309
	caile 1,4
	jrst %L309
	jrst @%L310(1)
%L310:
	.word	.304
	.word	.305
	.word	.306
	.word	.307
	.word	.308
%L304:
	movei 1,1
%L302:
	popj 17,
%L309:
	movei 1,0
	popj 17,
%L305:
	movei 1,2
	popj 17,
%L306:
	movei 1,3
	popj 17,
%L307:
	movei 1,4
	popj 17,
%L308:
	movei 1,5
	popj 17,

switch_unsigned_input:
	jumpl 1,%L319
	caile 1,5
	jrst %L319
	jrst @%L320(1)
%L320:
	.word	.313
	.word	.314
	.word	.315
	.word	.316
	.word	.317
	.word	.318
%L313:
	movei 1,12
%L311:
	popj 17,
%L319:
	movei 1,0
	popj 17,
%L314:
	movei 1,13
	popj 17,
%L315:
	movei 1,14
	popj 17,
%L316:
	movei 1,15
	popj 17,
%L317:
	movei 1,16
	popj 17,
%L318:
	movei 1,17
	popj 17,

switch_enum_input:
	jumpl 1,%L329
	caile 1,5
	jrst %L329
	jrst @%L330(1)
%L330:
	.word	.323
	.word	.324
	.word	.325
	.word	.326
	.word	.327
	.word	.328
%L323:
	movei 1,1
%L321:
	popj 17,
%L329:
	movei 1,0
	popj 17,
%L324:
	movei 1,2
	popj 17,
%L325:
	movei 1,3
	popj 17,
%L326:
	movei 1,4
	popj 17,
%L327:
	movei 1,5
	popj 17,
%L328:
	movei 1,6
	popj 17,

switch_nested:
	cain 1,1
	jrst %L341
	caig 1,1
	jrst %L355
	movei 4,24
	caie 1,2
%L350:
	hrroi 4,777776
%L331:
	move 1,4
	popj 17,
%L355:
	jumpn 1,%L350
	movei 4,1
	cain 2,1
	jrst %L331
	movei 4,0
	caig 2,1
	jrst %L353
	movei 4,2
%L354:
	cain 2,2
	jrst %L331
%L346:
	seto 4,
	jrst %L331
%L353:
	jumpe 2,%L331
	jrst %L346
%L341:
	movei 4,13
	cain 2,1
	jrst %L331
	movei 4,14
	caile 2,1
	jrst %L354
	movei 4,12
	jrst %L353

switch_nested_dense_sparse:
	jumpl 1,%L362
	caile 1,3
	jrst %L362
	jrst @%L363(1)
%L363:
	.word	.358
	.word	.359
	.word	.360
	.word	.361
%L358:
	move 1,2
	jrst switch_dense
%L362:
	seto 1,
	popj 17,
%L359:
	move 1,2
	jrst switch_sparse
%L360:
	move 1,2
	jrst switch_fallthrough
%L361:
	move 1,2
	jrst switch_dense_negative

switch_loop_dispatch:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
%L378:
	move 4,3
	andi 4,17
	add 4,6
	move 4,(4)
	andi 4,7
	jumpl 4,%L375
	caile 4,4
	jrst %L375
	jrst @%L376(4)
%L376:
	.word	.370
	.word	.371
	.word	.372
	.word	.373
	.word	.374
%L370:
	addi 1,1
%L367:
	addi 3,1
	camge 3,2
	jrst %L378
	popj 17,
%L375:
	soja 1,%L367
%L371:
	addi 1,2
	jrst %L367
%L372:
	addi 1,3
	jrst %L367
%L373:
	addi 1,4
	jrst %L367
%L374:
	addi 1,5
	jrst %L367

switch_loop_with_break:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
%L394:
	move 4,3
	andi 4,17
	add 4,6
	skipge 4,(4)
	jrst %L391
	caile 4,3
	jrst %L391
	jrst @%L392(4)
%L392:
	.word	.381
	.word	.388
	.word	.389
	.word	.390
%L388:
	addi 1,1
%L384:
	addi 3,1
	camge 3,2
	jrst %L394
%L381:
	popj 17,
%L391:
	soja 1,%L384
%L389:
	addi 1,2
	jrst %L384
%L390:
	addi 1,3
	jrst %L384

switch_loop_with_continue:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
%L410:
	move 4,3
	andi 4,17
	add 4,6
	skipge 4,(4)
	jrst %L407
	caile 4,3
	jrst %L407
	jrst @%L408(4)
%L408:
	.word	.400
	.word	.404
	.word	.405
	.word	.406
%L404:
	addi 1,1
%L400:
	addi 3,1
	camge 3,2
	jrst %L410
	popj 17,
%L407:
	soja 1,%L400
%L405:
	addi 1,2
	jrst %L400
%L406:
	addi 1,3
	jrst %L400

switch_store_result:
	jumpl 1,%L420
	caile 1,4
	jrst %L420
	jrst @%L421(1)
%L421:
	.word	.415
	.word	.416
	.word	.417
	.word	.418
	.word	.419
%L415:
	movei 6,12
%L422:
	movem 6,(2)
%L414:
	move 1,(2)
	popj 17,
%L420:
	setom (2)
	jrst %L414
%L416:
	movei 6,13
	jrst %L422
%L417:
	movei 6,14
	jrst %L422
%L418:
	movei 6,15
	jrst %L422
%L419:
	movei 6,16
	jrst %L422

	.bss
g%0:
	.space	4

switch_store_global:
	jumpl 1,%L429
	caile 1,3
	jrst %L429
	jrst @%L430(1)
%L430:
	.word	.425
	.word	.426
	.word	.427
	.word	.428
%L425:
	movei 6,1
%L431:
	movem 6,g%0
%L424:
	move 1,g%0
	popj 17,
%L429:
	setom g%0
	jrst %L424
%L426:
	movei 6,2
	jrst %L431
%L427:
	movei 6,3
	jrst %L431
%L428:
	movei 6,4
	jrst %L431

switch_return_address_like:
	jumpl 1,%L439
	caile 1,4
	jrst %L439
	jrst @%L440(1)
%L440:
	.word	.434
	.word	.435
	.word	.436
	.word	.437
	.word	.438
%L434:
	movei 1,400
%L432:
	popj 17,
%L439:
	movei 1,0
	popj 17,
%L435:
	movei 1,401
	popj 17,
%L436:
	movei 1,402
	popj 17,
%L437:
	movei 1,403
	popj 17,
%L438:
	movei 1,404
	popj 17,

switch_return_large_values:
	jumpl 1,%L447
	caile 1,3
	jrst %L447
	jrst @%L448(1)
%L448:
	.word	.443
	.word	.447
	.word	.445
	.word	.446
%L443:
	move 1,[123456123456]
%L441:
	popj 17,
%L447:
	seto 1,
	popj 17,
%L445:
	movsi 1,400000
	popj 17,
%L446:
	movei 1,777777
	popj 17,

switch_default_middle_source_order:
	jumpl 1,%L452
	caile 1,3
	jrst %L452
	jrst @%L456(1)
%L456:
	.word	.453
	.word	.454
	.word	.451
	.word	.455
%L451:
	movei 1,24
%L449:
	popj 17,
%L452:
	seto 1,
	popj 17,
%L453:
	movei 1,0
	popj 17,
%L454:
	movei 1,12
	popj 17,
%L455:
	movei 1,36
	popj 17,

switch_empty_default:
	movei 4,0
	cain 1,1
	jrst %L460
	caig 1,1
	jrst %L465
	cain 1,2
	jrst %L461
%L458:
	move 1,4
	popj 17,
%L461:
	movei 4,3
	jrst %L458
%L465:
	jumpn 1,%L458
	movei 4,1
	jrst %L458
%L460:
	movei 4,2
	jrst %L458

switch_no_cases:
	seto 1,
	popj 17,

use_switches:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,switch_dense
	move 10,1
	move 1,11
	pushj 17,switch_sparse
	add 10,1
	move 1,11
	pushj 17,switch_fallthrough
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_more_switches:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	pushj 17,switch_dense_offset
	move 10,1
	move 1,12
	pushj 17,switch_dense_negative
	add 10,1
	move 1,11
	pushj 17,switch_grouped
	add 10,1
	move 1,11
	move 2,12
	pushj 17,switch_nested_dense_sparse
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.comm	x, 4
