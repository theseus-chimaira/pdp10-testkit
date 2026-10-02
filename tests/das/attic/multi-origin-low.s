	.globl	low_entry
	.globl	low_data
	.text
low_entry:
	movei 1,high_entry
	move 2,[123]
	.data
low_data:
	.long	high_data
	.bss
low_bss:
	.space	4
