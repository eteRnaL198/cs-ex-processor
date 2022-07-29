`timescale 1ns/1ns
module rom(adrs, dout);
	input  [ 8:0] adrs;
	output [31:0] dout;
	reg    [31:0] dout;
	
	always@(adrs) begin
		case(adrs)
			9'h000 : dout <= 32'h3c011001; //   	la	$s0,	save			# 配列の先頭アドレス
			9'h001 : dout <= 32'h34300000; //   
			9'h002 : dout <= 32'h24020001; //   	li	$v0,	1
			9'h003 : dout <= 32'h2404000d; //   	addiu	$a0,	$zero,	 13
			9'h004 : dout <= 32'hae040000; //   	sw		$a0,	  0($s0)
			9'h005 : dout <= 32'h2404000b; //   	addiu	$a0,	$zero,	 11
			9'h006 : dout <= 32'hae040004; //   	sw		$a0,	  4($s0)
			9'h007 : dout <= 32'h24020001; //   	li	$v0,	1
			9'h008 : dout <= 32'h0000000c; //   	syscall
			9'h009 : dout <= 32'h00108820; //   Mul: 	add	$s1,	$zero,	$s0	# データの先頭番地を$s1に保存
			9'h00a : dout <= 32'h8e280000; //   	lw 	$t0, 0($s1)
			9'h00b : dout <= 32'h8e290004; //   	lw 	$t1, 4($s1)
			9'h00c : dout <= 32'h200a0000; //   	addi 	$t2, $zero, 0
			9'h00d : dout <= 32'h1120000a; //   M3:	beq 	$t1, $zero, M2
			9'h00e : dout <= 32'h00000000; //   	nop
			9'h00f : dout <= 32'h312b0001; //   	andi	$t3, $t1, 1
			9'h010 : dout <= 32'h200c0001; //   	addi 	$t4, $zero, 1
			9'h011 : dout <= 32'h156c0003; //   	bne 	$t3, $t4, M1
			9'h012 : dout <= 32'h00000000; //   	nop
			9'h013 : dout <= 32'h01485020; //   	add	$t2, $t2, $t0
			9'h014 : dout <= 32'hae0a0008; //   	sw	$t2, 8($s0)
			9'h015 : dout <= 32'h00084040; //   M1: 	sll	 $t0, $t0, 1
			9'h016 : dout <= 32'h0810000d; //   	j	 M3
			9'h017 : dout <= 32'h00094842; //   	srl	 $t1, $t1, 1
			9'h018 : dout <= 32'h2402000a; //   M2:	 li	 $v0, 10
			9'h019 : dout <= 32'h0000000c; //   	syscall
			default : dout <= 32'h0;
		endcase
	end
endmodule
