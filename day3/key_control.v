`timescale 1ns/1ns

module key_control(
	clk, rst, psw_out, run_mode, edit_mode, pulse,
	key_reg, state_sel, pwr, halt
);
	input  clk, rst;
	input  [19:0] psw_out;
	output run_mode, edit_mode;
	output pulse;
	output [31:0] key_reg;
	output [ 3:0] state_sel;
	output pwr;
	input  halt;
	
	reg    run_mode, edit_mode;
	reg    [22:0] pulse_cnt;
	reg    pulse;
	reg    [ 4:0] key_code;
	reg    [31:0] key_reg;
	reg    key_clr;
	reg    [ 3:0] state_sel;
	reg    pwr;
	
	/* キーの番号を値に変換 */
	always@(posedge clk or negedge rst) begin
		if(~rst) begin
			key_code <= 5'h1F;
		end else begin
			case(psw_out)
				/* 数値キー */
				20'h00001 : key_code <= 5'h0;
				20'h00002 : key_code <= 5'h1;
				20'h00004 : key_code <= 5'h2;
				20'h00008 : key_code <= 5'h3;
				20'h00020 : key_code <= 5'h4;
				20'h00040 : key_code <= 5'h5;
				20'h00080 : key_code <= 5'h6;
				20'h00100 : key_code <= 5'h7;
				20'h00400 : key_code <= 5'h8;
				20'h00800 : key_code <= 5'h9;
				20'h01000 : key_code <= 5'hA;
				20'h02000 : key_code <= 5'hB;
				20'h08000 : key_code <= 5'hC;
				20'h10000 : key_code <= 5'hD;
				20'h20000 : key_code <= 5'hE;
				20'h40000 : key_code <= 5'hF;
				/* ファンクションキー */
				20'h00010 : key_code <= 5'h10;
				20'h00200 : key_code <= 5'h11;
				20'h04000 : key_code <= 5'h12;
				20'h80000 : key_code <= 5'h13;
				default :   key_code <= 5'h1F;
			endcase
		end
	end
	
	/* 動作/停止モードの切替 */
	reg [1:0] halt_reg;
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0) begin
			halt_reg <= 2'b00;
		end else begin
			halt_reg <= {halt_reg[0], halt}; /* haltの立ち上がりを検出 */
		end
	end
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			run_mode <= 1'b0;
		end else if(halt_reg == 1'b1) begin
			run_mode <= 1'b0;
		end else if(~edit_mode) begin              /* 観測モードなら */
			if( key_code == 5'h13 || key_code == 5'h11 ) begin
				run_mode <= 1'b0;                  /* D4キー、B4キーなら停止モードに設定 */
			end else if( key_code == 5'h10 ) begin /* A4キーなら */
				run_mode <= ~run_mode;             /* 動作/停止モードを反転 */
			end
		end
	end
	
	/* パルスを出力(観測モード、停止モード時) */
	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			pulse_cnt <= 23'h0;
		end else if( ~edit_mode & ~run_mode ) begin        /* 観測モードで停止モードなら */
			if((key_code == 5'h13) ) begin                 /* D4キーなら */
				pulse_cnt <= 23'h1;                        /* カウンタ開始 */
			end else if(pulse_cnt == 23'd5000000) begin   /* カウンタの最大値なら */
				pulse_cnt <= 23'h0;                        /* カウンタ停止 */
			end else if(pulse_cnt != 23'h0) begin          /* カウント停止でなければ */
				pulse_cnt <= pulse_cnt + 1'b1;             /* カウンタをインクリメント */
			end
		end
	end
	always@(posedge clk or negedge rst) begin
		if( rst == 1'b0 ) begin
			pulse <= 1'b0;
		end else begin
			pulse <= |pulse_cnt; /* パルスを出力 */
		end
	end
	
	/* 編集/観測モードの切替 */
	always@( posedge clk or negedge rst ) begin
		if( rst == 1'b0 ) begin
			edit_mode <= 1'b0;             /* 最初は観測モード */
		end else if( key_code == 5'h11 ) begin /* B4キーなら */
			edit_mode <= ~edit_mode;       /* 編集/観測モードを反転 */
		end
	end
		
	/* IOポートのアドレスを設定 */
	always@(posedge clk or negedge rst) begin
		if( rst == 1'b0 ) begin
			state_sel <= 4'h0;
		end else if(key_code == 5'h11) begin
			state_sel <= 4'h0; /* B4キーならリセット */
		end else if(edit_mode) begin /* 編集モードなら */
			if(key_code == 5'h12) begin /* C4キーなら　*/
				if(state_sel[3] | state_sel[2] | (&state_sel[1:0])) begin
					state_sel <= 4'h0;             /* 3以上ならリセット */
				end else begin
					state_sel <= state_sel + 1'b1; /* それ以外ならインクリメント */
				end
			end 
		end else begin              /* 観測モードなら */
			if(key_code == 5'h12) begin         /* C4キーなら */
				if((state_sel[3] | ~state_sel[3] & (&state_sel[2:0]))) begin
					state_sel <= 4'h0;             /*  7以上ならリセット */
				end else begin
					state_sel <= state_sel + 1'b1; /* それ以外ならインクリメント */
				end
			end else if(~key_code[4]) begin
				state_sel <= key_code[3:0]; /* 数値キーなら値をセット */
			end
		end
	end
	
	/* 数値を1桁ずつ最下位桁から順に入力 */
	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			key_reg <= 32'h0;
			key_clr <= 1'b0;
		end else if(key_code == 5'h10 || key_code == 5'h11) begin
			key_clr <= 1'b1;       /* A4キー、B4キーならクリア信号出力 */
		end else if(key_clr) begin
			key_reg <= 32'h0;      /* 値をクリア */
			key_clr <= 1'b0;       /* クリア信号をリセット */
		end else if(edit_mode) begin                       /* 編集モードなら */
			if(key_code == 5'h13) begin                    /* D4キーなら */
				key_reg <= {4'h0, key_reg[31:4]};          /* 1桁削除 */
			end else if(~key_code[4]) begin                /* 数値キーなら */
				key_reg <= {key_reg[27:0], key_code[3:0]}; /* 1桁追加 */
			end
		end
	end
	
	/* I/Oレジスタ書き込み信号を出力 */
	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			pwr <= 1'b0;
		end else if(edit_mode) begin    /* 編集モードなら */
			if(key_code == 5'h10) begin /* A4キーなら */
				pwr <= 1'b1;            /* 書き込み */
			end else begin
				pwr <= 1'b0;
			end
		end else begin
			pwr <= 1'b0;
		end
	end	

endmodule
