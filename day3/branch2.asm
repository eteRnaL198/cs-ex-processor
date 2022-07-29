.text
	addi	$s0,	$zero,	5
	addi	$s1,	$s0,	3
	bne	$s0,	$s1,	ELSE
	addi	$s0,	$s0,	-1
	j	NEXT
ELSE:	addi	$s0,	$s0,	1
NEXT:	add	$s2,	$s1,	$s1
	li	$v0,	10
	syscall
