module mux4_n
#(parameter n) (
input logic [(2**n)-1:0] a, b, input logic [1:0] F, output logic [(2**n)-1:0] Y
);

logic [(2**n)-1:0] D0, D1, D2, D3;

assign D0 = a & b;
assign D1 = a | b;
assign D2 = a ^ b;
assign D3 = ~(a | b);

logic [(2**n)-1:0] lo, hi;
parameterized_mux2to1 #(n) lomux (D0, D1, F[0], lo);
parameterized_mux2to1 #(n) himux (D2, D3, F[0], hi);
parameterized_mux2to1 #(n) oumux (lo, hi, F[1], Y);

endmodule

module mux2_n
#(parameter n) (
input logic [(2**n)-1:0] A, B, input logic S, output logic [(2**n)-1:0] Y
);

logic [(2**n)-1:0] tb;

assign tb = S ? ~B : B;

assign Y = A + tb + S;

endmodule
