module behavioural_adder
	#(parameter n=2)
	(
	input logic [2**n-1:0] a,b,
	input logic cin,
	output logic [2**n-1:0] y,
	output logic cout
	);

	assign {cout,y} = a + b + cin;
	
endmodule
	