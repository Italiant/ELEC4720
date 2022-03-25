module multiplier_8_bit (
	input logic [7:0] a,b,
	output logic [15:0] s
	);
	
	logic [15:0] in0, in1, in2, in3, in4, in5, in6, in7, p0, p1, p2, p3, q0, q1;
	
	multiplier_inputs_8_bit inputs (a,b,in0,in1,in2,in3,in4,in5,in6,in7);
	
	logic cin;
	assign cin = 0;
	
	logic [6:0] cout;
	
	//need to ask about whether carries should be included
	
	adder16Bit add0 (in0,in1,cin,p0,cout[0]);
	adder16Bit add1 (in2,in3,cin,p1,cout[1]);
	adder16Bit add2 (in4,in5,cin,p2,cout[2]);
	adder16Bit add3 (in6,in7,cin,p3,cout[3]);
	
	adder16Bit add4 (p0,p1,cin,q0,cout[4]);
	adder16Bit add5 (p2,p3,cin,q1,cout[5]);
	
	adder16Bit add6 (q0,q1,cin,s,cout[6]);
	
	
endmodule


module multiplier_inputs_8_bit(
		input logic [7:0] a,b,
		output logic [15:0] in0,in1,in2,in3,in4,in5,in6,in7
		);
		
	 logic [7:0] p0,p1,p2,p3,p4,p5,p6,p7;
	 
	 assign p0 = a & {8{b[0]}};
	 assign p1 = a & {8{b[1]}};
	 assign p2 = a & {8{b[2]}};
	 assign p3 = a & {8{b[3]}};
	 assign p4 = a & {8{b[4]}};
	 assign p5 = a & {8{b[5]}};
	 assign p6 = a & {8{b[6]}};
	 assign p7 = a & {8{b[7]}};
	 
	 assign in0 = {8'd0, p0};
	 assign in1 = {7'd0, p1, 1'd0};
	 assign in2 = {6'd0, p2, 2'd0};
	 assign in3 = {5'd0, p3, 3'd0};
	 assign in4 = {4'd0, p4, 4'd0};
	 assign in5 = {3'd0, p5, 5'd0};
	 assign in6 = {2'd0, p6, 6'd0};
	 assign in7 = {1'd0, p7, 7'd0};
	
endmodule
		
		