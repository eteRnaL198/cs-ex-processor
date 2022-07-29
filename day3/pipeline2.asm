.text
	addi	$s0,	$zero,	5
	addi	$s1,	$zero,	3
	addi	$s2,	$zero,	16
	addi	$s3,	$zero,	2
	add	$t0,	$s0,	$s1
	sub	$t1,	$s0,	$s1
	and	$t2,	$s0,	$s1
	or	$t3,	$s0,	$s1
	xor	$t4,	$s0,	$s1
	slt	$t5,	$s1,	$s2
	srl	$t6,	$s2,	2
	sll	$t7,	$s3,	2
	
	li	$v0,	10
	syscall
	
