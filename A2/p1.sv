// Template for the top level module for synthesizing and
// testing the designs on the DE2 board. It might be 
// convenient to keep this in a separate file, and 
// just instanciate the modules we design into this module
// as needed

module LectureCodes (
  input logic [17:0] SW,
  input logic [3:0] KEY,
  input logic CLOCK_27,
  input logic CLOCK_50,
  output logic [17:0] LEDR,
  output logic [8:0] LEDG,
  output logic [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7
);

  logic [31:0] q, inp, oup;
  logic clock;
  
  assign inp = {16'd0, SW[15:0]};
  assign {LEDR, LEDG[7:0]} = oup[25:0];

  // couter32 muclocks(CLOCK_50,q);
  // assign clock = q[25];     // Uncomment these lines and choose the appropriate bit of q if a slower clock is needed
  // assign LEDG[8] = clock;   // Can see the clock if it is slow enough
  
  assign clock = CLOCK_50;     // Comment this line if you want a slower clock
  
  cpu mycpu(clock,inp,oup);

endmodule

// This is a simple counter module, useful if we need a slow clock
module counter32 (
  input logic clk,
  output logic [31:0] q
);

  always_ff @(posedge clk)
    q <= q+1;

endmodule	 


// This is the CPU module implementing the processor
module cpu (
  input logic  clk,
  input logic  [31:0] inport,
  output logic [31:0] outport
);

  logic pc_carry, p, we, f, branch, jump, oe, im, must_jump;
  logic [4:0]  pc, pc_plus_one, pc_next, ra1, ra2, wa, jta, shamt;
  logic [34:0] instruction;
  logic [2:0] F;
  logic [31:0] rd1, rd2, wd, operand_b, result, addsubout, shfout, Const;
  
  always_ff @(posedge clk) begin
    pc <= pc_next;
	 if(oe) outport <= rd1;
  end	 
	 
  ROM #(5,35) myrom(pc,instruction);
  assign {pc_carry, pc_plus_one} = pc + 1;
  assign ra1 = instruction[4:0];
  assign ra2 = instruction[9:5];
  assign wa = instruction[14:10];
  assign jta = instruction[32:28];
  assign shamt = instruction[19:15];
  assign F = instruction[22:20];
  assign im = instruction[34];
  assign oe = instruction[26];
  assign p = instruction[25];
  assign jump = instruction[33];
  assign branch = instruction[27];
  assign f = instruction[24];
  assign we = instruction[23];
  assign Const = {16'd0, F[1], jta, shamt, ra2};
  
  assign pc_next = must_jump? jta : pc_plus_one;
  assign must_jump = jump | (branch & (rd1 == 32'd0));
  
  regfile myreg(clk, we, ra1, ra2, wa, wd, rd1, rd2);
  assign wd = p? result : inport;
  assign result = f? addsubout : shfout;
  assign operand_b = im? Const : rd2;
  
  addsub arith(rd1,operand_b,F[0],addsubout);
  shifter myshf(rd1,rd2,shamt,F,shfout);

  
  
endmodule  



//
//module ROM #(parameter m=7,w=4) (
//  input  logic [m-1:0] Ad,
//  output logic [w-1:0] Dout
//);
//  logic [w-1:0] mem[2**m-1:0];
//  assign Dout = mem[Ad];
//  
//  initial begin
//	 $readmemb("prog4.txt",mem); // Program is stored in binary at prog4.txt;   use $readmemh for hex format
//  end
//
//endmodule


module regfile(
  input logic clk, WE,
  input logic [3:0] RA1, RA2, RA3, WA,
  input logic [15:0] WD,
  output logic [15:0] RD1, RD2, RD3
);

  logic [15:0] rf[15:0];
  always_ff @(posedge clk)
    if (WE) rf[WA] <= WD;

  assign RD1 = rf[RA1];
  assign RD2 = rf[RA2];
  assign RD3 = rf[RA3];
  
  initial begin
	rf[0] = 16'b0101010101010101;
	rf[1] = 16'b0011001100110011;
	rf[2] = 16'b0001000100010001;
	rf[3] = 16'b1100110011001100;
	//$readmemb("reg.txt",rf);
  end

endmodule


module addsub (
  input logic [31:0] a,b,
  input logic s,
  output logic [31:0] c
);
  logic cout;
  logic [31:0] d;
  assign d = s? ~b : b;
  assign {cout,c} = a+d+s;

endmodule  

module core_shiftter(
  input logic [31:0] a,
  input logic [4:0] sh,
  input logic [2:0] F,
  output logic [31:0] y
);
  logic [31:0] yl, yh, ya, ym;
  assign yl = a << sh;
  assign yr = a >> sh;
  assign ya = $signed(a) >>> sh;
  assign ym = F[0]? yr : yl;
  assign y = F[1]? ya : ym;

endmodule

/*
module shifter(
  input logic [31:0] a,
  input logic [31:0] b,
  input logic [4:0] shamt,
  input logic [3:0] F,
  output logic [31:0] y
);
  logic [4:0] sh;
  core_shiftter csh(a,sh,F[1:0],y);
  assign sh = F[2]? b[4:0] : shamt; 

endmodule  
*/  
  
