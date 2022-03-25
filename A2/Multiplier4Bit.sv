module multiplier_4_bit(
	input logic [3:0] a, b,
	output logic [7:0] z);
	
	logic [7:0] in0, in1, in2, in3;
	
	multiplier_inputs_4_bit inputs (a[3:0],b[3:0],in0[7:0],in1[7:0],in2[7:0],in3[7:0]);
	
	logic [7:0] p,g;
	
	//need to ask about whether carries should be included
	
	adder8Bit add0 (in0[7:0],in1[7:0],0,g[7:0],0);
	adder8Bit add1 (in2[7:0],in3[7:0],0,p[7:0],0);
	adder8Bit add2 (g[7:0],p[7:0],0,z[7:0],0);
	
	
	
endmodule

module multiplier_inputs_4_bit	(
	input logic [3:0] a, b,
	output logic [7:0] w, x, y, z);

	logic [3:0] h,i,j,k;
	
	assign h = a & {4{b[0]}};
	assign w = {4'd0, h[3:0]};

	assign i = a & {4{b[1]}};
	assign x = {3'd0,i[3:0],1'd0};
	
	assign j = a & {4{b[2]}};
	assign y = {2'd0,j[3:0],2'd0};
	
	assign k = a & {4{b[3]}};
	assign z = {1'd0,k[3:0],3'd0};
	
endmodule	