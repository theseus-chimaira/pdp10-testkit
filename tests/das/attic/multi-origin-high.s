	.globl	high_entry
	.globl	high_data
	.text
high_entry:
	movei 3,low_data
	.data
high_data:
	.long	low_entry
