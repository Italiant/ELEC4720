module multiply_8bit(input logic [3:0] a, input logic [3:0] b, output logic [7:0] c, output logic cout);

logic[2:0] carrybit;
logic[7:0] out1, out2;

adder_8bit lines1and2 ({4'd0, {4{b[0]}}&a}, {3'd0, {4{b[1]}}&a, 1'd0}, 0, out1, carrybit[0]);
adder_8bit lines3and4 ({2'd0, {4{b[2]}}&a, 2'd0}, {{4{b[3]}}&a, 4'd0}, carrybit[0], out2, carrybit[1]);

adder_8bit result (out1, out2, carrybit[1], c[7:0], cout);

endmodule
