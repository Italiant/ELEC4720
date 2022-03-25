module fullAdder (
	input logic a, b, cin,
	output logic s, cout
);
	
	
	logic g;
	logic p;
	assign g = a & b;
	assign p = a ^ b;
	assign s = p ^ cin;
	assign cout = g | (p & cin);
	
endmodule



module adder4Bit (
	input logic [3:0] a, b,
	input logic cin,
	output logic [3:0] s,
	output logic cout
);


logic [2:0] p;
	fullAdder add0 (a[0],b[0],cin,s[0],p[0]);
	fullAdder add1 (a[1],b[1],p[0],s[1],p[1]);
	fullAdder add2 (a[2],b[2],p[1],s[2],p[2]);
	fullAdder add3 (a[3],b[3],p[2],s[3],cout);

endmodule



module adder8Bit (
	input logic [7:0] a, b,
	input logic cin,
	output logic [7:0] s,
	output logic cout
);


logic [6:0] p;
	fullAdder add8_0 (a[0],b[0],cin,s[0],p[0]);
	fullAdder add8_1 (a[1],b[1],p[0],s[1],p[1]);
	fullAdder add8_2 (a[2],b[2],p[1],s[2],p[2]);
	fullAdder add8_3 (a[3],b[3],p[2],s[3],p[3]);
	fullAdder add8_4 (a[4],b[4],p[3],s[4],p[4]);
	fullAdder add8_5 (a[5],b[5],p[4],s[5],p[5]);
	fullAdder add8_6 (a[6],b[6],p[5],s[6],p[6]);
	fullAdder add8_7 (a[7],b[7],p[6],s[7],cout);

endmodule

module adder16Bit (
	input logic [15:0] a,b,
	input logic cin,
	output logic [15:0] s,
	output logic cout
	);
	
	
	logic p;
	
	adder8Bit adder8_0 (a[7:0],b[7:0],cin,s[7:0],p);
	adder8Bit adder8_1 (a[15:8],b[15:8],p,s[15:8],cout);
	
endmodule
	
