	.file	1 "insertionSort.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=xx
	.module	nooddspreg
	.abicalls
	.text
	.align	2
	.globl	insertionSort
	.set	nomips16
	.set	nomicromips
	.ent	insertionSort
	.type	insertionSort, @function
insertionSort:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	move	$2,$4
	addiu	$9,$4,4
	addiu	$11,$4,400
	move	$10,$0
	.option	pic0
	b	$L5
	.option	pic2
	li	$8,-1			# 0xffffffffffffffff

$L3:
	addiu	$4,$4,1
$L10:
	sll	$4,$4,2
	addu	$4,$2,$4
	sw	$7,0($4)
	addiu	$9,$9,4
	beq	$9,$11,$L11
	addiu	$10,$10,1

$L5:
	lw	$7,0($9)
	move	$4,$10
	bltz	$10,$L3
	move	$3,$9

$L2:
	lw	$5,-4($3)
	slt	$6,$7,$5
	beq	$6,$0,$L3
	nop

	sw	$5,0($3)
	addiu	$4,$4,-1
	bne	$4,$8,$L2
	addiu	$3,$3,-4

	.option	pic0
	b	$L10
	.option	pic2
	addiu	$4,$4,1

$L11:
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	insertionSort
	.size	insertionSort, .-insertionSort
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
$LC1:
	.ascii	"%d \000"
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
	.frame	$sp,88,$31		# vars= 48, regs= 4/0, args= 16, gp= 8
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-88
	sw	$31,84($sp)
	sw	$18,80($sp)
	sw	$17,76($sp)
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
	addiu	$8,$2,32
$L13:
	lw	$7,0($2)
	lw	$6,4($2)
	lw	$5,8($2)
	lw	$4,12($2)
	sw	$7,0($3)
	sw	$6,4($3)
	sw	$5,8($3)
	sw	$4,12($3)
	addiu	$2,$2,16
	bne	$2,$8,$L13
	addiu	$3,$3,16

	lw	$5,0($2)
	lw	$4,4($2)
	lw	$2,8($2)
	sw	$5,0($3)
	sw	$4,4($3)
	sw	$2,8($3)
	addiu	$4,$sp,24
	.option	pic0
	jal	insertionSort
	nop

	.option	pic2
	lw	$28,16($sp)
	move	$16,$2
	addiu	$18,$2,44
	lui	$17,%hi($LC1)
	addiu	$17,$17,%lo($LC1)
$L14:
	lw	$6,0($16)
	move	$5,$17
	li	$4,1			# 0x1
	lw	$25,%call16(__printf_chk)($28)
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	nop

	lw	$28,16($sp)
	addiu	$16,$16,4
	bne	$16,$18,$L14
	nop

	lw	$3,68($sp)
	lw	$2,%got(__stack_chk_guard)($28)
	lw	$2,0($2)
	bne	$3,$2,$L19
	move	$2,$0

	lw	$31,84($sp)
	lw	$18,80($sp)
	lw	$17,76($sp)
	lw	$16,72($sp)
	jr	$31
	addiu	$sp,$sp,88

$L19:
	lw	$25,%call16(__stack_chk_fail)($28)
	.reloc	1f,R_MIPS_JALR,__stack_chk_fail
1:	jalr	$25
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Ubuntu 10.3.0-1ubuntu1) 10.3.0"
	.section	.note.GNU-stack,"",@progbits
