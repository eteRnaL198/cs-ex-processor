`timescale 1ns/1ns

module io_bz(
	clk, rst, 
	start, val, bz );
	
	input  clk;
	input  rst;
	input  start;
	input  [7:0] val;
	output bz;
	
	wire   enable, pitch;
	
	bz_time bt( .clk(clk), .rst(rst), .start(start), .val(val[7:4]), .enable(enable) );
	bz_pitch bp( .clk(clk), .rst(rst), .val(val[3:0]), .pitch(pitch) );
	
	assign bz = enable & pitch;
	
endmodule

/*
 * 音程生成回路
 *
 * 入力値に応じた周波数のピッチ信号を出力
 *
 */

module bz_pitch( 
	clk, rst, val, pitch );
	
	input  clk, rst;
	input  [3:0] val;
	output pitch;
	reg    pitch;
	reg    [15:0] cnt;
	reg    [15:0] cref;
	wire   max, zero;
	
	/* 入力値に応じてカウンタのしきい値を設定 */
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin	
			cref <= 16'hFFFF;
		end else begin
			case( val )                     /*        Hz */
				4'b0000: cref <= 16'hFFFF;  /* R    0.00 */
				4'b0001: cref <= 16'd38223; /* C  261.62 */
				4'b0010: cref <= 16'd34053; /* D  293.66 */
				4'b0011: cref <= 16'd30338; /* E  329.62 */
				4'b0100: cref <= 16'd28635; /* F  349.22 */
				4'b0101: cref <= 16'd25511; /* G  391.99 */
				4'b0110: cref <= 16'd22727; /* A  440.00 */
				4'b0111: cref <= 16'd20248; /* B  493.88 */
				4'b1000: cref <= 16'd19111; /* C  523.25 */
				4'b1001: cref <= 16'd17026; /* D  587.32 */
				4'b1010: cref <= 16'd15169; /* E  659.25 */
				4'b1011: cref <= 16'd14317; /* F  698.45 */
				4'b1100: cref <= 16'd12755; /* G  783.99 */
				4'b1101: cref <= 16'd11364; /* A  880.00 */
				4'b1110: cref <= 16'd10124; /* B  987.76 */
				4'b1111: cref <= 16'd09556; /* C 1046.50 */
				default: cref <= 16'hFFFF;
			endcase
		end
	end
	
	assign max = ( cnt == cref );
	assign zero = ( val == 4'h0 );
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			cnt <= 16'h0;
		end else if( zero == 1'b1 ) begin
			/* 入力値が0の場合はカウンタを停止 */
			cnt <= 16'h0;
		end else if( max == 1'b1 ) begin
			/* しきい値に達したらカウンタを初期化 */
			cnt <= 16'h1;
		end else begin
			/* カウントを繰り返す */
			cnt <= cnt + 16'h1; 
		end
	end
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			pitch <= 1'b0;
		end else if( zero == 1'b1 ) begin
			/* 入力値が0の場合はピッチ信号を停止 */
			pitch <= 1'b0;
		end else if( max == 1'b1 ) begin
			/* カウンタからのパルスでピッチ信号を反転 */
			pitch <= ~pitch;
		end
	end
	
endmodule

/*
 * 音価生成回路
 *
 * トリガ入力の立ち上がりから
 * 入力値に応じた長さのイネーブル信号を出力
 */

module bz_time(
	clk, rst, start, val, enable );
	
	input clk, rst;
	input start;
	input [3:0] val;
	output enable;
	reg    [ 1:0] dly;
	reg    [23:0] cnt;
	reg    [23:0] cref;
	wire   max;
	
	/* 入力値に応じてカウンタのしきい値を設定 */
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			cref <= 24'd0;
		end else begin
			case( val )                        /* sec */
				4'b0000: cref <= 24'd01000000; /* 0.1 */
				4'b0001: cref <= 24'd02000000; /* 0.2 */
				4'b0010: cref <= 24'd03000000; /* 0.3 */
				4'b0011: cref <= 24'd04000000; /* 0.4 */
				4'b0100: cref <= 24'd05000000; /* 0.5 */
				4'b0101: cref <= 24'd06000000; /* 0.6 */
				4'b0110: cref <= 24'd07000000; /* 0.7 */
				4'b0111: cref <= 24'd08000000; /* 0.8 */
				4'b1000: cref <= 24'd09000000; /* 0.9 */
				4'b1001: cref <= 24'd10000000; /* 1.0 */
				4'b1010: cref <= 24'd11000000; /* 1.1 */
				4'b1011: cref <= 24'd12000000; /* 1.2 */
				4'b1100: cref <= 24'd13000000; /* 1.3 */
				4'b1101: cref <= 24'd14000000; /* 1.4 */
				4'b1110: cref <= 24'd15000000; /* 1.5 */
				4'b1111: cref <= 24'd16000000; /* 1.6 */
				default: cref <= 24'd0;
			endcase
		end
	end
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			dly <= 2'b00;
		end else begin
			/* トリガ入力の立ち上がりを検出 */
			dly <= { dly[0], start };
		end
	end
	
	assign max = ( cnt == cref );
	assign enable = ( cnt != 24'h0 );
	
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			cnt <= 24'd0;
		end else if( dly == 2'b10 ) begin
			/* トリガ入力を検出したらカウンタの動作開始 */
			cnt <= 24'd1;
		end else if( max == 1'b1 ) begin
			/* しきい値に達したらカウンタの動作停止 */
			cnt <= 24'd0;
		end else begin
			/* カウンタが停止するまでイネーブル信号を立ち上げる */
			cnt <= cnt + enable;
		end
	end
	
endmodule
