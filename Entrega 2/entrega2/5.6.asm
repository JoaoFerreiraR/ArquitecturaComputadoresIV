.data
ALL_INT_MASK:	.word	0x0000ff00
KBD_INT_MASK:	.word	0x00010000
.text

StartMultiThreading:
	mfc0	$t0, $12
	lw 	$t1, ALL_INT_MASK
	not	$t1, $t1
	and	$t0, $t0 , $t1 # disable all int
	lw	$t1, KBD_INT_MASK
	or	$t0, $t0 , $t1
	mtc0	$t0, $12
	# now enable interrupts on the KBD
	la	$t0, 0xffff0000
	li	$t1, 0x00000002
	sw	$t1, 0($t0)
	
	jr	$ra
