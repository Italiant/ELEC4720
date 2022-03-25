module Pr2(
	input logic [9:0] SW,
	input logic [4:0] KEY,
	input logic CLOCK,
	output logic [6:0] HEX3, HEX2, HEX0, HEX1,
	output logic [9:0] LEDR,
	output logic [7:0] LEDG
	);
	
//-------------------------------------------------- Debugging ---------------------------------------------------

		assign RA3 = SW[3:0];
	//	assign LEDR = SW[9:0];
		assign LEDR[9:8] = SW[9:8];
	//	assign LEDR[3:0] = SW[3:0];
		assign LEDR[5:0] = pc;
		
		// Memory Test
//		hexEncoder hex0 (RD[3:0], HEX0);
//		hexEncoder hex1 (RD[7:4], HEX1);
//		hexEncoder hex2 (RD[11:8], HEX2);
//		hexEncoder hex3 (RD[15:12], HEX3);
		
		// To read registers - where the address for RD3 is controlled using SW[3:0] 
//		hexEncoder hex0 (RD3[3:0], HEX0);
//		hexEncoder hex1 (RD3[7:4], HEX1);
//		hexEncoder hex2 (RD3[11:8], HEX2);
//		hexEncoder hex3 (RD3[15:12], HEX3);
		
		// Jump Test
//		hexEncoder hex0 (pc[3:0], HEX0);
//		hexEncoder hex1 ({2'b0,pc[5:4]}, HEX1);
//		hexEncoder hex2 (pc_next[3:0], HEX2);
//		hexEncoder hex3 ({2'b0,pc_next[5:4]}, HEX3);

		// Branch Test
//		hexEncoder hex0 (pc[3:0], HEX0);
//		hexEncoder hex1 ({2'b0,pc[5:4]}, HEX1);
//		hexEncoder hex2 (pc_next[3:0], HEX2);
//		hexEncoder hex3 ({2'b0,pc_next[5:4]}, HEX3);
//		LEDG[7] = branch;
		
	//the EN_init switch is used to initialize values into the register for testing
	assign EN_init = SW[8];
	always_comb begin
		if (EN_init) begin
			WD = SW[7:4];
			WA = SW[3:0];
		end else begin
			WD = WDI;
			WA = WAI;
		end
	end
	
// --------------------------------------------------- CLOCK -----------------------------------------------------
	
	//clock, use q for slower clock. CLOCK is 50MHz
	always_ff@(posedge CLOCK) begin
		if (!CLK_EN) q <= q+1;
	end	
	assign CLK_USED = q[25];
	assign WE = 0;
	assign LEDG[0] = CLK_USED;
	assign CLK_EN = SW[9];
	
// --------------------------------------------------- CPU ------------------------------------------------------

	logic [31:0] q;
	logic [15:0] RD1,RD2,RD3,WD,WDI,WDI_1;
	logic [3:0] RA1,RA2,RA3,WA,WAI,WAI_1,WAR;
	logic CLK_USED, WE, EN;
	
	//assign WD = SW[7:4];
	
	// --------- Instruction Set ----------
	
	logic [17:0] instruction;
	logic [11:0] addr,JTA_1,JTA,BTA,JTA_2;
	logic [5:0] opcode;
	logic [5:0] pc;
	logic [3:0] imm, Funct;
	logic [1:0] jumpF;
	logic we,OV,jump,jump1;
  
	//reads instruction from the rom file, (program counter input, instruction output)
   ROM #(6,18) myrom(pc[5:0],instruction); 
 
	//instruction decoding
	assign opcode = instruction[17:12];
	assign RA1 = instruction[11:8];
	assign RA2 = instruction[7:4];
	assign WAR = instruction[3:0]; //denoted WAI to differentiate between instruction and initialization write address
	assign imm = instruction[3:0];
	assign jumpF = instruction[11:10];
	assign addr = instruction[9:0];
	//assign WE = 1; 
	
	//war = rd
	//ra2 = rt
	//ra1 = rs
	
	// ------------------------------------------------- Register --------------------------------------------------
	
	//currently using 3 outputs (RD) for testing. parametrized for #(16 bit data, 4 bit address)

	MyMemoryOneInputThreeOutput #(16,4) reg_test(CLK_USED, RA1, RA2, RA3, WA, WD, RD1, RD2, RD3);
	
	assign WAI_1 = (R)? WAR : RA2; //if executing an R-type instruction, use rd as the write address; otherwise use rt
	assign WAI = (jump)? 4'b1111 : WAI_1;//
	
	assign WDI_1 = (jump & opcode[0])? pc_plus_one : R_out;
	
	assign WDI = (M)? RD : WDI_1;	

	// -------------------------------------------- PC + Jump + Branch ---------------------------------------------
	
	logic pc_carry,branch;
	logic [5:0] pc_plus_one, pc_next;
	assign pc_plus_one = pc + 1;
	
	assign jump = (R & EN_except) | J;
	assign jump1 = R;
	
	assign JTA = addr;
	
	assign JTA_1 = (jump1)? RD1 : JTA;
	
	assign JTA_2 = (jump)? JTA_1 : pc_plus_one;
	
	assign pc_next = (branch)? BTA : JTA_2;
	
	//Branching Instructions
	//branch decision logic
	branch_decision branchmodule (B1,B2, opcode, RD1, RD2, branch);
	
	assign BTA = pc_plus_one + SignImm;
	
	always_ff @ (posedge CLK_USED) begin
		if (!EN_init) pc <= pc_next;
	end

// -------------------------------------------- R-Type Instructions --------------------------------------------
	
	logic ALUSrc0, ALUSrc1, ALUSrc2;
	logic [2:0] shift_Funct;
	logic [3:0] ALU_Funct_1, ALU_Funct, mul_Funct;
	logic [15:0] ALU_out,mul_out,shift_out,operand_b,mux_out1,mux_out0;
		
	//subclassifier
	logic EN_shift, EN_ALU, EN_mul, EN_except;
	priority_2bit R_declassifier (opcode[4:3], {EN_ALU,EN_mul,EN_shift});
	
	assign EN_except = ~(opcode[3] | opcode[2]) & ~opcode[4];
	
	//ALU paramterized for 16bit operations, this section includes ALU datapath logic
	assign ALU_Funct_1 = (opcode[3] & opcode[2])? 4'b0101 : opcode[3:0];	
	
	assign ALU_Funct = (M)? 0 : ALU_Funct_1;
		
	//control logic for the multiplexers used to determine operand b of the ALU
	assign ALUSrc0 =  opcode[3]|(opcode[0]&opcode[1]);
	assign ALUSrc1 = opcode[2] & I;
	assign ALUSrc2 = ~R; 
	
	//mux hardware used to determine operand b of the ALU
	assign operand_b = (ALUSrc2)? mux_out1 : RD2;
	assign mux_out1 = (ALUSrc1)? mux_out0 : SignImm;
	assign mux_out0 = (ALUSrc0)? CompImm : ZeroImm;
		
	ALU #(16) ALU_unit(RD1,operand_b,ALU_Funct,ALU_out, OV);
		
	//mul/div parametrized for 16bit
	assign mul_Funct = {opcode[2],1'b0,opcode[1:0]};	
	multiply_divide #(16) multi (CLK_USED,mul_Funct,RD1,RD2,mul_out);
		
	//shifter parametrized for 16bit (2**n)
	assign shift_Funct = opcode[1:0];
	shifter	#(4) shft(RD2,RD1[3:0],shift_Funct,shift_out);
		
	//tri-state buffers used to switch between correct output
	logic EN_tri_ALU, EN_tri_shf, EN_tri_mul;
	
	assign EN_tri_ALU = I |(R & EN_ALU);
	assign EN_tri_shf = R & EN_shift;
	assign EN_tri_mul = R & EN_mul;
	
	tri [15:0] R_out;
	
	tristate_active_hi triALU (ALU_out, EN_tri_ALU, R_out);
	tristate_active_hi trishf (shift_out, EN_tri_shf, R_out);
	tristate_active_hi trimul (mul_out, EN_tri_mul, R_out);

// -------------------------------------------- I-Type Instructions --------------------------------------------
	
	//hardware for choosing how to manipulate the constant Imm
	logic [15:0] SignImm, CompImm, ZeroImm, Comp1,Comp2,Comp3, Comp_temp;
	
	assign SignImm = {{12{imm[3]}},imm};
	assign ZeroImm = {12'b0,imm};
	
	assign Comp1 = {~imm,{12{1'b1}}};
	assign Comp2 = {4'b0,imm,8'b0};
	assign Comp3 = {8'b0,imm,4'b0};
	
	assign Comp_temp = opcode[0]? Comp1 : Comp3;
	assign CompImm = opcode[1]? Comp_temp : Comp2;

// -------------------------------------------------- Memory ---------------------------------------------------	
	
	logic[15:0]  MemIn_1, MemIn, MOut, WB0, WB1, RD_1, RD_2, RD_3, RD, SignB0, ZeroB0, SignB1, ZeroB1;
	//logic[2:0] S;
	logic [5:0] Address;
	logic MemEn;

	assign MemEn = opcode[2] & M;

	assign Address = RD1 + SignImm;

	assign WB0 = {MOut[15:8], RD2[7:0]};
	assign WB1 = {RD2[7:0], MOut[15:8]};

	assign MemIn_1 = (Address[0])? WB1 : WB0;

	assign MemIn = (opcode[0])? RD2 : MemIn_1;

	assign SignB0 = {{8{MOut[7]}}, MOut[7:0]};
	assign SignB1 = {{8{MOut[15]}}, MOut[15:8]};

	assign ZeroB0 = {8'b0, MOut[7:0]};
	assign ZeroB1 = {8'b0, MOut[15:8]};

	assign RD_1 = (opcode[1])? ZeroB0 : SignB0;

	assign RD_2 = (opcode[1])? ZeroB1 : SignB1;

	assign RD_3 = (Address[0])? RD_2 : RD_1;

	assign RD = (opcode[0])? MOut : RD_3;

	RAM #(6,16) myram(Address[5:1], MemIn, CLK_USED, MemEn, MOut);

// --------------------------------------------- Priority Decoder ----------------------------------------------	
		
	//the concatenation of the input is to use existing hardware design (the 7 bit decoder already built)
	logic J,B1,B2,M,I,F,R;
	instruction_classifier priority_instruction({1'b0,opcode[5:1]},J,B1,B2,M,I,R,F); //F is not used in our design
	
	//test for priority decoder
	assign LEDG[6:1] = {J,B1,B2,M,I,R};
	
endmodule

// --------------------------------------------------- ROM -----------------------------------------------------

module ROM #(parameter m=7,w=4) (
  input  logic [m-1:0] Ad,
  output logic [w-1:0] Dout
);
  logic [w-1:0] mem[2**m-1:0];
  assign Dout = mem[Ad];
  
  initial begin
	 $readmemb("jump_test.txt",mem); // Program is stored in binary at prog4.txt; use $readmemh for hex format
  end

endmodule

// --------------------------------------------------- RAM -----------------------------------------------------

module RAM #(parameter N=5, W=8)(
  input logic [N-1:0] Ad,
  input logic [W-1:0] Din,
  input logic Clk, En,
  output logic [W-1:0] Dout
  );
  
	logic [W-1:0] array[2**N-1:0];
	assign Dout = array[Ad];
	
	always_ff @ (posedge Clk)
	if(En) array[Ad] <= Din;
	
endmodule
