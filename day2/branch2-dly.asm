.text
	addi	$s0,	$zero,	5
	addi	$s1,	$s0,	3
	bne	$s0,	$s1,	ELSE
	add	$s2,	$s1,	$s1 # 先に実行しても同じ
	addi	$s0,	$s0,	-1
	j	NEXT
	# NEXTでs0を使ってないから次のELSEを実行してよい→nopはいらない
ELSE:	addi	$s0,	$s0,	1
NEXT: li	$v0,	10
	syscall
