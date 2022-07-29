`timescale 1ns/1ns

module io_seg(
	clk, rst, sel, d, qa, qb );
	
	input  clk;
	input  rst;
	output [ 3:0] sel;
	input  [31:0] d;
	output [ 7:0] qa, qb;
	
	wire   [ 3:0] sa, sb;
	
	seg_selecter ss( .clk(clk), .rst(rst), .sel(sel) );
	
	seg_register sra( .clk(clk), .rst(rst), .sel(sel), .din(d[31:16]), .dout(sa) );
	seg_register srb( .clk(clk), .rst(rst), .sel(sel), .din(d[15: 0]), .dout(sb) );
	
	seg_decoder sda( .clk(clk), .rst(rst), .val(sa), .seg(qa) );
	seg_decoder sdb( .clk(clk), .rst(rst), .val(sb), .seg(qb) );
	
endmodule

/*
 * 7セグメントLED選択回路
 *
 * 一定時間ごとに出力先の7セグメントLEDの選択信号を切り換える
 *
 */

module seg_selecter(
	clk, rst, sel );
	
	input  clk, rst;
	output [ 3:0] sel;
	
	reg    [ 3:0] sel;
	reg    [13:0] cnt;
	wire   max;
	
	assign max = ( cnt == 14'h3000 );
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			cnt <= 14'h1;
		end else if( cnt == max ) begin
			/* しきい値に達したらパルスを出力 */
			cnt <= 14'h1;
		end else begin
			/* カウントを繰り返す */
			cnt <= cnt + 14'h1;
		end
	end
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			sel <= 4'b0000;
		end else if( sel <= 4'b0000 ) begin
			sel <= 4'b1110;
		end else if( max == 1'b1 ) begin
			/* カウンタからのパルスで選択信号を変更 */
			sel <= { sel[2:0], sel[3] };
		end
	end
	
endmodule

/*
 * 7セグメントLED出力回路
 *
 * 7セグメントLEDに選択された表示パターンを出力する
 *
 */

module seg_register(
	clk, rst, sel, din, dout );
	
	input  clk, rst;
	input  [ 3:0] sel;
	input  [15:0] din;
	output [ 3:0] dout;
	
	reg    [ 3:0] dout;
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			dout <= 4'h0;
		end else begin
			case( sel )
				4'b1110: dout <= din[15:12];
				4'b1101: dout <= din[11: 8];
				4'b1011: dout <= din[ 7: 4];
				4'b0111: dout <= din[ 3: 0];
				default: dout <= 4'hx;
			endcase
		end
	end
	
endmodule

/*
 * 7セグメントLEDデコーダ
 *
 * 入力された値を7セグメントLEDの表示パターンにデコードする
 *
 */

module seg_decoder(
	clk, rst, val, seg );
	
	input  clk, rst;
	input  [3:0] val;
	output [7:0] seg;
	
	reg    [7:0] seg;
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			seg <= 8'h0;
		end else begin
			case( val )
				4'h0: seg <= 8'b11111100;
				4'h1: seg <= 8'b01100000;
				4'h2: seg <= 8'b11011010;
				4'h3: seg <= 8'b11110010;
				4'h4: seg <= 8'b01100110;
				4'h5: seg <= 8'b10110110;
				4'h6: seg <= 8'b10111110;
				4'h7: seg <= 8'b11100000;
				4'h8: seg <= 8'b11111110;
				4'h9: seg <= 8'b11110110;
				4'hA: seg <= 8'b11101110;
				4'hB: seg <= 8'b00111110;
				4'hC: seg <= 8'b00011010;
				4'hD: seg <= 8'b01111010;
				4'hE: seg <= 8'b10011110;
				4'hF: seg <= 8'b10001110;
				default: seg <= 8'hxx;
			endcase
		end
	end
	
endmodule
