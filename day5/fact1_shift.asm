.data
	save:
	.space 8

.text
  li $sp, 0x10017ffc
	la	$s0,	save			# 配列の先頭アドレス
	addiu	$a0,	$zero,	 6
	sw		$a0,	  0($s0)
	li	$v0,	1
	syscall

main: add $s1, $zero, $s0
  jal fact
  sw $ra, 0($sp)
  sw $t1, 4($s1)
  li $v0, 10
  syscall

fact: addi $sp, $sp, -8
  sw $ra, 4($sp)
# if(n < 1)
  slti $t0, $a0, 1
  beq $t0, $zero, L1
  sw $s0, 0($sp)
# then
  addi $t1, $zero, 1
  jr $ra
  addi $sp, $sp, 8
# else
L1: add $s0, $zero, $a0
  jal fact
  addi $a0, $a0, -1
  j Mul # mul $t1, $s0, $t1
  nop
L3: lw $ra, 4($sp)
  lw $s0, 0($sp)
  jr $ra
  addi $sp, $sp, 8

	# $t3: a, $t4: b, $t1: y
Mul: addi $t3, $s0, 0
	addi $t4, $t1, 0
  addi $t1, $zero, 0
M3:	beq $t4, $zero, L3
  nop
	andi $t5, $t4, 1
	addi $t6, $zero, 1
	bne $t5, $t6, M1
	srl $t4, $t4, 1
	add $t1, $t1, $t3
M1: j M3
	sll $t3, $t3, 1
	

