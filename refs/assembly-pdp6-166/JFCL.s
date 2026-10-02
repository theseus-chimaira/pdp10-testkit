
jfcl_direct_0:
#APP
	jfcl 0,1f
1:
#NO_APP
	popj 17,

jfcl_direct_1:
#APP
	jfcl 1,1f
1:
#NO_APP
	popj 17,

jfcl_direct_2:
#APP
	jfcl 2,1f
1:
#NO_APP
	popj 17,

jfcl_direct_3:
#APP
	jfcl 3,1f
1:
#NO_APP
	popj 17,

jfcl_direct_4:
#APP
	jfcl 4,1f
1:
#NO_APP
	popj 17,

jfcl_direct_5:
#APP
	jfcl 5,1f
1:
#NO_APP
	popj 17,

jfcl_direct_6:
#APP
	jfcl 6,1f
1:
#NO_APP
	popj 17,

jfcl_direct_7:
#APP
	jfcl 7,1f
1:
#NO_APP
	popj 17,

jfcl_direct_10:
#APP
	jfcl 10,1f
1:
#NO_APP
	popj 17,

jfcl_direct_11:
#APP
	jfcl 11,1f
1:
#NO_APP
	popj 17,

jfcl_direct_12:
#APP
	jfcl 12,1f
1:
#NO_APP
	popj 17,

jfcl_direct_13:
#APP
	jfcl 13,1f
1:
#NO_APP
	popj 17,

jfcl_direct_14:
#APP
	jfcl 14,1f
1:
#NO_APP
	popj 17,

jfcl_direct_15:
#APP
	jfcl 15,1f
1:
#NO_APP
	popj 17,

jfcl_direct_16:
#APP
	jfcl 16,1f
1:
#NO_APP
	popj 17,

jfcl_direct_17:
#APP
	jfcl 17,1f
1:
#NO_APP
	popj 17,

jfcl_alias_jfov:
#APP
	jfov 1f
1:
#NO_APP
	popj 17,

jfcl_alias_jcry1:
#APP
	jcry1 1f
1:
#NO_APP
	popj 17,

jfcl_alias_jcry0:
#APP
	jcry0 1f
1:
#NO_APP
	popj 17,

jfcl_alias_jcry:
#APP
	jcry 1f
1:
#NO_APP
	popj 17,

jfcl_alias_jov:
#APP
	jov 1f
1:
#NO_APP
	popj 17,

jfcl_before_add:
#APP
	jfcl 0,1f
1:
#NO_APP
	add 1,2
	popj 17,

jfcl_after_add:
	add 1,2
#APP
	jfcl 0,1f
1:
#NO_APP
	popj 17,

jfcl_between_ops:
	add 1,2
#APP
	jfcl 0,1f
1:
#NO_APP
	xor 1,2
	popj 17,

jfcl_in_branch:
	move 4,1
	move 1,2
	caml 4,2
	popj 17,
#APP
	jfcl 0,1f
1:
#NO_APP
	move 1,4
	popj 17,

jfcl_in_loop:
	move 4,1
	subi 1,1
	jumple 4,%L33
%L31:
#APP
	jfcl 0,1f
1:
#NO_APP
	addi 2,1
	move 4,1
	subi 1,1
	jumpg 4,%L31
%L33:
	move 1,2
	popj 17,

jfcl_store_after:
#APP
	jfcl 0,1f
1:
#NO_APP
	movem 2,(1)
	popj 17,

jfcl_load_before:
	move 1,(1)
#APP
	jfcl 0,1f
1:
#NO_APP
	popj 17,

jfcl_volatile_load:
	move 1,(1)
#APP
	jfcl 0,1f
1:
#NO_APP
	popj 17,

jfcl_volatile_store:
#APP
	jfcl 0,1f
1:
#NO_APP
	movem 2,(1)
	popj 17,

