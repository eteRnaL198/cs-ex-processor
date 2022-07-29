.data
	save:
	.space 16

.text
	la	$s0,	save			# 配列の先頭アドレス
	addiu	$a0,	$zero,	 1
	sw		$a0,	  0($s0)
	addiu	$a0,	$zero,	 2
	sw		$a0,	  4($s0)
	addiu	$a0,	$zero,	 3
	sw		$a0,	  8($s0)
	addiu	$a0,	$zero,	 4
	sw		$a0,	 12($s0)

	li	$v0,	2
	syscall					# 一時停止
	nop

Sort0:
	#####################################
	# 以下に並び替えのプログラムを記述
	#   ここだけに追加記入すること
	# ↑ここまで
	#####################################
Done:	nop
	
	li	$s3,	0x10018000		# IOの先頭アドレス
	addiu	$t5,	$zero,	200		# ブザーの音
	sw	$t5,	12($s3)			# ブザーを鳴らす
	li	$v0,	1
	syscall					# 一時停止
	
	li	$s1,	0x10010000		# 配列の先頭アドレス
	addi	$s2,	$s1,	16		# 配列の終端アドレス(末尾の次)
	lw	$t0,	0($s1)			# 先頭の要素をロード
	addi	$s1,	$s1,	4		# 次の要素の位置に移動
	addiu	$t5,	$zero,	300		# 成功なら高いブザー
TAtest:	beq	$s1,	$s2,	TAstop		# 配列の終端まで調べたら終了
	nop
	lw	$t1,	0($s1)			# 次の要素をロード
	addi	$s1,	$s1,	4		# 次の要素の位置に移動
	slt	$t2,	$t0,	$t1		# 現在の要素と次の要素を比較
	add	$t0,	$zero,	$t1		# 次の要素をコピー
	beq	$t2,	$zero	TAtest		# 現在の要素が小さければ終了(ソート失敗)
	nop
	addi 	$t5,	$zero,	100		# 失敗なら低いブザー

TAstop:	sw	$t5,	12($s3)			# ブザーを鳴らす
	li	$v0,	1
	syscall					# 一時停止
	
	li	$s1,	0x10010000		# 配列の先頭アドレス
View:	lw	$t1,	0($s1)			# 現在の要素をロード
	sw	$t1,	0($s3)			# Ram1に書き込み(出力用)
	addi	$s1,	$s1,	4		# 次の要素の位置に移動
	bne	$s1,	$s2,	View		# 終了判定
	nop
	
	addiu	$t5,	$zero,	200
	sw	$t5,	12($s3)			# ブザーを鳴らす
	li	$v0,	10			# プログラムの終了
	syscall
	nop
