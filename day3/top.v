`timescale 1ns/1ns

module top(
	clk, clk2, rst,
	psw_a, psw_b, psw_c, psw_d, rtsw_a, rtsw_b, 
	dipsw_a, dipsw_b,
	bz, led, seg_a, seg_b, seg_sela, seg_selb, 
	seg_0, seg_1, seg_2, seg_3, seg_4, seg_5, seg_6, seg_7, seg_sel
	);
	
	input  clk, clk2, rst;
	input  [ 4:0] psw_a, psw_b, psw_c, psw_d;
	input  [ 3:0] rtsw_a, rtsw_b;
	input  [ 7:0] dipsw_a, dipsw_b;
	output bz;
	output [ 7:0] led;
	output [ 7:0] seg_a, seg_b;
	output [ 3:0] seg_sela, seg_selb;
	
	output [ 7:0] seg_0, seg_1, seg_2, seg_3, seg_4, seg_5, seg_6, seg_7;
	output [ 7:0] seg_sel;
	
	wire   [19:0] psw_out;
	wire   [ 7:0] bz_val;
	wire   bz_wr;
	wire   [ 3:0] seg_selab;
	wire   [31:0] val;
	wire   [31:0] cpu2seg, io2seg, state;
	
	wire   [31:0] adrs, io2cpu, cpu2io;
	wire   io_cs, io_rd, io_wr;
	wire   rd, wr;
	wire   cpu_clk;
	wire   run_mode, edit_mode;
	wire   [ 3:0] state_sel;
	wire   [31:0] key_reg;
	wire   pulse;
	wire   pwr;
	wire   halt;
	wire   en_dly, en_fwd, en_hzd;
	
	wire   [31:0] pc0, inst1, alu_a, alu_b, alu_q3, ram_din3, reg_din;
 	reg    [31:0] cnt;
	reg    halt2, halt3, halt4;
	
	assign en_hzd = dipsw_b[7];
	assign en_fwd = dipsw_b[6];
	assign en_dly = dipsw_b[5];
	
	key_control kc( .clk(clk), .rst(rst), .psw_out(psw_out), 
	                .run_mode(run_mode), .edit_mode(edit_mode), .pulse(pulse),
	                .key_reg(key_reg), .state_sel(state_sel), .pwr(pwr), .halt(halt2) );
	
	assign cpu_clk = (run_mode) ? clk2 : pulse;
	
	assign io_cs  = (adrs[31:8] == 24'h100180 & adrs[7:5] == 3'b000);
	assign io_rd  = io_cs & rd;
	assign io_wr  = io_cs & wr;
	
	mips mips(.clk(cpu_clk), .rst(rst), 
	          .pc0(pc0), .inst1(inst1), .alu_a(alu_a), .alu_b(alu_b),  
		  .alu_q3(alu_q3), .ram_din3(ram_din3), .reg_din(reg_din), 
	          .adrs(adrs), .dout(cpu2io), .din(io2cpu), .rd(rd), .wr(wr), .halt(halt),
		  .en_hzd(en_hzd), .en_fwd(en_fwd), .en_dly(en_dly) );
	
	io_port io_port( .clk(clk), .rst(rst), .adrs(adrs[4:2]), .din(cpu2io), .dout(io2cpu), 
	                 .rd(io_rd), .wr(io_wr), 
	                 .state_sel(state_sel), .segout(io2seg), .key_reg(key_reg), .pwr(pwr),
	                 .rtsw_a(rtsw_a), .rtsw_b(rtsw_b), .bz_val(bz_val), .bz_wr(bz_wr));
	
	io_psw io_psw( .clk(clk), .rst(rst), 
	               .psw_a(psw_a), .psw_b(psw_b), .psw_c(psw_c), .psw_d(psw_d), .psw_out(psw_out) );
	
	io_bz io_bz( .clk(clk), .rst(rst), .start(bz_wr), .val(bz_val), .bz(bz) );
	
	io_seg io_seg( .clk(clk), .rst(rst), .sel(seg_selab), .d(val), .qa(seg_a), .qb(seg_b) );
	assign seg_sela = seg_selab;
	assign seg_selb = seg_selab;
	
	assign val = (edit_mode) ? key_reg : state;
	
	assign state = 
	       (state_sel[3]) ? io2seg :
	       (state_sel[2:0] == 3'b000) ? pc0      :
	       (state_sel[2:0] == 3'b001) ? inst1    :
	       (state_sel[2:0] == 3'b010) ? alu_a    :
	       (state_sel[2:0] == 3'b011) ? alu_b    :
	       (state_sel[2:0] == 3'b100) ? alu_q3   :
	       (state_sel[2:0] == 3'b101) ? ram_din3 : 
	       (state_sel[2:0] == 3'b110) ? reg_din  : cnt;
	
	assign led = {edit_mode, run_mode, cpu_clk, ~rst, state_sel};
	
	assign seg_0 = 8'h0;
	assign seg_1 = 8'h0;
	assign seg_2 = 8'h0;
	assign seg_3 = 8'h0;
	assign seg_4 = 8'h0;
	assign seg_5 = 8'h0;
	assign seg_6 = 8'h0;
	assign seg_7 = 8'h0;
	assign seg_sel = 8'h0;

	always@(posedge cpu_clk or negedge rst) begin
		if(rst == 1'b0) begin
			cnt <= 32'h0;
		end else begin
			cnt <= cnt + 32'h1;
        	end
	end
	always@(posedge cpu_clk) begin
		if(~rst) begin
			halt2 <= 1'b0;
			halt3 <= 1'b0;
			halt4 <= 1'b0;
		end else begin
			halt2 <= halt;
			halt3 <= halt2;
			halt4 <= halt3;
		end
	end

endmodule
