module MUX_with_tri_state 
	#(parameter n=16)
	(
	input logic [n-1:0] d0, d1,
	input logic s,
	output tri [3:0] y
	);
	tristate_active_lo t0(d0,s,y);
	tristate_active_hi t1(d1,s,y);
endmodule

module tristate_active_hi 
	#(parameter n=16)
	(
	input logic [n-1:0] a,
	input logic en,
	output tri [n-1:0] y
	);
	
	assign y = en? a : 16'bz;
endmodule

module tristate_active_lo 
	#(parameter n=16)
	(
	input logic [n-1:0] a,
	input logic en,
	output tri [n-1:0] y
	);
	
	assign y = en? 16'bz : a;
endmodule

