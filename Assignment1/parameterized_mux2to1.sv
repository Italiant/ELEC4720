module parameterized_mux2to1
#(parameter n) (
input logic [(2**n)-1:0] d0, d1, input logic s,
output logic [(2**n)-1:0] y
);

assign y = s ? d1 : d0;

endmodule
