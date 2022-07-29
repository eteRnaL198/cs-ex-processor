.data
	save:
	.space 16

.text
	la	$s0,	save			# 配列の先頭アドレス
	li	$v0,	1
  li $sp, 0x10017ffc
	addiu	$a0,	$zero,	 6
	sw		$a0,	  0($s0)
	li	$v0,	1
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
  mul $t1, $s0, $t1

  lw $ra, 4($sp)
  beq $ra, $zero, L2
  lw $s0, 0($sp)
  jr $ra
  addi $sp, $sp, 8
  nop
L2: li $v0, 10
  syscall
