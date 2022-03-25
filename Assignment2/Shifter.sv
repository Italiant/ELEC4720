module shifter
	#(parameter n=4)
	(
	input logic [2**n-1:0] a,
	input logic [n-1:0] Sh,
	input logic	[1:0] F,
	output logic [2**n-1:0] y
	);
	
	logic [2**n-1:0] e,f,g;
	
	assign e = a << Sh;
	assign f = a >> Sh;
	assign g = $signed(a) >>> Sh; //the arithmetic shifter acts the same as the right shift, need to fix

	assign y = F[1]? g : (F[0]? f:e);
	
endmodule

module MIPS_shifter
	(
	input logic [3:0] c,
	input logic [15:0] a,b,
	input logic [2:0] F,
	output logic [15:0] y
	);
	
	logic [3:0] Sh;
	
	assign Sh = F[2]? c : b[3:0];
	
	shifter shifter0 (a,Sh,F[1:0],y);
	
endmodule
