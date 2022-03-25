module logic_unit 
	#(parameter n=2)
	(
	input logic [n-1:0] a,b,
	input logic [1:0] f,
	output logic [n-1:0] y
	);
	
	logic [n-1:0] d0,d1,d2,d3;
	
	assign d0 = a & b;
	assign d1 = a | b;
	assign d2 = a ^ b;
	assign d3 = ~(a | b);
	
	mux_4_to_1 #(n) logic_mux (d0,d3,d2,d1,f,y);
	
endmodule
	
	