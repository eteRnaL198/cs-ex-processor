	.file	1 "clear_array.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=xx
	.module	nooddspreg
	.abicalls
	.text
	.align	2
	.globl	clear_array
	.set	nomips16
	.set	nomicromips
	.ent	clear_array
	.type	clear_array, @function
clear_array:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	move	$2,$0     # i = 0;
$L2:
	sw	$0,0($4)  # x[i] = 0;
	addiu	$2,$2,1   # i++;
	slt	$3,$5,$2  # n <  i なら 1
	beq	$3,$0,$L2 # n >= i なら L2
	addiu	$4,$4,4   # x++;

	jr	$31       # リターン
	nop

	.set	macro
	.set	reorder
	.end	clear_array
	.size	clear_array, .-clear_array
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
$LC1:
	.ascii	"%d \000"
	.text
	.align	2
	.globl	show_array
	.set	nomips16
	.set	nomicromips
	.ent	show_array
	.type	show_array, @function
show_array:
	.frame	$sp,40,$31		# vars= 0, regs= 4/0, args= 16, gp= 8
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$18,32($sp)
	sw	$17,28($sp)
	sw	$16,24($sp)
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	bltz	$5,$L5
	.cprestore	16

	move	$16,$4
	addiu	$4,$4,4
	sll	$5,$5,2
	addu	$17,$4,$5
	lui	$18,%hi($LC1)
	addiu	$18,$18,%lo($LC1)
$L6:
	lw	$6,0($16)
	move	$5,$18
	li	$4,1			# 0x1
	lw	$25,%call16(__printf_chk)($28)
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	nop

	lw	$28,16($sp)
	addiu	$16,$16,4
	bne	$16,$17,$L6
	nop

$L5:
	li	$4,10			# 0xa
	lw	$25,%call16(putchar)($28)
	.reloc	1f,R_MIPS_JALR,putchar
1:	jalr	$25
	nop

	lw	$28,16($sp)
	lw	$31,36($sp)
	lw	$18,32($sp)
	lw	$17,28($sp)
	lw	$16,24($sp)
	jr	$31
	addiu	$sp,$sp,40

	.set	macro
	.set	reorder
	.end	show_array
	.size	show_array, .-show_array
	.rdata
	.align	2
$LC0:
	.word	5
	.word	8
	.word	1
	.word	7
	.word	2
	.word	0
	.word	10
	.word	9
	.word	3
	.word	4
	.word	6
	.text
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$sp,80,$31		# vars= 48, regs= 2/0, args= 16, gp= 8
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-80
	sw	$31,76($sp)
	sw	$16,72($sp)
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	lw	$2,%got(__stack_chk_guard)($28)
	lw	$2,0($2)
	sw	$2,68($sp)
	lui	$2,%hi($LC0)
	addiu	$2,$2,%lo($LC0)
	addiu	$3,$sp,24
	addiu	$4,$2,32
$L10:
	lw	$8,0($2)
	lw	$7,4($2)
	lw	$6,8($2)
	lw	$5,12($2)
	sw	$8,0($3)
	sw	$7,4($3)
	sw	$6,8($3)
	sw	$5,12($3)
	addiu	$2,$2,16
	bne	$2,$4,$L10
	addiu	$3,$3,16

	lw	$5,0($2)
	lw	$4,4($2)
	lw	$2,8($2)
	sw	$5,0($3)
	sw	$4,4($3)
	sw	$2,8($3)
	li	$5,10			# 0xa
	addiu	$16,$sp,24
	move	$4,$16
	.option	pic0
	jal	show_array
	nop

	.option	pic2
	lw	$28,16($sp)
	li	$5,10			# 0xa
	move	$4,$16
	.option	pic0
	jal	clear_array
	nop

	.option	pic2
	lw	$28,16($sp)
	li	$5,10			# 0xa
	move	$4,$16
	.option	pic0
	jal	show_array
	nop

	.option	pic2
	lw	$28,16($sp)
	lw	$3,68($sp)
	lw	$2,%got(__stack_chk_guard)($28)
	lw	$2,0($2)
	bne	$3,$2,$L14
	move	$2,$0

	lw	$31,76($sp)
	lw	$16,72($sp)
	jr	$31
	addiu	$sp,$sp,80

$L14:
	lw	$25,%call16(__stack_chk_fail)($28)
	.reloc	1f,R_MIPS_JALR,__stack_chk_fail
1:	jalr	$25
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0"
