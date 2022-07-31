.data
	save:
	.space 8

.text
  li  $sp, 0x10017ffc
	la	$s0,	save			# 配列の先頭アドレス
	li	$v0,	1
	addiu	$a0,	$zero,	 6
	sw $a0, 0($s0)
  addiu $a1, $zero, 1
  sw $a1, 4($s0)
	li	$v0,	1
	syscall

main: add $s1, $zero, $s0
  jal fact
  sw $ra, 0($sp)
  sw $t1, 8($s1)
  li $v0, 10
  syscall

fact: addi $sp, $sp, -8
  sw $ra, 4($sp)
# if(n < 1)
  slti $t0, $a0, 1
  beq $t0, $zero, L1
  sw $s0, 0($sp)
# then
  add $t1, $zero, $a1
  jr $ra
  addi $sp, $sp, 8
# else
L1: add $s0, $zero, $a0
  mul $a1, $a1, $a0
  jal fact
  addi $a0, $a0, -1

  lw $s0, 0($sp)
  lw $ra, 4($sp)
  jr $ra
  addi $sp, $sp, 8





# fact: addi $sp, $sp, -8
#   sw $ra, 4($sp)
# # if(n < 1)
#   slti $t0, $a0, 1
#   beq $t0, $zero, L1
#   sw $s0, 0($sp)
# # then
#   addi $t1, $zero, 1
#   jr $ra
#   addi $sp, $sp, 8
# # else
# L1: add $s0, $zero, $a0
#   jal fact
#   addi $a0, $a0, -1
#   mul $t1, $s0, $t1

#   lw $ra, 4($sp)
#   lw $s0, 0($sp)
#   jr $ra
#   addi $sp, $sp, 8
