module adder_subtractor
	#(parameter n=2)
	(
	input logic [2**n-1:0] a,b,
	input logic s,
	output logic [2**n-1:0] y
	);
	
	logic cin,cout;
	logic [2**n-1:0] g;
	
	assign g = s? ~b : b;
	
	behavioural_adder #(n) add0 (a,g,s,y,cout);
	
	
endmodule
	