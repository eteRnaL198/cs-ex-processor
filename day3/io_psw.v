`timescale 1ns/1ns

module io_psw(
	clk, rst, 
	psw_a, psw_b, psw_c, psw_d, psw_out );
	
	input         clk, rst;
	input  [ 4:0] psw_a, psw_b, psw_c, psw_d;
	output [19:0] psw_out;
	
	wire          ld;
	wire   [19:0] psw_in;
	
	assign psw_in = { psw_d, psw_c, psw_b, psw_a };
	
	psw_pulse pp( .clk(clk), .rst(rst), .co(ld) );
	
	psw_detecter pd( .clk(clk), .rst(rst), .ld(ld), .psw_in(psw_in), .psw_out(psw_out) );
	
endmodule

/*
 * 周期パルス出力回路
 *
 * 周期5msのパルスを出力
 *
 */

module psw_pulse(
	clk, rst, co );
	
	input  clk, rst;
	output co;
	reg    [16:0] cnt;
	
	assign co = ( cnt == 17'd100000 );
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			cnt <= 17'h0;
		end else if( co == 1'b1 ) begin
			/* しきい値に達したらカウンタを初期化 */
			cnt <= 17'h1;
		end else begin
			/* カウントを繰り返す */
			cnt <= cnt + 17'h1; 
		end
	end
	
endmodule

/*
 * キー入力検出回路
 *
 * シフトレジスタでスイッチ入力を検出
 * 検出したら一定時間経過後にパルスを1回だけ出力
 *
 */

module psw_detecter(
	clk, rst, ld, psw_in, psw_out );
	
	input  clk, rst;
	input  ld;
	input  [19:0] psw_in;
	output [19:0] psw_out;
	
	reg    [19:0] psw_out;
	reg    [19:0] psw_val;
	reg    [ 1:0] dly;
	reg    [ 2:0] cnt;
	wire          max;
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			dly <= 2'b11;
		end else if( ld == 1'b1 ) begin
			/* シフトレジスタでスイッチ入力を検出 */
			dly <= { dly[0], &psw_in };
		end
	end
	
	assign max = &cnt;
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			cnt <= 3'h0;
			psw_val <= 20'h00000;
		end else if( dly[0] == 1'b1 ) begin /* 01 or 11 */
			/* スイッチ入力がなければカウント停止 */
			cnt <= 3'h0;
			psw_val <= 20'h00000;
		end else if( dly[1] == 1'b1 ) begin /* 10 */
			/* スイッチ入力を検出したらカウント開始 */
			cnt <= 3'h1;
			psw_val <= ~psw_in;
		end else if( max == 1'b1 ) begin
			/* しきい値に達したらカウント停止 */
			cnt <= 3'h0;
			psw_val <= 20'h00000;
		end else if( cnt != 3'h0 ) begin
			/* 停止状態でなければカウントを繰り返す */
			cnt <= cnt + 3'h1;
			psw_val <= psw_val;
		end
	end
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			psw_out <= 20'h00000;
		end else if( max == 1'b1 ) begin
			psw_out <= psw_val;
		end else begin
			psw_out <= 20'h00000;
		end
	end
	
endmodule
