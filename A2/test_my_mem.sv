// Structural module for RAM synthesis
// This provides a way to create asynchronous read in Cyclone 5 FPGAs
// This also simplifies the other memory synthesis issues in several other Intel FPGAs 


module test_my_mem(
	input logic [9:0] SW, 
	input logic [4:0] KEY,
	input logic CLOCK_50, 
	output logic [9:0] LEDR,
	output logic [7:0] LEDG,
	output logic [6:0] HEX0, HEX1, HEX2,HEX3
);

logic  [31:0] a;
logic  clk;
logic  [9:0] Din, Dout; 
logic  [3:0]  RAd, WAd;

always_ff@(posedge CLOCK_50) begin
	a <= a+1;
end	

assign clk = a[27];
assign Din = {8'd0, SW[3:0], 4'd0};

assign RAd = SW[7:4];
assign WAd = SW[7:4];

MyMemory #(10,4) mem(clk,RAd,WAd,Din,Dout);

assign LEDR = Dout; 
assign LEDG[0] = clk;

endmodule

// RAM/Reg file module
// One read port
// One write port
// Address width m
// Data width w
module MyMemory
#(parameter w=4, m=3) (
	input logic clk,
	input logic [m-1:0] RAd, WAd,
	input logic [w-1:0] Din,
	output logic [w-1:0] Dout
);
	logic [2**m-1:0] WEn;
	logic [w-1:0] Q[2**m-1:0];
	parameterized_decoder #(m) decw(WAd,WEn);
	assign Dout = Q[RAd];
	
	genvar k;
	generate
	for(k=0; k<2**m; k=k+1) begin: bloop
		EnabledReg #(w) itk(clk,WEn[k],Din,Q[k]);
	end
	endgenerate
		
endmodule


// RAM/Reg file module
// Two read ports
// One write port
// Address width m
// Data width w
module MyMemoryOneInputTwoOutput
#(parameter w=4, m=3) (
	input logic clk,
	input logic [m-1:0] RAd0, RAd1, WAd,
	input logic [w-1:0] Din,
	output logic [w-1:0] Dout0, Dout1
);
	logic [2**m-1:0] WEn;
	logic [w-1:0] Q[2**m-1:0];
	parameterized_decoder #(m) decw(WAd,WEn);
	assign Dout0 = Q[RAd0];
	assign Dout1 = Q[RAd1];
	
	genvar k;
	generate
	for(k=0; k<2**m; k=k+1) begin: bloop
		EnabledReg #(w) itk(clk,WEn[k],Din,Q[k]);
	end
	endgenerate
		
endmodule
	
// RAM/Reg file module
// Three read ports
// One write port
// Address width m
// Data width w
module MyMemoryOneInputThreeOutput
#(parameter w=4, m=3) (
	input logic clk,
	input logic [m-1:0] RAd0, RAd1, RAd2, WAd,
	input logic [w-1:0] Din,
	output logic [w-1:0] Dout0, Dout1, Dout2
);
	logic [2**m-1:0] WEn;
	logic [w-1:0] Q[2**m-1:0];
	parameterized_decoder #(m) decw(WAd,WEn);
	
	assign Dout0 = Q[RAd0];
	assign Dout1 = Q[RAd1];
	assign Dout2 = Q[RAd2];
	
	//for loading data into reg file manaully for testing
	initial begin
//		Q[0] = 0101010101010101;
//		Q[1] = 0011001100110011;
//		Q[2] = 16'b0001_0001_0001_0001;
//		Q[3] = 16'b1100_1100_1100_1100;
	//	$readmemb("reg.txt",Q);
	end
	
	
	genvar k;
	generate
	for(k=0; k<2**m; k=k+1) begin: bloop
		EnabledReg #(w) itk(clk,WEn[k],Din,Q[k]);
	end
	endgenerate
		
endmodule

	
module EnabledReg
#(parameter w=3) (
	input logic clk, en,
	input logic [w-1:0] D,
	output logic [w-1:0] Q
);
	always @(posedge clk) 
		if(en) Q <= D;

endmodule

		
module parameterized_decoder
#(parameter n=3) (
	input logic [n-1:0] a,
	output logic [2**n-1:0] y
);
	parameter w = 2**n;
	always_comb begin
		y = {w{1'b0}};
		y[a] = 1'b1;
	end
endmodule
	
