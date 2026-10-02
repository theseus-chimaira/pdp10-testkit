
addi_1_reg:
	addi 1,1
	popj 17,

addi_1_mem:
	move 1,(1)
	addi 1,1
	popj 17,

addi_1_glob:
	move 4,1
	aos 1,gi
	add 1,4
	popj 17,

addi_1_vol:
	move 4,vgi
	addi 4,1
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

addi_rha_reg:
	addi 1,123456
	popj 17,

addi_rha_mem:
	move 1,(1)
	addi 1,123456
	popj 17,

addi_rha_glob:
	move 4,1
	move 1,gi
	addi 1,123456
	movem 1,gi
	add 1,4
	popj 17,

addi_rha_vol:
	move 4,vgi
	addi 4,123456
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

addi_rhmax_reg:
	addi 1,777777
	popj 17,

addi_rhmax_mem:
	move 1,(1)
	addi 1,777777
	popj 17,

addi_rhmax_glob:
	move 4,1
	move 1,gi
	addi 1,777777
	movem 1,gi
	add 1,4
	popj 17,

addi_rhmax_vol:
	move 4,vgi
	addi 4,777777
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

subi_1_reg:
	subi 1,1
	popj 17,

subi_1_mem:
	move 1,(1)
	subi 1,1
	popj 17,

subi_1_glob:
	move 4,1
	sos 1,gi
	add 1,4
	popj 17,

subi_1_vol:
	move 4,vgi
	subi 4,1
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

subi_rha_reg:
	subi 1,123456
	popj 17,

subi_rha_mem:
	move 1,(1)
	subi 1,123456
	popj 17,

subi_rha_glob:
	move 4,1
	move 1,gi
	subi 1,123456
	movem 1,gi
	add 1,4
	popj 17,

subi_rha_vol:
	move 4,vgi
	subi 4,123456
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

subi_rhmax_reg:
	subi 1,777777
	popj 17,

subi_rhmax_mem:
	move 1,(1)
	subi 1,777777
	popj 17,

subi_rhmax_glob:
	move 4,1
	move 1,gi
	subi 1,777777
	movem 1,gi
	add 1,4
	popj 17,

subi_rhmax_vol:
	move 4,vgi
	subi 4,777777
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

imuli_2_reg:
	lsh 1,1
	popj 17,

imuli_2_mem:
	move 1,(1)
	lsh 1,1
	popj 17,

imuli_2_glob:
	move 4,gi
	lsh 4,1
	movem 4,gi
	add 1,4
	popj 17,

imuli_2_vol:
	move 4,vgi
	lsh 4,1
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

imuli_7_reg:
	move 4,1
	lsh 1,3
	sub 1,4
	popj 17,

imuli_7_mem:
	move 4,(1)
	move 1,4
	lsh 1,3
	sub 1,4
	popj 17,

imuli_7_glob:
	move 3,gi
	move 4,3
	lsh 4,3
	sub 4,3
	movem 4,gi
	add 1,4
	popj 17,

imuli_7_vol:
	move 2,1
	move 3,vgi
	move 4,3
	lsh 4,3
	sub 4,3
	movem 4,vgi
	move 1,vgi
	add 1,2
	popj 17,

imuli_rha_reg:
	imuli 1,123456
	popj 17,

imuli_rha_mem:
	move 1,(1)
	imuli 1,123456
	popj 17,

imuli_rha_glob:
	move 4,1
	move 1,gi
	imuli 1,123456
	movem 1,gi
	add 1,4
	popj 17,

imuli_rha_vol:
	move 4,vgi
	imuli 4,123456
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

iori_1_reg:
	iori 1,1
	popj 17,

iori_1_mem:
	move 1,(1)
	iori 1,1
	popj 17,

iori_1_glob:
	move 4,1
	move 1,gi
	iori 1,1
	movem 1,gi
	add 1,4
	popj 17,

iori_1_vol:
	move 4,vgi
	iori 4,1
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

iori_rha_reg:
	iori 1,123456
	popj 17,

iori_rha_mem:
	move 1,(1)
	iori 1,123456
	popj 17,

iori_rha_glob:
	move 4,1
	move 1,gi
	iori 1,123456
	movem 1,gi
	add 1,4
	popj 17,

iori_rha_vol:
	move 4,vgi
	iori 4,123456
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

andi_1_reg:
	andi 1,1
	popj 17,

andi_1_mem:
	move 1,(1)
	andi 1,1
	popj 17,

andi_1_glob:
	move 4,1
	move 1,gi
	andi 1,1
	movem 1,gi
	add 1,4
	popj 17,

andi_1_vol:
	move 4,vgi
	andi 4,1
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

andi_rha_reg:
	andi 1,123456
	popj 17,

andi_rha_mem:
	move 1,(1)
	andi 1,123456
	popj 17,

andi_rha_glob:
	move 4,1
	move 1,gi
	andi 1,123456
	movem 1,gi
	add 1,4
	popj 17,

andi_rha_vol:
	move 4,vgi
	andi 4,123456
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

andi_rhmask_reg:
	hrrz 1,1
	popj 17,

andi_rhmask_mem:
	hrrz 1,(1)
	popj 17,

andi_rhmask_glob:
	move 4,1
	hrrzs 1,gi
	add 1,4
	popj 17,

andi_rhmask_vol:
	move 4,vgi
	hrrz 4,4
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

xori_1_reg:
	xori 1,1
	popj 17,

xori_1_mem:
	move 1,(1)
	xori 1,1
	popj 17,

xori_1_glob:
	move 4,1
	move 1,gi
	xori 1,1
	movem 1,gi
	add 1,4
	popj 17,

xori_1_vol:
	move 4,vgi
	xori 4,1
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

xori_rha_reg:
	xori 1,123456
	popj 17,

xori_rha_mem:
	move 1,(1)
	xori 1,123456
	popj 17,

xori_rha_glob:
	move 4,1
	move 1,gi
	xori 1,123456
	movem 1,gi
	add 1,4
	popj 17,

xori_rha_vol:
	move 4,vgi
	xori 4,123456
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

xori_rhmask_reg:
	xori 1,777777
	popj 17,

xori_rhmask_mem:
	move 1,(1)
	xori 1,777777
	popj 17,

xori_rhmask_glob:
	move 4,1
	move 1,gi
	xori 1,777777
	movem 1,gi
	add 1,4
	popj 17,

xori_rhmask_vol:
	move 4,vgi
	xori 4,777777
	movem 4,vgi
	move 4,vgi
	add 4,1
	move 1,4
	popj 17,

eqvi_rha_reg:
	eqvi 1,123456
	popj 17,

eqvi_rha_mem:
	move 1,(1)
	eqvi 1,123456
	popj 17,

eqvi_rha_glob:
	move 1,gi
	eqvi 1,123456
	movem 1,gi
	popj 17,

eqvi_rha_vol:
	move 4,vgi
	eqvi 4,123456
	movem 4,vgi
	move 1,vgi
	popj 17,

eqvi_rhmask_reg:
	tlc 1,777777
	popj 17,

eqvi_rhmask_mem:
	move 1,(1)
	tlc 1,777777
	popj 17,

eqvi_rhmask_glob:
	move 1,gi
	tlc 1,777777
	movem 1,gi
	popj 17,

eqvi_rhmask_vol:
	move 4,vgi
	tlc 4,777777
	movem 4,vgi
	move 1,vgi
	popj 17,

orcmi_rha_reg:
	orcmi 1,123456
	popj 17,

orcmi_rha_mem:
	move 1,(1)
	orcmi 1,123456
	popj 17,

orcmi_rha_glob:
	move 1,gi
	orcmi 1,123456
	movem 1,gi
	popj 17,

orcmi_rha_vol:
	move 4,vgi
	orcmi 4,123456
	movem 4,vgi
	move 1,vgi
	popj 17,

orcmi_rhmask_reg:
	hrro 1,1
	popj 17,

orcmi_rhmask_mem:
	hrro 1,(1)
	popj 17,

orcmi_rhmask_glob:
	hrros 1,gi
	popj 17,

orcmi_rhmask_vol:
	move 4,vgi
	hrro 4,4
	movem 4,vgi
	move 1,vgi
	popj 17,

orcbi_rha_reg:
	orcbi 1,123456
	popj 17,

orcbi_rha_mem:
	move 1,(1)
	orcbi 1,123456
	popj 17,

orcbi_rha_glob:
	hrroi 1,654321
	orcm 1,gi
	movem 1,gi
	popj 17,

orcbi_rha_vol:
	move 4,vgi
	orcbi 4,123456
	movem 4,vgi
	move 1,vgi
	popj 17,

orcbi_rhmask_reg:
	orcbi 1,777777
	popj 17,

orcbi_rhmask_mem:
	move 1,(1)
	orcbi 1,777777
	popj 17,

orcbi_rhmask_glob:
	movsi 1,777777
	orcm 1,gi
	movem 1,gi
	popj 17,

orcbi_rhmask_vol:
	move 4,vgi
	orcbi 4,777777
	movem 4,vgi
	move 1,vgi
	popj 17,

andcmi_rha_reg:
	andcmi 1,123456
	popj 17,

andcmi_rha_mem:
	move 1,(1)
	andcmi 1,123456
	popj 17,

andcmi_rha_glob:
	move 1,gi
	andcmi 1,123456
	movem 1,gi
	popj 17,

andcmi_rha_vol:
	move 4,vgi
	andcmi 4,123456
	movem 4,vgi
	move 1,vgi
	popj 17,

andcmi_mask_reg:
	hllz 1,1
	popj 17,

andcmi_mask_mem:
	hllz 1,(1)
	popj 17,

andcmi_mask_glob:
	hllzs 1,gi
	popj 17,

andcmi_mask_vol:
	move 4,vgi
	hllz 4,4
	movem 4,vgi
	move 1,vgi
	popj 17,

andcbi_rha_reg:
	andcbi 1,123456
	popj 17,

andcbi_rha_mem:
	move 1,(1)
	andcbi 1,123456
	popj 17,

andcbi_rha_glob:
	hrroi 1,654321
	andcm 1,gi
	movem 1,gi
	popj 17,

andcbi_rha_vol:
	move 4,vgi
	andcbi 4,123456
	movem 4,vgi
	move 1,vgi
	popj 17,

andcbi_mask_reg:
	andcbi 1,777777
	popj 17,

andcbi_mask_mem:
	move 1,(1)
	andcbi 1,777777
	popj 17,

andcbi_mask_glob:
	movsi 1,777777
	andcm 1,gi
	movem 1,gi
	popj 17,

andcbi_mask_vol:
	move 4,vgi
	andcbi 4,777777
	movem 4,vgi
	move 1,vgi
	popj 17,

tlo_one_reg:
	tlo 1,1
	popj 17,

tlo_one_mem:
	move 1,(1)
	tlo 1,1
	popj 17,

tlo_one_glob:
	tlo 1,1
	movem 1,gi
	popj 17,

tlo_one_vol:
	tlo 1,1
	movem 1,vgi
	move 1,vgi
	popj 17,

tlo_a_reg:
	tlo 1,123456
	popj 17,

tlo_a_mem:
	move 1,(1)
	tlo 1,123456
	popj 17,

tlo_a_glob:
	tlo 1,123456
	movem 1,gi
	popj 17,

tlo_a_vol:
	tlo 1,123456
	movem 1,vgi
	move 1,vgi
	popj 17,

tlc_one_reg:
	tlc 1,1
	popj 17,

tlc_one_mem:
	move 1,(1)
	tlc 1,1
	popj 17,

tlc_one_glob:
	tlc 1,1
	movem 1,gi
	popj 17,

tlc_one_vol:
	tlc 1,1
	movem 1,vgi
	move 1,vgi
	popj 17,

tlc_a_reg:
	tlc 1,123456
	popj 17,

tlc_a_mem:
	move 1,(1)
	tlc 1,123456
	popj 17,

tlc_a_glob:
	tlc 1,123456
	movem 1,gi
	popj 17,

tlc_a_vol:
	tlc 1,123456
	movem 1,vgi
	move 1,vgi
	popj 17,

tlz_one_reg:
	tlz 1,1
	popj 17,

tlz_one_mem:
	move 1,(1)
	tlz 1,1
	popj 17,

tlz_one_glob:
	tlz 1,1
	movem 1,gi
	popj 17,

tlz_one_vol:
	tlz 1,1
	movem 1,vgi
	move 1,vgi
	popj 17,

tlz_a_reg:
	tlz 1,123456
	popj 17,

tlz_a_mem:
	move 1,(1)
	tlz 1,123456
	popj 17,

tlz_a_glob:
	tlz 1,123456
	movem 1,gi
	popj 17,

tlz_a_vol:
	tlz 1,123456
	movem 1,vgi
	move 1,vgi
	popj 17,

hllz_mask_reg:
	hllz 1,1
	popj 17,

hllz_mask_mem:
	hllz 1,(1)
	popj 17,

hllz_mask_glob:
	hllz 1,1
	movem 1,gi
	popj 17,

hllz_mask_vol:
	hllz 1,1
	movem 1,vgi
	move 1,vgi
	popj 17,

hrrz_mask_reg:
	hrrz 1,1
	popj 17,

hrrz_mask_mem:
	hrrz 1,(1)
	popj 17,

hrrz_mask_glob:
	hrrz 1,1
	movem 1,gi
	popj 17,

hrrz_mask_vol:
	hrrz 1,1
	movem 1,vgi
	move 1,vgi
	popj 17,

hrlo_like_reg:
	hllo 1,1
	popj 17,

hrlo_like_mem:
	hllo 1,(1)
	popj 17,

hrlo_like_glob:
	hllo 1,1
	movem 1,gi
	popj 17,

hrlo_like_vol:
	hllo 1,1
	movem 1,vgi
	move 1,vgi
	popj 17,

hrro_like_reg:
	hrro 1,1
	popj 17,

hrro_like_mem:
	hrro 1,(1)
	popj 17,

hrro_like_glob:
	hrro 1,1
	movem 1,gi
	popj 17,

hrro_like_vol:
	hrro 1,1
	movem 1,vgi
	move 1,vgi
	popj 17,

sign_toggle_reg:
	tlc 1,400000
	popj 17,

sign_toggle_mem:
	move 1,(1)
	tlc 1,400000
	popj 17,

sign_toggle_glob:
	tlc 1,400000
	movem 1,gi
	popj 17,

sign_toggle_vol:
	tlc 1,400000
	movem 1,vgi
	move 1,vgi
	popj 17,

sign_set_reg:
	tlo 1,400000
	popj 17,

sign_set_mem:
	move 1,(1)
	tlo 1,400000
	popj 17,

sign_set_glob:
	tlo 1,400000
	movem 1,gi
	popj 17,

sign_set_vol:
	tlo 1,400000
	movem 1,vgi
	move 1,vgi
	popj 17,

sign_clear_reg:
	tlz 1,400000
	popj 17,

sign_clear_mem:
	move 1,(1)
	tlz 1,400000
	popj 17,

sign_clear_glob:
	tlz 1,400000
	movem 1,gi
	popj 17,

sign_clear_vol:
	tlz 1,400000
	movem 1,vgi
	move 1,vgi
	popj 17,

movei_zero:
	movei 1,0
	popj 17,

movei_one:
	movei 1,1
	popj 17,

movei_rha:
	movei 1,123456
	popj 17,

movei_rhmax:
	movei 1,777777
	popj 17,

movni_one:
	seto 1,
	popj 17,

movni_rha:
	hrroi 1,654322
	popj 17,

movni_rhmax:
	hrroi 1,1
	popj 17,

movsi_one:
	movsi 1,1
	popj 17,

movsi_a:
	movsi 1,123456
	popj 17,

hrroi_rha:
	hrroi 1,654321
	popj 17,

hrloi_a:
	hrloi 1,123456
	popj 17,

seto_const:
	seto 1,
	popj 17,

allones_const:
	seto 1,
	popj 17,

store_movei:
	movei 6,123456
	movem 6,(1)
	popj 17,

store_movni:
	hrroi 6,654322
	movem 6,(1)
	popj 17,

store_movsi:
	movsi 6,123456
	movem 6,(1)
	popj 17,

store_seto:
	setom (1)
	popj 17,

store_zero:
	setzm (1)
	popj 17,

caie_zero_ret:
	skipe 1
	movei 1,1
	popj 17,

caie_zero_if:
	move 4,1
	addi 4,1
	jumpn 1,%L180
	seto 4,
%L180:
	move 1,4
	popj 17,

caie_zero_mem:
	skipn 4,(1)
	jrst %L183
	addi 4,1
	movem 4,(1)
%L184:
	move 1,(1)
	popj 17,
%L183:
	setom (1)
	jrst %L184

cain_zero_ret:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

cain_zero_if:
	movei 4,1
	jumpe 1,%L186
	move 4,1
	subi 4,1
%L186:
	move 1,4
	popj 17,

cain_zero_mem:
	skipe 4,(1)
	jrst %L189
	movei 6,1
	movem 6,(1)
%L190:
	move 1,(1)
	popj 17,
%L189:
	subi 4,1
	movem 4,(1)
	jrst %L190

caie_one_ret:
	movei 6,1
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

caie_one_if:
	move 4,1
	addi 4,1
	cain 1,1
	jrst %L194
%L192:
	move 1,4
	popj 17,
%L194:
	movei 4,0
	jrst %L192

caie_one_mem:
	move 4,(1)
	cain 4,1
	jrst %L196
	addi 4,1
	movem 4,(1)
%L197:
	move 1,(1)
	popj 17,
%L196:
	setzm (1)
	jrst %L197

cain_one_ret:
	movei 6,1
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cain_one_if:
	movei 4,2
	cain 1,1
	jrst %L199
	move 4,1
	subi 4,1
%L199:
	move 1,4
	popj 17,

cain_one_mem:
	move 4,(1)
	cain 4,1
	jrst %L204
	subi 4,1
	movem 4,(1)
%L203:
	move 1,(1)
	popj 17,
%L204:
	movei 6,2
	movem 6,(1)
	jrst %L203

cail_rha_ret:
	movei 6,123455
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cail_rha_if:
	move 4,1
	addi 4,1
	caile 1,123455
	subi 4,2
	move 1,4
	popj 17,

cail_rha_mem:
	move 4,(1)
	caile 4,123455
	jrst %L209
	addi 4,1
%L211:
	movem 4,(1)
	move 1,(1)
	popj 17,
%L209:
	soja 4,%L211

caile_rha_ret:
	movei 6,123456
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

caile_rha_if:
	move 4,1
	addi 4,1
	caile 1,123456
	subi 4,2
	move 1,4
	popj 17,

caile_rha_mem:
	move 4,(1)
	caile 4,123456
	jrst %L216
	addi 4,1
%L218:
	movem 4,(1)
	move 1,(1)
	popj 17,
%L216:
	soja 4,%L218

caige_rha_ret:
	movei 6,123455
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

caige_rha_if:
	move 4,1
	addi 4,1
	caig 1,123455
	subi 4,2
	move 1,4
	popj 17,

caige_rha_mem:
	move 4,(1)
	caig 4,123455
	jrst %L223
	addi 4,1
%L225:
	movem 4,(1)
	move 1,(1)
	popj 17,
%L223:
	soja 4,%L225

caig_rha_ret:
	movei 6,123456
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

caig_rha_if:
	move 4,1
	addi 4,1
	caig 1,123456
	subi 4,2
	move 1,4
	popj 17,

caig_rha_mem:
	move 4,(1)
	caig 4,123456
	jrst %L230
	addi 4,1
%L232:
	movem 4,(1)
	move 1,(1)
	popj 17,
%L230:
	soja 4,%L232

cail_rhmax_ret:
	movei 6,777776
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cail_rhmax_if:
	move 4,1
	addi 4,1
	caile 1,777776
	subi 4,2
	move 1,4
	popj 17,

cail_rhmax_mem:
	move 4,(1)
	caile 4,777776
	jrst %L237
	addi 4,1
%L239:
	movem 4,(1)
	move 1,(1)
	popj 17,
%L237:
	soja 4,%L239

caile_rhmax_ret:
	movei 6,777777
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

caile_rhmax_if:
	move 4,1
	addi 4,1
	caile 1,777777
	subi 4,2
	move 1,4
	popj 17,

caile_rhmax_mem:
	move 4,(1)
	caile 4,777777
	jrst %L244
	addi 4,1
%L246:
	movem 4,(1)
	move 1,(1)
	popj 17,
%L244:
	soja 4,%L246

caige_rhmax_ret:
	movei 6,777776
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

caige_rhmax_if:
	move 4,1
	addi 4,1
	caig 1,777776
	subi 4,2
	move 1,4
	popj 17,

caige_rhmax_mem:
	move 4,(1)
	caig 4,777776
	jrst %L251
	addi 4,1
%L253:
	movem 4,(1)
	move 1,(1)
	popj 17,
%L251:
	soja 4,%L253

caig_rhmax_ret:
	movei 6,777777
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

caig_rhmax_if:
	move 4,1
	addi 4,1
	caig 1,777777
	subi 4,2
	move 1,4
	popj 17,

caig_rhmax_mem:
	move 4,(1)
	caig 4,777777
	jrst %L258
	addi 4,1
%L260:
	movem 4,(1)
	move 1,(1)
	popj 17,
%L258:
	soja 4,%L260

ucai_lt_one_ret:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

ucai_lt_one_if:
	movei 4,1
	jumpe 1,%L262
	move 4,1
	subi 4,1
%L262:
	move 1,4
	popj 17,

ucai_ge_one_ret:
	skipe 1
	movei 1,1
	popj 17,

ucai_ge_one_if:
	move 4,1
	addi 4,1
	jumpn 1,%L265
	seto 4,
%L265:
	move 1,4
	popj 17,

ucai_lt_rha_ret:
	skipl 1,1
	cail 1,123456
	tdza 1,1
	movei 1,1
	popj 17,

ucai_lt_rha_if:
	move 4,1
	addi 4,1
	cail 1,0
	cail 1,123456
	subi 4,2
	move 1,4
	popj 17,

ucai_ge_rha_ret:
	skipl 1,1
	cail 1,123456
	trna
	tdza 1,1
	movei 1,1
	popj 17,

ucai_ge_rha_if:
	move 4,1
	addi 4,1
	cail 1,0
	cail 1,123456
	jrst %L271
	subi 4,2
%L271:
	move 1,4
	popj 17,

ucai_lt_sign_ret:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

ucai_lt_sign_if:
	move 4,1
	addi 4,1
	jumpl 1,%L276
%L274:
	move 1,4
	popj 17,
%L276:
	subi 4,2
	jrst %L274

ucai_ge_sign_ret:
	lsh 1,-43
	popj 17,

ucai_ge_sign_if:
	move 4,1
	addi 4,1
	jumpl 1,%L278
	subi 4,2
%L278:
	move 1,4
	popj 17,

addi_index:
	add 1,2
	move 1,1(1)
	lsh 1,1
	popj 17,

addi_addr:
	move 1,1(1)
	popj 17,

subi_addr:
	move 1,-1(1)
	popj 17,

movei_addr:
	move 1,3(1)
	popj 17,

q_addi:
	lsh 1,33
	ash 1,-33
	addi 1,3
	popj 17,

q_andi:
	andi 1,77
	popj 17,

q_ori:
	lsh 1,33
	ash 1,-33
	iori 1,17
	popj 17,

q_xori:
	lsh 1,33
	ash 1,-33
	xori 1,13
	popj 17,

h_addi:
	hrre 1,1
	addi 1,3
	popj 17,

h_andi:
	andi 1,7777
	popj 17,

h_ori:
	hrre 1,1
	iori 1,1234
	popj 17,

h_xori:
	hrre 1,1
	xori 1,5670
	popj 17,

uq_addi:
	andi 1,777	; zero_extendqisi2
	addi 1,3
	popj 17,

uq_andi:
	andi 1,77
	popj 17,

uh_addi:
	hrrzi 1,(1)	; zero_extendhisi2
	addi 1,3
	popj 17,

uh_andi:
	andi 1,7777
	popj 17,

q_global:
	andi 1,777	; zero_extendqisi2
	addi 1,1
	movem 1,gq
	ldb 4,[POINT 18,guq,35]
	iori 4,17
	movem 4,guq
	lsh 1,33
	ash 1,-33
	add 1,4
	popj 17,

h_global:
	hrrzi 1,(1)	; zero_extendhisi2
	addi 1,1
	movem 1,gh
	hlrz 4,guh
	andi 4,7777
	movem 4,guh
	hrre 1,1
	add 1,4
	popj 17,

unsigned_immediates:
	move 3,gu
	addi 3,1
	xori 3,765432
	movem 3,gu
	move 4,vgu
	iori 4,123456
	andcmi 4,1
	movem 4,vgu
	addi 1,123456
	xor 3,1
	move 1,vgu
	xor 1,3
	popj 17,

mixed_immediates:
	move 4,1
	addi 4,123456
	iori 2,765432
	xor 4,2
	andcmi 4,1
	tlo 4,1
	tlc 4,123456
	move 1,4
	subi 1,123456
	caie 1,777776
	addi 1,1
	popj 17,

use_immediate_all:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	move 13,3
	pushj 17,addi_rha_reg
	move 10,1
	move 1,11
	pushj 17,subi_rha_reg
	add 10,1
	move 1,11
	pushj 17,imuli_7_reg
	add 10,1
	move 1,11
	pushj 17,iori_rha_reg
	add 10,1
	move 1,11
	pushj 17,andi_rhmask_reg
	add 10,1
	move 1,11
	pushj 17,xori_rha_reg
	add 10,1
	move 1,11
	pushj 17,eqvi_rha_reg
	add 10,1
	move 1,11
	pushj 17,orcmi_rha_reg
	add 10,1
	move 1,11
	pushj 17,andcmi_rha_reg
	add 10,1
	move 1,11
	pushj 17,tlo_a_reg
	add 10,1
	move 1,11
	pushj 17,tlc_a_reg
	add 10,1
	move 1,11
	pushj 17,tlz_a_reg
	add 10,1
	move 1,12
	pushj 17,caie_one_ret
	add 10,1
	move 1,12
	pushj 17,caile_rha_ret
	add 10,1
	move 1,11
	lsh 1,33
	ash 1,-33
	pushj 17,q_addi
	add 10,1
	hrre 1,11	; extendhisi2
	pushj 17,h_addi
	add 10,1
	move 1,11
	move 2,12
	pushj 17,mixed_immediates
	add 10,1
	andi 12,7
	move 1,13
	move 2,12
	pushj 17,addi_index
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.bss
gi:
	.space	4
gu:
	.space	4
vgi:
	.space	4
vgu:
	.space	4
gh:
	.space	4
guh:
	.space	4
gq:
	.space	4
guq:
	.space	4
