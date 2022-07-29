`timescale 1ns/1ns

module io_port(
	clk, rst, 
	adrs, din, dout, rd, wr, 
	state_sel, segout, key_reg, pwr,
	rtsw_a, rtsw_b, bz_val, bz_wr);
	
	input  clk, rst;
	input  [ 2:0] adrs;
	input  [31:0] din;
	output [31:0] dout;
	input  rd, wr;
	input  [ 3:0] state_sel;
	output [31:0] segout;
	input  [31:0] key_reg;
	input  pwr;
	input  [ 3:0] rtsw_a;
	input  [ 3:0] rtsw_b;
	output [ 7:0] bz_val;
	output bz_wr;
	
	reg    [31:0] io_data[0:7];
	reg           bz_wr;
	reg    [ 2:0] mar;
	reg    [31:0] mdr;
	reg           wer;
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			io_data[0] <= 32'h0;
			io_data[1] <= 32'h0;
			io_data[2] <= 32'h0;
			io_data[3] <= 32'h0;
			io_data[4] <= 32'h0;
			io_data[5] <= 32'h0;
			io_data[6] <= 32'h0;
			io_data[7] <= 32'h0;
			bz_wr <= 1'b0;
		end else begin
			io_data[4] <= {28'h0, rtsw_a};
			io_data[5] <= {28'h0, rtsw_b};
			io_data[6] <= {{28{rtsw_a[3]}}, rtsw_a};
			io_data[7] <= {{28{rtsw_b[3]}}, rtsw_b};
			if( wer ) begin
				io_data[mar] <= mdr;
				bz_wr <= (mar == 3'b011);
			end else begin
				bz_wr <= 1'b0;
			end
		end
	end
	always@(posedge clk) begin
		mar <= (wr) ? adrs : state_sel[2:0];
		mdr <= (wr) ? din : key_reg;
		wer <= wr | pwr;
	end
	
	assign dout = ( rd == 1'b1 ) ? io_data[adrs] : 32'h0;
	assign bz_val = io_data[3][7:0];
	assign segout = io_data[state_sel[2:0]];
	
endmodule
