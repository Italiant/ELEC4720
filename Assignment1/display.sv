module display(input logic [3:0] b, output logic [6:0] HEX);

//assign HEX0[6:0] = SW[3:0];
logic [3:0] SW;
assign SW[3] = b[0];
assign SW[2] = b[1];
assign SW[1] = b[2];
assign SW[0] = b[3];


assign HEX[6] = (~SW[0] & SW[1] & SW[2] & SW[3]) | (SW[0] & SW[1] & ~SW[2] & ~SW[3]) | (~SW[0] & ~SW[1] & ~SW[2]);

assign HEX[5] = (~SW[0] & ~SW[1] & SW[3]) | (~SW[0] & ~SW[1] & SW[2]) | (~SW[0] & SW[2] & SW[3]) | (SW[0] & SW[1] & ~SW[2] & SW[3]);

assign HEX[4] = (~SW[0] & SW[3]) | (~SW[1] & ~SW[2] & SW[3]) | (~SW[0] & SW[1] & ~SW[2]);

assign HEX[3] = (SW[1] & SW[2] & SW[3]) | (~SW[0] & ~SW[1] & ~SW[2] & SW[3]) | (~SW[0] & SW[1] & ~SW[2] & ~SW[3]) | (SW[0] & ~SW[1] & SW[2] & ~SW[3]);

assign HEX[2] = (SW[0] & SW[1] & ~SW[3]) | (SW[0] & SW[1] & SW[2]) | (~SW[0] & ~SW[1] & SW[2] & ~SW[3]);

assign HEX[1] = (SW[1] & SW[2] & ~SW[3]) | (SW[0] & SW[2] & SW[3]) | (SW[0] & SW[1] & ~SW[3]) | (~SW[0] & SW[1] & ~SW[2] & SW[3]);

assign HEX[0] = (~SW[0] & ~SW[1] & ~SW[2] & SW[3]) | (~SW[0] & SW[1] & ~SW[2] & ~SW[3]) | (SW[0] & ~SW[1] & SW[2] & SW[3]) | (SW[0] & SW[1] & ~SW[2] & SW[3]);


endmodule
