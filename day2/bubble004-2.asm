.data
	save:
	.space 16

.text
	la	$s0,	save			# 配列の先頭アドレス
	addiu	$a0,	$zero,	 4
	sw		$a0,	  0($s0)
	addiu	$a0,	$zero,	 2
	sw		$a0,	  4($s0)
	addiu	$a0,	$zero,	 3
	sw		$a0,	  8($s0)
	addiu	$a0,	$zero,	 1
	sw		$a0,	 12($s0)
	li	$v0,	1
	syscall

Sort0:
	#####################################
	#↓以下に並び替えのプログラム記述
	#   ここだけに追加記入すること

	add	$s1,	$zero,	$s0	# データの先頭番地を$s1に保存
	# t0 arr[j+1]
	# t1 arr[j+1]
	addi $t2, $zero, 0 # i
	addi $t3, $zero, 0 # j
	# t4 tmp

	lw $t0, 0($s1)

Bubble:lw $t1, 4($s1)
	# cmp
	slt $t4, $t0, $t1
	bne $t4, $zero, Bubble1
	addi $t3, $t3, 1 # nop→addi
	# swap
	sw $t0, 4($s1)
	sw $t1, 0($s1)
Bubble1: addi $s1, $s1, 4
	addi $t4, $zero, 3
	sub $t4, $t4, $t2 # 余分なループを減らす
	beq $t3, $t4, Bubble2 # if(t3 j	== 3-i) goto Bubble2
	nop
	j Bubble
	lw $t0, 0($s1)

Bubble2: addi $t3, $zero, 0
	addi $t2, $t2, 1
	add $s1, $zero, $s0	# s1 = s0

	addi $t4, $zero, 3
	bne $t2, $t4, Bubble
	lw $t0, 0($s1)

	li $v0, 1
	syscall

	#↑ここまで
	#####################################
Done:	
	addiu	$t5,	$zero,	100
	li	$s3,	0x10018000		# $s3にRam1のアドレスをロード
	li	$s1,	0x10010000		# $s1が先頭アドレス
	sw	$t5,	12($s3)			# ブザーを鳴らす
	li	$s2,	0x10010190		# $s2が最終アドレス

	li	$v0,	1
	syscall					# 一時停止
	
	addi	$t0,	$zero,	101		
TAtest:	
	addi	$t0,	$t0,	-1		# 配列の中身が降順ソートされたか判定
	beq	$t0,	$zero,	TAt		# 最後まであっていたらブザーは鳴らない
	nop
	lw	$t1,	0($s1)			# 配列のロード
	nop
	beq	$t0,	$t1	TAtest		# 真の値と配列を比較
	addi	$s1,	$s1,	4		# 次の配列の要素へ移動
	addi 	$t5,	$zero,	300		# 違っている場合は高いブザー
	sw	$t5,	12($s3)			
	j	TAstop
	nop
TAt:	
	sw	$t5,	12($s3)			# 正しい場合は低いブザー
	nop
TAstop:	
	li	$v0,	1
	syscall					# 一時停止
	
	li	$s1,	0x10010000		# $s1が先頭アドレス
View:	lw	$t1,	0($s1)			# $t1に配列の先頭番地から順番にロード
	addi	$s1,	$s1,	4		# 次の配列の要素へ移動
	bne	$s1,	$s2,	View		# 終了判定
	sw	$t1,	0($s3)			# Ram1に書き込み(出力用)
	nop
	li	$v0,	10			# プログラムの終了
	syscall
