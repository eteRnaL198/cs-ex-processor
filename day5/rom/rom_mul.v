`timescale 1ns/1ns
module rom(adrs, dout);
	input  [ 8:0] adrs;
	output [31:0] dout;
	reg    [31:0] dout;
	
	always@(adrs) begin
		case(adrs)
			9'h000 : dout <= 32'h2011000d; //   	addi  $s1, $zero, 13
			9'h001 : dout <= 32'h2012000b; //   	addi  $s2, $zero, 11
			9'h002 : dout <= 32'h72324002; //   	mul   $t0, $s1  , $s2
			9'h003 : dout <= 32'h2402000a; //   	li	$v0,	10		# プログラムの終了
			9'h004 : dout <= 32'h0000000c; //   	syscall
			default : dout <= 32'h0;
		endcase
	end
endmodule
