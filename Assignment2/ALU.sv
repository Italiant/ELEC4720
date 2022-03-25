module ALU
	#(parameter n=8)
	(
	input logic [n-1:0] a,b,
	input logic [3:0] F,
	output logic [n-1:0] y,
	output logic OV
	);
	
	logic cout;
	logic [2:0] s;
	logic [n-1:0] g,add_out,SLT_out,AUout,logic_out;
	
	assign s = {~F[3],F[1],F[0]};
	
	
	assign g = s[1]? ~b : b;
	
	//call to the adder block
	assign {cout,add_out} = a + g + s[1];
	
	//call to the overflow detection block
	overflow_detection overflow (a[n-1],g[n-1],add_out[n-1],cout,s[1:0],OV,OVs);
	
	//call to the SLT block
	set_less_than #(n) SLT (OVs,cout,s[0],add_out,SLT_out);
	
	//call to the logic unit block
	logic_unit #(n) logic_u (a,b,F[1:0],logic_out);
	
	
	assign AUout = s[2]? add_out : SLT_out;
	
	assign y = F[2]? logic_out : AUout;
	
	

endmodule 



module overflow_detection
//a module that takes the n-1th bit of the inputs and output of adder, as well as cout and control bits s1 and s0
//to detect if an overflow has occured. 
//returns OV = 1 if true

	(
	input logic a,g,add_out,cout,
	input logic [1:0] s,
	output logic OV,OVs
	);
	
	logic OVu;
	
	assign OVs = (add_out ^ a) & ~(a ^ g);
	assign OVu = cout ^ s[1];
	
	assign OV = s[0]? OVu : OVs;
	
endmodule


module set_less_than


	#(parameter n=8)
	(
	input logic OVs,cout,s0,
	input logic [n-1:0] add_out,
	output logic [n-1:0] set_less_out
	);
	
	logic g;
	logic [n-1:0] h;
	
	assign g = s0? ~cout : (OVs? cout : add_out[n-1]);
	
	assign set_less_out = { {(n-1){1'b0}},g };



endmodule
	