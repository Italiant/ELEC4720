module Project(input logic [9:0] SW, input logic [3:0] KEY, output logic [7:0] LEDG, output logic [9:0] LEDR, output logic [6:0] HEX0, HEX1, HEX2, HEX3);

// Auto switching clock by slowing down cpu speed 
//logic clk;
//logic [31:0] a;
//always_ff @(posedge clk)
//	a <= a+1;
	
//a[26]; // slow auto clock based on CPU speed, higher values are slower   

// ------------------------ Question 9 ------------------------

/*

parameter n = 2;
logic [(2**n)-1:0] Y;
logic Cout, OV;

assign LEDR = SW;

display h0(SW[3:0], HEX0);
display h1(SW[7:4], HEX1);

assign LEDG[7:4] = ~KEY[3:0];

ALU #(n) a1(SW[3:0], SW[7:4], ~KEY[3:0], Y, Cout, OV);

assign LEDG[0] = Cout;
assign LEDG[1] = OV;

display h3(Y, HEX3);

*/

// ------------------------ Question 8 ------------------------

/*

parameter n = 2;
logic [3:0] outputs;

display disp_a({2'b0,SW[1:0]}, HEX0);
display disp_b({2'b0,SW[3:2]}, HEX1);

multiply_divide #(n) mul_div1(SW[1:0], SW[3:2], KEY[0], SW[9:6], LEDG[1:0], outputs[1:0], outputs[3:2]); 

display disp_hi({2'b0,outputs[1:0]}, HEX3);
display disp_lo({2'b0,outputs[3:2]}, HEX2);

*/

// ------------------------ Question 7 ------------------------

/*

parameter n = 2;

logic [3:0] A;
assign A = 4'b1001;
assign LEDR[3:0] = A;

shifter_R #(n) sr(A, SW[3:0], SW[5:4], SW[9:7], LEDG[3:0]);

*/

// ------------------------ Question 6 ------------------------

//prority6 ins0(SW[7:0], LEDR[8:0]);

// ------------------------ Question 5 ------------------------

/*

parameter n = 2;

logic [(2**n)-1:0] Y;

display a(SW[3:0], HEX0);
display b(SW[7:4], HEX1);

mux2_n #(n) mux_ab(SW[3:0], SW[7:4], SW[8], Y);

display y(Y, HEX3);

*/

// ------------------------ Question 4 ------------------------

/*

parameter n = 2;

logic [(2**n)-1:0] Y;

display a(SW[3:0], HEX0);
display b(SW[7:4], HEX1);

mux4_n #(n) mux_ab(SW[3:0], SW[7:4], SW[9:8], Y);

display y(Y, HEX3);

*/

// ------------------------ Question 3 ------------------------

/*

logic [7:0] a, b;
logic [15:0] c, z;

multiply_16bit mux1(a, b, c);

initial begin

	a = 0;
	b = 0;

	for(int M = 0; M <= 10; M++) begin
		for(int N = 0; N <= 10; N++) begin
			#1;
			
			z = M*N;
			//$display("(a)%d * (b)%d = %d", a, b, z);
			
			if (c !== z) $display("FAILED: Inputs a = %d and b = %d", a, b);
			else $display("PASSED: (a)%d * (b)%d = (c)%d", a, b, c);

			a++;
		end
		b++;
		a = 0;
	end
end

*/

// ------------------------ Question 2 ------------------------

/*

logic [7:0] c;

display hex0(SW[3:0], HEX0);
display hex1(SW[7:4], HEX1);

multiply_8bit mux1(SW[3:0], SW[7:4], c);

display hex2(c[3:0], HEX2);
display hex3(c[7:4], HEX3);

*/

// ------------------------ Question 1 ------------------------

//display hex0(SW[3:0], HEX0);

endmodule
