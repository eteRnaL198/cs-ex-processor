.text
	lui	$s0,	0x00001001	# データの先頭番地A
	addi	$t0,	$zero,	14
	sw	$t0,	0($s0)		# (A+0)番地
	addi	$t0,	$zero,	12
	sw	$t0,	4($s0)		# (A+4)番地
	addi	$t0,	$zero,	11
	sw	$t0,	8($s0)		# (A+8)番地
	addi	$t0,	$zero,	15
	sw	$t0,	12($s0)		# (A+12)番地

	add	$s1,	$zero,	$s0	# データの先頭番地A
	addi	$s2,	$s1,	8	# k = A+8
LOOP:
	slt	$t0,	$s2,	$s0	# k < A なら 1
	bne	$t0,	$zero,	EXIT	# k < A なら EXITへ

	lw	$t0,	0($s2)		# $t0に(k+0)番地の値をロード
	lw	$t1,	4($s2)		# $t1に(k+4)番地の値をロード
	sw	$t0,	4($s2)		# $t0の値を(k+4)番地にストア
	sw	$t1,	0($s2)		# $t1の値を(k+0)番地にストア
	addi	$s2,	$s2,	-4	# 1つ前のデータへ
	j	LOOP			# LOOPへ
	
EXIT:
	li	$v0,	10		# プログラムの終了
	syscall
