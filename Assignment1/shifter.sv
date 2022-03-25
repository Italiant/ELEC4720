module shifter
#(parameter n)(
input logic [(2**n)-1:0] A, input logic [n-1:0] Sh, input logic [1:0] F, output logic [(2**n)-1:0] Y
);

logic [(2**n)-1:0] D0, D1, D2, D3;

assign D0 = A << Sh;
assign D1 = A >> Sh;
assign D2 = A;
assign D3 = $signed(A) >>> Sh;

logic [(2**n)-1:0] lo, hi;

parameterized_mux2to1 #(n) lomux (D0, D1, F[0], lo);
parameterized_mux2to1 #(n) himux (D2, D3, F[0], hi);
parameterized_mux2to1 #(n) oumux (lo, hi, F[1], Y);

endmodule
