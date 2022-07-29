`timescale 1ns/1ns
module rom(adrs, dout);
	input  [ 8:0] adrs;
	output [31:0] dout;
	reg    [31:0] dout;
	
	always@(adrs) begin
		case(adrs)
			9'h000 : dout <= 32'h3c011001; //   	li	$sp, 0x10017ffc
			9'h001 : dout <= 32'h343d7ffc; //   
			9'h002 : dout <= 32'h24100006; //   	li	$s0, 6
			9'h003 : dout <= 32'h24110001; //   	li	$s1, 1
			9'h004 : dout <= 32'h00102021; //   	move	$a0, $s0
			9'h005 : dout <= 32'h0c10000a; //   	jal	fact
			9'h006 : dout <= 32'h00112821; //   	move	$a1, $s1
			9'h007 : dout <= 32'h00029021; //   	move	$s2, $v0
			9'h008 : dout <= 32'h2402000a; //   	li	$v0, 10
			9'h009 : dout <= 32'h0000000c; //   	syscall
			9'h00a : dout <= 32'h23bdfff8; //   	addi	$sp, $sp, -8
			9'h00b : dout <= 32'hafbf0004; //   	sw	$ra, 4($sp)
			9'h00c : dout <= 32'h28880001; //   	slti	$t0, $a0, 1
			9'h00d : dout <= 32'h11000004; //   	beq	$t0, $zero, f_else
			9'h00e : dout <= 32'hafb00000; //   	sw	$s0, 0($sp)
			9'h00f : dout <= 32'h00051020; //   	add	$v0, $zero, $a1
			9'h010 : dout <= 32'h03e00008; //   	jr	$ra
			9'h011 : dout <= 32'h23bd0008; //   	addi	$sp, $sp, 8
			9'h012 : dout <= 32'h70852802; //   	mul	$a1, $a0, $a1
			9'h013 : dout <= 32'h0c10000a; //   	jal	fact
			9'h014 : dout <= 32'h2084ffff; //   	addi	$a0, $a0, -1
			9'h015 : dout <= 32'h8fbf0004; //   	lw	$ra, 4($sp)
			9'h016 : dout <= 32'h8fb00000; //   	lw	$s0, 0($sp)
			9'h017 : dout <= 32'h03e00008; //   	jr	$ra
			9'h018 : dout <= 32'h23bd0008; //   	addi	$sp, $sp, 8
			9'h019 : dout <= 32'h20020000; //   	addi	$v0, $zero, 0
			9'h01a : dout <= 32'h30a80001; //   	andi	$t0, $a1, 1
			9'h01b : dout <= 32'h11000002; //   	beq	$t0, $zero, m_next
			9'h01c : dout <= 32'h00052842; //   	srl	$a1, $a1, 1
			9'h01d : dout <= 32'h00441020; //   	add	$v0, $v0, $a0
			9'h01e : dout <= 32'h14a0fffb; //   	bne	$a1, $zero, m_loop
			9'h01f : dout <= 32'h00042040; //   	sll	$a0, $a0, 1
			9'h020 : dout <= 32'h03e00008; //   	jr	$ra
			9'h021 : dout <= 32'h00000000; //   	nop
			default : dout <= 32'h0;
		endcase
	end
endmodule
