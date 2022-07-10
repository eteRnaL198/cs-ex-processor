.text
	addi	$t0,	$zero,	10	# X
	# addi	$t1,	$zero,	9	# Y
	addi	$t1,	$zero,	10	# Y
	beq	$t0,	$t1,	TRUE	# 等しければTRUEへ
	# bne	$t0,	$t1,	TRUE	# 等しければTRUEへ

	j	ELSE			# ELSEへ

TRUE:	
	addi	$t0,	$t0,	1	# X++
	j	EXIT			# EXITへ

ELSE:	
	addi	$t1,	$t1,	1	# Y++
EXIT:	
	li	$v0,	10		# プログラムの終了
	syscall
