.text
	lui	$s0,	0x00001001
	addi	$s1,	$zero,	5
	addi	$s2,	$zero,	3
	add	$t0,	$s1,	$s2
	add	$t1,	$s1,	$s2
	add	$t2,	$s1,	$s2
	sw	$s2,	0($s0)
	lw	$s3,	0($s0)
	add	$s3,	$s3,	$s3
	add	$s3,	$s3,	$s3
	add	$s3,	$s3,	$s3
	
	li	$v0,	10
	syscall
	