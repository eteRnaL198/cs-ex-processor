`timescale 1ns/1ns
`define STEP /* 命令の実行結果を見るとき */
`define SORT /* ソートの結果を見るとき */
module sim();
	wire en_hzd = 1'b1; /* ハザード検出 */
	wire en_fwd = 1'b1; /* フォワーディング */
	wire en_dly = 1'b1; /* 遅延分岐 */
	reg  clk, rst;
	wire data_hzd = mips.data_hzd;
	wire fwd_sel = |{mips.fwd_id_sel_a, mips.fwd_id_sel_b, mips.fwd_ex_sel_a, mips.fwd_ex_sel_b}; 
	wire ctrl_hzd = mips.ctrl_hzd;
	wire [31:0] pc0;
	wire [31:0] inst1;
	wire [31:0] alu_a, alu_b;
	wire [31:0] alu_q3;
	wire [31:0] ram_din3;
	wire [31:0] reg_din;
	wire [31:0] pc_din = mips.pc_din;
	wire [31:0] pc1 = mips.pc1;
	wire [31:0] pc2 = mips.pc2;
	wire [31:0] inst = mips.inst;
	wire [ 5:0] op = mips.op;
	wire [ 5:0] fn = mips.fn;
	wire [ 4:0] src_a = mips.src_a;
	wire [ 4:0] src_b = mips.src_b;
	wire [ 4:0] amt = mips.amt;
	wire [31:0] reg_a = mips.reg_a;
	wire [31:0] reg_b = mips.reg_b;
	wire [31:0] fwd_reg_a = mips.fwd_reg_a;
	wire [31:0] fwd_reg_b = mips.fwd_reg_b;
	wire [31:0] reg_a2 = mips.reg_a2;
	wire [31:0] reg_b2 = mips.reg_b2;
	wire [31:0] imm_val = mips.imm_val;
	wire [31:0] imm_val2 = mips.imm_val2;
	wire [31:0] fwd_alu_a = mips.fwd_alu_a;
	wire [31:0] fwd_alu_b = mips.fwd_alu_b;
	wire [31:0] alu_q4 = mips.alu_q4;
	wire [31:0] ram_dout = mips.ram_dout;
	wire [31:0] ram_dout4 = mips.ram_dout4;
	wire [ 4:0] dst = mips.dst;
	wire [ 4:0] dst2 = mips.dst2;
	wire [ 4:0] dst3 = mips.dst3;
	wire [ 4:0] dst4 = mips.dst4;
	wire halt;
	reg  halt2, halt3, halt4;
	
	mips mips(.clk(clk), .rst(rst), 
	          .pc0(pc0), .inst1(inst1), .alu_a(alu_a), .alu_b(alu_b), 
	          .alu_q3(alu_q3), .ram_din3(ram_din3), .reg_din(reg_din), 
	          .adrs(), .dout(), .din(32'h0), .rd(), .wr(), .halt(halt),
		  .en_hzd(en_hzd), .en_fwd(en_fwd), .en_dly(en_dly));
	
	initial begin
		$dumpfile("mips.vcd");
		$dumpvars(0, sim);
	end

	reg [19:0] cnt;
	always@(posedge clk) begin
		if(~rst) begin
			cnt <= 20'h0000;
		end else begin
			cnt <= cnt + 20'h1;
		end
	end
	initial begin
		clk = 1'b1;
		forever #10 clk = ~clk;
	end	
	initial begin
		rst = 1'b1;
		#13
		rst = 1'b0;
		#40
		rst = 1'b1;
	end
	always@(posedge clk) begin
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
`ifdef STEP
	initial begin
		$display(,,"cycle |  pc      |  inst    d f ra rb rd |  alu_a    alu_b   |  alu_q    ram_din | dst  reg_din");
	end	
	initial begin
		$monitor(,,"%x | %x | %x %b %b %d %d %d | %x %x | %x %x | %d  %x", 
		cnt, pc0, inst1, data_hzd, fwd_sel, src_a, src_b, dst, alu_a, alu_b, alu_q3, ram_din3, dst4, reg_din);
	end
`endif	
	integer i;
	always@(negedge clk) begin
		if(halt4 && mips.reg_file[2] == 5'd10) begin
`ifdef SORT
			for(i = 32'h0000>>2; i <= 32'h018c>>2; i = i + 1) begin
				$display(,,"ram[%2d]=%x", i, mips.ram_data[i]);
			end
`endif
			$display(,,"cycle = %d", cnt);
			$finish();
		end
	end
	
endmodule
