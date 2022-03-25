module multiply_divide
#(parameter n)(
input logic [n-1:0] a, b, input logic clk, input logic [3:0] F, output logic [n-1:0] y, out_hi, out_lo
);

logic [n-1:0] H, L, R, Q, hi, lo, out1, out2;
logic en1, en2;

assign {out_hi,out_lo}={hi,lo};

assign en1 = (F[3] | (~F[1] & F[0])) & ~F[2];
assign en2 = (F[3] | ( F[1] & F[0])) & ~F[2];

assign {H, L} = a * b;
assign R = a % b;
assign Q = a / b;

assign out1 = F[1] ? R : H;
assign out2 = F[1] ? Q : L;

always_ff @(posedge clk)
begin
	if(en1) hi <= F[3] ? out1 : a;
	if(en2) lo <= F[3] ? out2 : a;
end
	
assign y = F[1] ? lo : hi;

endmodule
