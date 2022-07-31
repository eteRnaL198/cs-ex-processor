.data
	save:
	.space 8

.text
	la	$s0,	save			# 配�?��?�先�?�アドレス
	li	$v0,	1
	addiu	$a0,	$zero,	 13
	# addiu	$a0,	$zero,	 11
	sw		$a0,	  0($s0)
	addiu	$a0,	$zero,	 11
	sw		$a0,	  4($s0)
	li	$v0,	1
	syscall

	# $t0: a, $t1: b, $t2: y
Mul: add	$s1,	$zero,	$s0	# �?ータの先�?�番地�?$s1に保�?
	lw $t0, 0($s1)
	lw $t1, 4($s1)
	addi $t2, $zero, 0

M3:	beq $t1, $zero, M2
	sw $t2, 8($s1)
	andi $t3, $t1, 1
	addi $t4, $zero, 1
	bne $t3, $t4, M1
	srl $t1, $t1, 1
	add $t2, $t2, $t0
M1: j M3
	sll $t0, $t0, 1
M2: li $v0, 10
	syscall
	
