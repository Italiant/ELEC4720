module multiply_divide
	#(parameter n=3)
	(
	input logic clk,
	input logic [3:0] F,
	input logic [n-1:0] a,b,
	output logic [n-1:0] y
	);
	
	//a circuit 
	
	logic [n-1:0] H,L,R,Q,hi,lo;
	
	logic [2:0] s;
	logic [1:0] en;
	
	control_signals control0 (F[3:0],s[2:0],en[1:0]);
	

	assign {H,L} = a*b;
	
	assign Q = a/b;
	assign R = a%b;
	
	
	logic [n:0] muxo0,muxo1,muxo2,muxo3;
	
	assign muxo0 = s[0]? R : H;
	assign muxo1 = s[0]? Q : L;
	
	assign muxo2 = s[1]? muxo0 : a;
	assign muxo3 = s[1]? muxo1 : a;
	
	
	always_ff @(posedge clk) begin
	
		if(en[0]) hi <= muxo2;
		if(en[1]) lo <= muxo3;
	
	end
	
	assign y = s[2]? lo : hi;
	
endmodule


module control_signals
	(
	input logic [3:0] F,
	output logic [2:0] s,
	output logic [1:0] en
	);
	
	assign s[0] = F[1];
	assign s[1] = F[3] & ~F[0];
	assign s[2] = F[1];
	
	assign en[0] = F[3] | (F[0] & ~F[1]);
	assign en[1] = F[3] | (F[0] & F[1]);
	
endmodule
