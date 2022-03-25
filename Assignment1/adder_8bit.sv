module adder_8bit (
input logic [7:0] a, b,
input logic cin,
output logic [7:0] s,
output logic cout
);

logic [6:0] p;
fulladder add0 (a[0],b[0],cin,s[0],p[0]); 
fulladder add1 (a[1],b[1],p[0],s[1],p[1]);
fulladder add2 (a[2],b[2],p[1],s[2],p[2]);
fulladder add3 (a[3],b[3],p[2],s[3],p[3]);
fulladder add4 (a[4],b[4],p[3],s[4],p[4]);
fulladder add5 (a[5],b[5],p[4],s[5],p[5]);
fulladder add6 (a[6],b[6],p[5],s[6],p[6]);
fulladder add7 (a[7],b[7],p[6],s[7],cout);

endmodule
