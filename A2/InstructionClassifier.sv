module instruction_classifier
	(
	input logic [5:0] a,
	output logic R,B1,J,B2,I,F,M
	);
	
	/*
	A MIPS instruction classifier using a fast tree structured design
	
	built using a 4 bit priority decoder and a 2 bit priority decoder
	*/
	
	logic [2:0] e;
	logic [4:0] f;
	
	priority_2bit decoder_e (a[5:4],e);
	priority_4bit decoder_f (a[3:0],f);
	
	assign {M,F} = e[2:1];
	
	assign {I,B2,J,B1,R} = f & {5{e[0]}};
	
endmodule
