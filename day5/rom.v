`timescale 1ns/1ns
module rom(adrs, dout);
	input  [ 8:0] adrs;
	output [31:0] dout;
	reg    [31:0] dout;
	
	always@(adrs) begin
		case(adrs)
			9'h000 : dout <= 32'h3c011001; //     li  $sp, 0x10017ffc
			9'h001 : dout <= 32'h343d7ffc; //   
			9'h002 : dout <= 32'h3c011001; //   	la	$s0,	save			# 配�?��?�先�?�アドレス
			9'h003 : dout <= 32'h34300000; //   
			9'h004 : dout <= 32'h24020001; //   	li	$v0,	1
			9'h005 : dout <= 32'h24040006; //   	addiu	$a0,	$zero,	 6
			9'h006 : dout <= 32'hae040000; //   	sw $a0, 0($s0)
			9'h007 : dout <= 32'h24050001; //     addiu $a1, $zero, 1
			9'h008 : dout <= 32'hae050004; //     sw $a1, 4($s0)
			9'h009 : dout <= 32'h24020001; //   	li	$v0,	1
			9'h00a : dout <= 32'h0000000c; //   	syscall
			9'h00b : dout <= 32'h00108820; //   main: add $s1, $zero, $s0
			9'h00c : dout <= 32'h0c100011; //     jal fact
			9'h00d : dout <= 32'hafbf0000; //     sw $ra, 0($sp)
			9'h00e : dout <= 32'hae290008; //     sw $t1, 8($s1)
			9'h00f : dout <= 32'h2402000a; //     li $v0, 10
			9'h010 : dout <= 32'h0000000c; //     syscall
			9'h011 : dout <= 32'h23bdfff8; //   fact: addi $sp, $sp, -8
			9'h012 : dout <= 32'hafbf0004; //     sw $ra, 4($sp)
			9'h013 : dout <= 32'h28880001; //     slti $t0, $a0, 1
			9'h014 : dout <= 32'h11000004; //     beq $t0, $zero, L1
			9'h015 : dout <= 32'hafb00000; //     sw $s0, 0($sp)
			9'h016 : dout <= 32'h00054820; //     add $t1, $zero, $a1
			9'h017 : dout <= 32'h03e00008; //     jr $ra
			9'h018 : dout <= 32'h23bd0008; //     addi $sp, $sp, 8
			9'h019 : dout <= 32'h00048020; //   L1: add $s0, $zero, $a0
			9'h01a : dout <= 32'h70a42802; //     mul $a1, $a1, $a0
			9'h01b : dout <= 32'h0c100011; //     jal fact
			9'h01c : dout <= 32'h2084ffff; //     addi $a0, $a0, -1
			9'h01d : dout <= 32'h8fb00000; //     lw $s0, 0($sp)
			9'h01e : dout <= 32'h8fbf0004; //     lw $ra, 4($sp)
			9'h01f : dout <= 32'h03e00008; //     jr $ra
			9'h020 : dout <= 32'h23bd0008; //     addi $sp, $sp, 8
			default : dout <= 32'h0;
		endcase
	end
endmodule
