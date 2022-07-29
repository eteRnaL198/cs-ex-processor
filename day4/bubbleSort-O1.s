	.file	1 "sort.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=xx
	.module	nooddspreg
	.abicalls
	.text
	.align	2
	.globl	BubbleSort
	.set	nomips16
	.set	nomicromips
	.ent	BubbleSort
	.type	BubbleSort, @function
BubbleSort:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$2,$5,-1
	blez	$2,$L8
	move	$9,$2

	sll	$5,$5,2
	addu	$7,$4,$5
	.option	pic0
	b	$L3
	.option	pic2
	move	$8,$0

$L4:
	addiu	$2,$2,4
	beq	$7,$2,$L7
	nop

$L5:
	lw	$5,0($2)
	lw	$3,-4($2)
	slt	$6,$5,$3
	beq	$6,$0,$L4
	nop

	sw	$5,-4($2)
	.option	pic0
	b	$L4
	.option	pic2
	sw	$3,0($2)

$L7:
	addiu	$8,$8,1
	beq	$8,$9,$L8
	nop

$L3:
	.option	pic0
	b	$L5
	.option	pic2
	addiu	$2,$4,4

$L8:
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	BubbleSort
	.size	BubbleSort, .-BubbleSort
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
$LC0:
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
	blez	$5,$L10
	.cprestore	16

	move	$16,$4
	sll	$5,$5,2
	addu	$17,$4,$5
	lui	$18,%hi($LC0)
	addiu	$18,$18,%lo($LC0)
$L11:
	lw	$6,0($16)
	move	$5,$18
	li	$4,1			# 0x1
	lw	$25,%call16(__printf_chk)($28)
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	nop

	lw	$28,16($sp)
	addiu	$16,$16,4
	bne	$16,$17,$L11
	nop

$L10:
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
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$sp,448,$31		# vars= 408, regs= 3/0, args= 16, gp= 8
	.mask	0x80030000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-448
	sw	$31,444($sp)
	sw	$17,440($sp)
	sw	$16,436($sp)
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	lw	$17,%got(__stack_chk_guard)($28)
	lw	$2,0($17)
	sw	$2,428($sp)
	li	$6,400			# 0x190
	move	$5,$0
	addiu	$16,$sp,28
	move	$4,$16
	lw	$25,%call16(memset)($28)
	.reloc	1f,R_MIPS_JALR,memset
1:	jalr	$25
	nop

	lw	$28,16($sp)
	li	$5,100			# 0x64
	move	$4,$16
	.option	pic0
	jal	BubbleSort
	nop

	.option	pic2
	lw	$28,16($sp)
	li	$5,100			# 0x64
	move	$4,$16
	.option	pic0
	jal	show_array
	nop

	.option	pic2
	lw	$28,16($sp)
	lw	$4,428($sp)
	lw	$3,0($17)
	bne	$4,$3,$L17
	move	$2,$0

	lw	$31,444($sp)
	lw	$17,440($sp)
	lw	$16,436($sp)
	jr	$31
	addiu	$sp,$sp,448

$L17:
	lw	$25,%call16(__stack_chk_fail)($28)
	.reloc	1f,R_MIPS_JALR,__stack_chk_fail
1:	jalr	$25
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
