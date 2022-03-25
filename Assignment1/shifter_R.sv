module shifter_R
#(parameter n)(
input logic [(2**n)-1:0] A, B, input logic [n-1:0] C, input logic [2:0] F, output logic [(2**n)-1:0] Y
);

logic [n-1:0] Sh;

assign Sh = F[2] ? B[n-1:0] : C;

shifter #(n) s1(A, Sh, F[1:0], Y);

endmodule
