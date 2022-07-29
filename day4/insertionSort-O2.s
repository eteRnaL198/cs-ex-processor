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
	addiu	$9,$2,400
	addiu	$4,$4,4
$L5:
	lw	$8,0($4)
	move	$3,$4
$L2:
	lw	$5,-4($3)
	slt	$7,$8,$5
	beq	$7,$0,$L3
	move	$6,$3

	sw	$5,0($3)
	addiu	$3,$6,-4
	bne	$2,$3,$L2
	nop

	move	$6,$2
$L3:
	addiu	$4,$4,4
	bne	$9,$4,$L5
	sw	$8,0($6)

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
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$sp,96,$31		# vars= 48, regs= 5/0, args= 16, gp= 8
	.mask	0x800f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	lui	$28,%hi(__gnu_local_gp)
	addiu	$sp,$sp,-96
	addiu	$28,$28,%lo(__gnu_local_gp)
	lui	$2,%hi($LC0)
	sw	$18,84($sp)
	addiu	$4,$sp,24
	lw	$18,%got(__stack_chk_guard)($28)
	addiu	$2,$2,%lo($LC0)
	sw	$31,92($sp)
	move	$3,$4
	addiu	$9,$2,32
	sw	$19,88($sp)
	sw	$17,80($sp)
	sw	$16,76($sp)
	.cprestore	16
	lw	$5,0($18)
	sw	$5,68($sp)
$L10:
	lw	$8,0($2)
	addiu	$2,$2,16
	addiu	$3,$3,16
	sw	$8,-16($3)
	lw	$7,-12($2)
	lw	$6,-8($2)
	lw	$5,-4($2)
	sw	$7,-12($3)
	sw	$6,-8($3)
	bne	$2,$9,$L10
	sw	$5,-4($3)

	lw	$6,0($2)
	lui	$17,%hi($LC1)
	lw	$5,4($2)
	lw	$2,8($2)
	addiu	$17,$17,%lo($LC1)
	sw	$6,0($3)
	sw	$5,4($3)
	.option	pic0
	jal	insertionSort
	.option	pic2
	sw	$2,8($3)

	lw	$28,16($sp)
	addiu	$19,$2,44
	move	$16,$2
$L11:
	lw	$25,%call16(__printf_chk)($28)
	li	$4,1			# 0x1
	lw	$6,0($16)
	addiu	$16,$16,4
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	move	$5,$17

	bne	$16,$19,$L11
	lw	$28,16($sp)

	lw	$3,68($sp)
	lw	$2,0($18)
	bne	$3,$2,$L16
	lw	$31,92($sp)

	move	$2,$0
	lw	$19,88($sp)
	lw	$18,84($sp)
	lw	$17,80($sp)
	lw	$16,76($sp)
	jr	$31
	addiu	$sp,$sp,96

$L16:
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
