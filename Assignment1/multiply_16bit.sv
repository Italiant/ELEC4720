module multiply_16bit(input logic [7:0] a, input logic [7:0] b, output logic [15:0] c);

logic stage1[3:0], stage2[1:0];

assign stage1[0] = 
{8'd0, a[7:0]*b[0]} +
{7'd0, a[7:0]*b[1], 1'd0};

assign stage1[1] = 
{6'd0, a[7:0]*b[2], 2'd0} +
{5'd0, a[7:0]*b[3], 3'd0};

assign stage2[0] = stage1[0] + stage1[1];

assign stage1[2] = 
{4'd0, a[7:0]*b[4], 4'd0} +
{3'd0, a[7:0]*b[5], 5'd0};

assign stage1[3] = 
{2'd0, a[7:0]*b[6], 6'd0} +
{1'd0, a[7:0]*b[7], 7'd0}; 

assign stage2[1] = stage1[2] + stage1[3]; 

assign c = stage2[0] + stage2[1];

endmodule
