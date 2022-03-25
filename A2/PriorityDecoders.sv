module priority_1bit 
	(
	//single input bit a with 2 bit output y
	//y cannot be = 11
	input logic a,
	output logic [1:0] y
	);
	
	//a 1 bit priority decoder where the the MSB of y is = 1 when input is 1
	
	assign y[0] = ~a;
	assign y[1] = a;
	
endmodule





module priority_2bit
	
	/*
	2 bit priority decoder built using 2, 1 bit decoders
	*/
	(
	input logic [1:0] a,
	output logic [2:0] y
	);
	
	logic [1:0] e,f;
	
	priority_1bit decoder_e (a[1],e);
	priority_1bit decoder_f (a[0],f);
	
	assign y[2] = e[1];
	
	assign y[1] = e[0] & f[1];
	assign y[0] = e[0] & f[0];

	
endmodule





module priority_4bit 
	
	/*
	4bit priority decoder built using 2, 2 bit decoders.
	*/
	
	(
	input logic [3:0] a,
	output logic [4:0] y
	);
	
	logic [2:0] e,f;
	
	priority_2bit decoder_e (a[3:2],e);
	priority_2bit decoder_f (a[1:0],f);
	
	assign y[4:3] = e[2:1];
	assign y[2:0] = f[2:0] & {3{e[0]}};
	
endmodule
	
	
	
	
	
	
