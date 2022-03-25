module branch_decision (
	input logic B1,B2,
	input logic [5:0] opcode,
	input logic [15:0] rs, rt,
	output logic branch
	);
	
	logic bltz,bgez,beq,bne,blez,bgtz,branch1,branch2,mux_out;
	
	//assign beq = ~(|(rs^rt));
	
	//assign bne = |(rs^rt);
	
	//assign blez = rs[15] | ~(|rs);
	
	//assign bgtz = ~(rs[15] | ~(|rs));
	
	assign branch1 = (opcode[0] ^ rs[15]) & B1;
	
	assign beq_or_bne = (~(|(rs^rt))) ^ opcode[0];
	
	assign blez_or_bgtz = (rs[15] | ~(|rs)) ^ opcode[0];
	
	assign mux_out = (opcode[1])? blez_or_bgtz : beq_or_bne;
	
	assign branch2 = mux_out & B2;
	
	assign branch = branch1 | branch2;

endmodule	