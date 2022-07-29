	.file	1 "bubbleSort.c"
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
	addiu	$9,$5,-1
	blez	$9,$L9
	sll	$5,$5,2

	move	$7,$0
	addu	$6,$4,$5
	addiu	$8,$4,4
	move	$2,$8
$L4:
	lw	$4,0($2)
	lw	$3,-4($2)
	slt	$5,$4,$3
	beq	$5,$0,$L3
	nop

	sw	$4,-4($2)
	sw	$3,0($2)
$L3:
	addiu	$2,$2,4
	bne	$6,$2,$L4
	nop

	addiu	$7,$7,1
	bne	$9,$7,$L4
	move	$2,$8

$L9:
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	BubbleSort
	.size	BubbleSort, .-BubbleSort
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
	.frame	$sp,48,$31		# vars= 0, regs= 5/0, args= 16, gp= 8
	.mask	0x800f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	lui	$28,%hi(__gnu_local_gp)
	addiu	$sp,$sp,-48
	addiu	$28,$28,%lo(__gnu_local_gp)
	sw	$31,44($sp)
	sw	$19,40($sp)
	sw	$18,36($sp)
	sw	$17,32($sp)
	sw	$16,28($sp)
	blez	$5,$L11
	.cprestore	16

	lui	$19,%hi($LC1)
	move	$17,$0
	addiu	$19,$19,%lo($LC1)
	move	$18,$5
	move	$16,$4
$L12:
	lw	$25,%call16(__printf_chk)($28)
	li	$4,1			# 0x1
	lw	$6,0($16)
	addiu	$17,$17,1
	move	$5,$19
	.reloc	1f,R_MIPS_JALR,__printf_chk
1:	jalr	$25
	addiu	$16,$16,4

	bne	$18,$17,$L12
	lw	$28,16($sp)

$L11:
	lw	$31,44($sp)
	li	$4,10			# 0xa
	lw	$19,40($sp)
	lw	$18,36($sp)
	lw	$17,32($sp)
	lw	$16,28($sp)
	lw	$25,%call16(putchar)($28)
	.reloc	1f,R_MIPS_JALR,putchar
1:	jr	$25
	addiu	$sp,$sp,48

	.set	macro
	.set	reorder
	.end	show_array
	.size	show_array, .-show_array
	.rdata
	.align	2
$LC0:
	.word	63
	.word	86
	.word	64
	.word	98
	.word	44
	.word	31
	.word	75
	.word	90
	.word	18
	.word	52
	.word	14
	.word	30
	.word	69
	.word	23
	.word	57
	.word	12
	.word	9
	.word	56
	.word	53
	.word	35
	.word	51
	.word	20
	.word	61
	.word	46
	.word	65
	.word	43
	.word	3
	.word	16
	.word	34
	.word	5
	.word	25
	.word	68
	.word	10
	.word	28
	.word	32
	.word	77
	.word	81
	.word	97
	.word	8
	.word	42
	.word	99
	.word	26
	.word	13
	.word	1
	.word	50
	.word	24
	.word	15
	.word	71
	.word	83
	.word	22
	.word	87
	.word	72
	.word	54
	.word	48
	.word	36
	.word	19
	.word	2
	.word	0
	.word	66
	.word	85
	.word	93
	.word	89
	.word	4
	.word	33
	.word	67
	.word	49
	.word	29
	.word	62
	.word	96
	.word	92
	.word	41
	.word	60
	.word	37
	.word	79
	.word	47
	.word	88
	.word	38
	.word	58
	.word	84
	.word	6
	.word	40
	.word	27
	.word	82
	.word	73
	.word	80
	.word	74
	.word	45
	.word	59
	.word	55
	.word	7
	.word	91
	.word	70
	.word	94
	.word	11
	.word	17
	.word	78
	.word	21
	.word	39
	.word	76
	.word	95
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$sp,448,$31		# vars= 416, regs= 2/0, args= 16, gp= 8
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	lui	$28,%hi(__gnu_local_gp)
	addiu	$sp,$sp,-448
	addiu	$28,$28,%lo(__gnu_local_gp)
	lui	$2,%hi($LC0)
	sw	$16,440($sp)
	addiu	$4,$sp,36
	lw	$16,%got(__stack_chk_guard)($28)
	addiu	$2,$2,%lo($LC0)
	sw	$31,444($sp)
	move	$3,$4
	addiu	$6,$2,400
	.cprestore	16
	lw	$5,0($16)
	sw	$5,436($sp)
$L16:
	lw	$9,0($2)
	addiu	$2,$2,16
	addiu	$3,$3,16
	sw	$9,-16($3)
	lw	$8,-12($2)
	lw	$7,-8($2)
	lw	$5,-4($2)
	sw	$8,-12($3)
	sw	$7,-8($3)
	bne	$2,$6,$L16
	sw	$5,-4($3)

	li	$5,100			# 0x64
	.option	pic0
	jal	BubbleSort
	.option	pic2
	sw	$4,28($sp)

	li	$5,100			# 0x64
	.option	pic0
	jal	show_array
	.option	pic2
	lw	$4,28($sp)

	lw	$3,436($sp)
	lw	$2,0($16)
	bne	$3,$2,$L20
	lw	$28,16($sp)

	lw	$31,444($sp)
	move	$2,$0
	lw	$16,440($sp)
	jr	$31
	addiu	$sp,$sp,448

$L20:
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
