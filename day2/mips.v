`timescale 1ns/1ns

module mips(clk, rst, pc0, inst1, alu_a, alu_b, alu_q3, ram_din3, reg_din, 
            adrs, dout, din, rd, wr, halt, en_hzd, en_fwd, en_dly);
/*************************
 Input & Output
*************************/
	input         clk, rst;
	output [31:0] pc0;
	output [31:0] inst1;
	output [31:0] alu_a, alu_b;
	output [31:0] alu_q3;
	output [31:0] ram_din3;
	output [31:0] reg_din;
	output [31:0] adrs, dout;
	input  [31:0] din;
	output        rd, wr;
	output        halt;
	input         en_hzd;
	input         en_fwd;
	input         en_dly;
/*************************
 Wires & Registers 
*************************/
	/* Program Counter */
	wire [ 1:0] pc_sel;
	wire [31:0] pc_next, pc_jump, pc_reg, pc_brn;
	wire [31:0] pc_din;
	reg  [31:0] pc0, pc1, pc2;
	/* Instruction Memory (ROM) */
	wire        rom_cs;
	wire [31:0] rom_data;
	wire [31:0] inst;
	reg  [31:0] inst1;
	/* No Oeration */
	reg         nop1;
	/* Instruction Decode */
	wire [ 5:0] op, fn;
	/* Register Read */
	wire [ 4:0] src_a, src_b;
	reg  [31:0] reg_file[0:31];
	wire [31:0] reg_a,  reg_b;
	reg  [31:0] reg_a2, reg_b2;
	/* Immediate Data */
	wire [31:0] imm_val;
	reg  [31:0] imm_val2;
	/* Data Hazard & Control Hazard */
	wire data_hzd, ctrl_hzd;
	/* Forwarding */
	wire        fwd_id_sel_a, fwd_id_sel_b;
	wire [31:0] fwd_reg_a, fwd_reg_b;
	wire [ 1:0] fwd_ex_sel_a, fwd_ex_sel_b;
	reg  [ 1:0] fwd_ex_sel_a2, fwd_ex_sel_b2;
	wire [31:0] fwd_alu_a, fwd_alu_b;
	/* ALU */
	wire [ 2:0] alu_sel;
	reg  [ 2:0] alu_sel2;
	wire [ 1:0] op_sel;
	reg  [ 1:0] op_sel2;
	wire        src_sel_b;
	reg         src_sel_b2;
	reg  [31:0] alu_q3;
	/* Data Memory (RAM) */
	wire        ram_cs;
	wire        ram_rd,  ram_wr;
	reg         ram_rd2, ram_wr2;
	reg         ram_rd3, ram_wr3;
	reg         ram_rd4;
	reg  [31:0] ram_din3;
	reg  [31:0] ram_data[0:8191];
	wire [31:0] ram_dout;
	/* Register Write */
	wire        reg_wr;
	reg         reg_wr2, reg_wr3, reg_wr4;
	wire [ 4:0] dst;
	reg  [ 4:0] dst2, dst3, dst4;
	reg  [31:0] ram_dout4, alu_q4;

/*************************
 IF Stage
*************************/
	
	/* Program Counter */
	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			pc0 <= 32'h00400000;
		end else if(~data_hzd) begin
			pc0 <= pc_din;
		end
	end
	/* Instruction Memory (ROM) */
	/* range: 00400000 : 004007FF */
	assign rom_cs = (pc0[31:11] == 21'h800);
	rom rom(.adrs(pc0[10:2]), .dout(rom_data));
	assign inst = (rom_cs) ? rom_data : 32'h0;
	
/*************************
 IF/ID Pipeline Registers
*************************/
	
	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			inst1 <= 32'h0;
		end else if (~data_hzd) begin
			if (ctrl_hzd) begin
				inst1 <= 32'h0;
			end else begin
				inst1 <= inst;
			end
		end
	end
	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			nop1 <= 1'b1;
		end else begin
			nop1 <= 1'b0;
		end
	end
	always@(posedge clk) begin
		pc1 <= pc_next;
	end
	
	
/*************************
 ID Stage
*************************/
	
	/* Instruction Decode */
	assign op  = inst1[31:26];
	assign fn  = inst1[ 5: 0];
	
	/* op: (00) R-format */
	wire i_rfmt   = (op == 6'b000000);
	/* op: (02) j */
	wire i_j      = (op == 6'b000010);
	/* op: (03) jal */
	wire i_jal    = (op == 6'b000011);
	/* op: (04) beq, (05) bne */
	wire i_brn = (op[5:1] == 5'b00010);
	/* op: (08) addi, (09) addiu */
	/* fn: (20) add,  (21) addu */
	wire i_add    = (op[5:1] == 5'b00100)
	              | (fn[5:1] == 5'b10000) & i_rfmt;
	/* op: (0A) slti, (0B) sltiu */
	/* fn: (2A) slt,  (2B) sltu */
	wire i_comp   = (op[5:1] == 5'b00101)
	              | (fn[5:1] == 5'b10101) & i_rfmt;
	/* op: (0B) andi, (0C) ori, (0D) xori */
	/* fn: (24) and,  (25) or,  (26) xor, (27) nor */
	wire i_logic  = (op[5:2] == 4'b0011 ) & (op[1:0] != 2'b11)
	              | (fn[5:2] == 4'b1001 ) & i_rfmt;
	/* op: (0F) lui */
	wire i_lui    = (op == 6'b001111);
	/* op: (23) lw */
	wire i_lw     = (op == 6'b100011);
	/* op: (53) sw */
	wire i_sw     = (op == 6'b101011);
	/* fn: (00) sll, (02) srl, (03) sra */
	wire i_shift  = (fn[5:2] == 4'b0000 ) & (fn[1:0] != 2'b01) & i_rfmt;
	/* fn: (08) jr */
	wire i_jr     = (fn == 6'b001000) & i_rfmt;
	/* fn: (0B) syscall */
	wire i_syscall = (fn[5:0] == 6'b001100) & i_rfmt;
	/* fn: (22) sub, (23) subu */
	wire i_sub    = (fn[5:1] == 5'b10001) & i_rfmt;
	/* CPU Halt */
	assign halt = i_syscall;
	
	/* Source Register Numbers */
	assign src_a = inst1[25:21];
	assign src_b = (i_rfmt | i_brn | i_sw) ? inst1[20:16] : 5'h0;
	/* Destination Register Number */
	assign dst = (i_jal)  ? 5'b11111 : (i_rfmt) ? inst1[15:11] 
		   : (reg_wr) ? inst1[20:16] : 5'h0;
	
	/* Register Read Data */
	assign reg_a = (src_a == 5'h0) ? 32'h0 : reg_file[src_a];
	assign reg_b = (src_b == 5'h0) ? 32'h0 : reg_file[src_b];
	
	/* Immediate Data */
	assign imm_val[15: 0] = inst1[15:0];
	assign imm_val[31:16] = (i_logic) ? {16{1'b0}} : {16{inst1[15]}};
	
	/* Program Counter */
	wire   brn_taken = i_brn & (op[0] ^ (fwd_reg_a == fwd_reg_b));
	assign pc_next = pc0 + 32'h4;
	assign pc_jump = {pc0[31:28], inst1[25:0], 2'h0};
	assign pc_reg  = (fwd_id_sel_a) ? alu_q3 : reg_a;
	assign pc_brn  = pc0 + {imm_val[29:0], 2'h0};
	/* 00: pc_next, 01: pc_jump, 10: pc_reg, 11: pc_brn */
	assign pc_sel[0]  = (brn_taken | i_j  | i_jal);
	assign pc_sel[1]  = (brn_taken | i_jr);
	wire   [31:0] pc_din0 = (pc_sel[0]) ? pc_jump : pc_next;
	wire   [31:0] pc_din1 = (pc_sel[0]) ? pc_brn  : pc_reg;
	assign pc_din = (pc_sel[1]) ? pc_din1 : pc_din0;
	
	/* Data Dependency */
	wire id_ex_a  = reg_wr2 & (dst2 != 5'h0) & (dst2 == src_a);
	wire id_ex_b  = reg_wr2 & (dst2 != 5'h0) & (dst2 == src_b);
	wire ex_mem_a = reg_wr3 & (dst3 != 5'h0) & (dst3 == src_a);
	wire ex_mem_b = reg_wr3 & (dst3 != 5'h0) & (dst3 == src_b);
	wire id_ex   = id_ex_a  | id_ex_b;
	wire ex_mem  = ex_mem_a | ex_mem_b;
	
	/* Data Hazard */
	wire   alu_hzd  = ~en_fwd  & (id_ex | ex_mem);
	wire   ram_hzd  = ram_rd2  & id_ex;
	wire   brn_hzd  = (i_brn | i_jr) & (id_ex | ram_rd3 & ex_mem);
	assign data_hzd = en_hzd & (alu_hzd | ram_hzd | brn_hzd);

	/* Control Hazard */
	assign ctrl_hzd  = ~en_dly & (brn_taken | i_j | i_jal | i_jr);

	/* Forwarding */
	assign fwd_id_sel_a    = en_fwd & ~data_hzd & (i_brn | i_jr) & ex_mem_a;
	assign fwd_id_sel_b    = en_fwd & ~data_hzd & (i_brn | i_jr) & ex_mem_b;
	assign fwd_ex_sel_a[0] = en_fwd & ~data_hzd & id_ex_a;
	assign fwd_ex_sel_b[0] = en_fwd & ~data_hzd & id_ex_b;
	assign fwd_ex_sel_a[1] = en_fwd & ~data_hzd & ex_mem_a;
	assign fwd_ex_sel_b[1] = en_fwd & ~data_hzd & ex_mem_b;

	assign fwd_reg_a = (fwd_id_sel_a) ? alu_q3 : reg_a;
	assign fwd_reg_b = (fwd_id_sel_b) ? alu_q3 : reg_b;

	/* Control Sygnals */
	/* 001: addsub, 010: jal, 011: lui, 100: logic, 101: shift, 110: comp */
	assign alu_sel[0] = i_lui   | i_shift | i_add | i_sub | i_lw | i_sw;
	assign alu_sel[1] = i_lui   | i_comp  | i_jal;
	assign alu_sel[2] = i_shift | i_comp  | i_logic;

	assign op_sel = (i_rfmt) ? fn[1:0] : op[1:0];
	assign src_sel_b = i_rfmt;
	assign ram_rd  = i_lw;
	assign ram_wr  = i_sw;
	assign reg_wr  = i_add | i_sub   | i_lw    | i_jal
	               | i_lui | i_logic | i_shift | i_comp;
	
/*************************
 ID/EX Pipeline Registers
*************************/
	
	always@(posedge clk) begin
		pc2      <= (data_hzd) ? 32'h0 : (en_dly) ? pc1 + 32'h4 : pc1;
		reg_a2   <= (data_hzd) ? 32'h0 : fwd_reg_a;
		reg_b2   <= (data_hzd) ? 32'h0 : fwd_reg_b;
		imm_val2 <= (data_hzd) ? 32'h0 : imm_val;
		alu_sel2 <= (data_hzd) ? 3'h0  : alu_sel;
		op_sel2  <= op_sel;
		ram_rd2  <= ram_rd;
		src_sel_b2    <= src_sel_b;
		fwd_ex_sel_a2 <= fwd_ex_sel_a;
		fwd_ex_sel_b2 <= fwd_ex_sel_b;
	end
	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			ram_wr2 <= 1'b0;
			reg_wr2 <= 1'b0;
			dst2 <= 5'h0;
		end else if (nop1) begin
			ram_wr2 <= 1'b0;
			reg_wr2 <= 1'b0;
			dst2 <= 5'h0;
		end else begin
			ram_wr2 <= (data_hzd) ? 1'b0 : ram_wr;
			reg_wr2 <= (data_hzd) ? 1'b0 : reg_wr;
			dst2    <= (data_hzd) ? 5'h0 : dst;
		end
	end
		
/*************************
 EX Stage
*************************/
	/* Forwarding Data*/
	assign fwd_alu_a = (fwd_ex_sel_a2[0]) ? alu_q3
	        	 : (fwd_ex_sel_a2[1]) ? reg_din : reg_a2;
	assign fwd_alu_b = (fwd_ex_sel_b2[0]) ? alu_q3
	                 : (fwd_ex_sel_b2[1]) ? reg_din : reg_b2;

	/* ALU Input Data */
	assign alu_a = fwd_alu_a;
	assign alu_b = (src_sel_b2) ? fwd_alu_b : imm_val2;
	
	/* Jump and Link */
	wire [31:0] dpc  = pc2;
	/* Load Upper Immediate */
	wire [31:0] dlui  = {imm_val2[15:0], 16'h0};
	/* Shift */
	wire [ 4:0] amt = imm_val2[10:6];
	wire        si  = (op_sel2[0]) ? alu_b[31] : 1'b0;
	wire [31:0] sl0 = (amt[0]) ? {alu_b[30:0], { 1{1'b0}}} : alu_b;
	wire [31:0] sl1 = (amt[1]) ? {  sl0[29:0], { 2{1'b0}}} : sl0;
	wire [31:0] sl2 = (amt[2]) ? {  sl1[27:0], { 4{1'b0}}} : sl1;
	wire [31:0] sl3 = (amt[3]) ? {  sl2[23:0], { 8{1'b0}}} : sl2;
	wire [31:0] dsl = (amt[4]) ? {  sl3[15:0], {16{1'b0}}} : sl3;
	wire [31:0] sr0 = (amt[0]) ? {{ 1{si}},  alu_b[31: 1]} : alu_b;
	wire [31:0] sr1 = (amt[1]) ? {{ 2{si}},    sr0[31: 2]} : sr0;
	wire [31:0] sr2 = (amt[2]) ? {{ 4{si}},    sr1[31: 4]} : sr1;
	wire [31:0] sr3 = (amt[3]) ? {{ 8{si}},    sr2[31: 8]} : sr2;
	wire [31:0] dsr = (amt[4]) ? {{16{si}},    sr3[31:16]} : sr3;
	wire [31:0] dshift = (op_sel2[1]) ? dsr : dsl;
	/* Add & Sub */
	wire        sgn_a   = (op_sel2[0]) ? 1'b0 : alu_a[31];
	wire        sgn_b   = (op_sel2[0]) ? 1'b0 : alu_b[31];
	wire [32:0] dadd    = {sgn_a, alu_a} + {sgn_b, alu_b};
	wire [32:0] dsub    = {sgn_a, alu_a} - {sgn_b, alu_b};
	wire        addsub_sel = (~op_sel2[1] | ram_rd2 | ram_wr2);
	wire [31:0] daddsub = (addsub_sel) ? dadd[31:0] : dsub[31:0];
	/* Logic */
	wire [31:0] dand = alu_a & alu_b;
	wire [31:0] dor  = alu_a | alu_b;
	wire [31:0] dxor = alu_a ^ alu_b;
	wire [31:0] dnor = ~dor;
	/* 00: and, 01: or, 10: xor, 11: nor */
	wire [31:0] and_or  = (op_sel2[0]) ? dor  : dand;
	wire [31:0] xor_nor = (op_sel2[0]) ? dnor : dxor;
	wire [31:0] dlogic =  (op_sel2[1]) ? xor_nor : and_or;
	/* Set on Less Than */
	wire [31:0] dslt = {31'h0, dsub[32]};

/*************************
 EX/MEM Pipeline Registers
*************************/
	
	always@(posedge clk) begin
		case(alu_sel2)
			3'b001: alu_q3 <= daddsub;
			3'b010: alu_q3 <= dpc;
			3'b011: alu_q3 <= dlui;
			3'b100: alu_q3 <= dlogic;
			3'b101: alu_q3 <= dshift;
			3'b110: alu_q3 <= dslt;
			default: alu_q3 <= 32'h0;
		endcase
	end
	always@(posedge clk) begin
		ram_din3 <= fwd_alu_b;
		ram_rd3  <= ram_rd2;
	end
	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			ram_wr3  <= 1'b0;
			reg_wr3  <= 1'b0;
			dst3    <= 5'h0;
		end else begin
			ram_wr3  <= ram_wr2;
			reg_wr3  <= reg_wr2;
			dst3    <= dst2;
		end
	end
	
	assign adrs = alu_q3;
	assign dout = ram_din3;
	assign rd   = ram_rd3;
	assign wr   = ram_wr3;
	
/*************************
 MEM Stage
*************************/
	
	/* Data Memory (RAM) */
	assign ram_cs = (alu_q3[31:15] == 17'h2002);
	always@(posedge clk) begin
		if(ram_wr3 & ram_cs) begin
			ram_data[alu_q3[14:2]] <= ram_din3;
		end
	end
	assign ram_dout = (ram_rd3 & ram_cs) ? ram_data[alu_q3[14:2]] : 32'hxxxxxxxx;
	
/*************************
 MEM/WB Pipeline Registers
*************************/
	always@(posedge clk) begin
		alu_q4    <= (ram_rd3 & ~ram_cs) ? din : alu_q3;
		ram_dout4 <= ram_dout;
		ram_rd4   <= ram_rd3 & ram_cs;
		dst4      <= dst3;
	end
	always@(posedge clk or negedge rst) begin
		if(rst == 1'b0) begin
			reg_wr4  <= 1'b0;
		end else begin
			reg_wr4  <= reg_wr3;
		end
	end
	
/*************************
 WB Stage
*************************/
	/* Register Write Data */
	assign reg_din = (ram_rd4) ? ram_dout4 : alu_q4;
 	/* Register File */
	always@(negedge clk) begin
		if(reg_wr4 & dst4 != 5'h0) begin
			reg_file[dst4] <= reg_din;
		end
	end
	
endmodule 
