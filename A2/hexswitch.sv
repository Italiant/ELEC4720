module Pr2(input logic [9:0] SW, output logic [6:0] HEX0);

	assign HEX0[6:0] = SW[6:0];
	
endmodule
