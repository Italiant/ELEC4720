module ALU #(parameter n) (
input logic [(2**n)-1:0] A, B, input logic [3:0] F, output logic [(2**n)-1:0] Y, output logic Cout, OV
);

logic [(2**n)-1:0] S, tb, AUout, Y_mux;
logic OVs, OVu, SLT_0, SLT;

assign tb = F[1] ? ~B : B;

assign {Cout,S} = A + tb + F[1];

assign OVu = Cout ^ F[1];

assign OVs = (S[(2**n)-1] ^ A[(2**n)-1]) & ~(A[(2**n)-1] ^ tb[(2**n)-1]);

assign OV = F[0] ? OVu : OVs;

assign SLT_0 = OVs ? Cout : S[(2**n)-1];

assign SLT = F[0] ? ~Cout : SLT_0;

assign AUout = F[3] ? {{((2**n)-1){1'b0}}, SLT } : S;

mux4_n #(n) mux_ab(A, B, F[1:0], Y_mux);

assign Y = F[2] ? Y_mux : AUout;

endmodule
