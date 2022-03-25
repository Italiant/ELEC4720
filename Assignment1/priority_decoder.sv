module prority6(input logic [7:0] a, output logic [8:0] b);

logic [4:0] e,f;

prority4 ins0(a[3:0], f[4:0]);
prority4 ins1(a[7:4], e[4:0]);

assign b[8:5] = e[4:1];
assign b[4:0] = f[4:0] & {5{e[0]}};

endmodule


module prority4(input logic [3:0] a, output logic [4:0] b);

logic [2:0] e,f;

prority2 ins0(a[1:0], f[2:0]);
prority2 ins1(a[3:2], e[2:0]);

assign b[4:3] = e[2:1];
assign b[2:0] = f[2:0] & {3{e[0]}};

endmodule


module prority2(input logic [1:0] a, output logic [2:0] b);

logic [1:0] e,f;

prority1 ins0(a[0], f);
prority1 ins1(a[1], e);

assign b[2] = e[1];
assign b[1:0] = f[1:0] & {2{e[0]}};

endmodule


module prority1(input logic a, output logic [1:0] b);

assign b[0] = ~a;
assign b[1] = a;

endmodule
