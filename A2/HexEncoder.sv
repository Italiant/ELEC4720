module hexEncoder(input logic [3:0] SW, output logic [6:0] HEX0);
	assign a = SW[3];
	assign b = SW[2];
	assign c = SW[1];
	assign d = SW[0];
	
	assign HEX0[6] = ~(((a|b|c|d)
						& (a|b|c|~d)
						& (a|~b|~c|~d)
						& (~a|b|~c|~d))
						| (a&~b&c&d));
	
	assign HEX0[5] = ~((~a&~c&~d)
						| (~a&b&~c)
						| (a&~b&~c)
						| (a&b&c)
						| (b&c&~d)
						| (a&c&~d)
						| (a&~b&c&d));
						
	assign HEX0[4] = ~((a&b)
						| (~b&~c&~d)
						| (a&~c&~d)
						| (c&~d)
						| (a&~b&c&d));
						
	assign HEX0[3] = ~((~b&~c&~d)
						| (a&~c)
						| (b&~c&d)
						| (~a&~b&c)
						| (~a&c&~d)
						| (b&c&~d)
						| (a&~b&c&d));
						
	assign HEX0[2] = ~((~a&~c)
						| (~a&d)
						| (~a&b)
						| (~c&d)
						| (a&~b&~c)
						| (a&~b&~d)
						| (a&~b&c&d));
						
	assign HEX0[1] = ~((~b
						| (~a&~c&~d)
						| (a&~c&d)
						| (~a&c&d))
						& (~a|b|~c|~d));
						
	assign HEX0[0] = ~((c
						| (a&~b)
						| (~a&b&d)
						| (~a&~b&~d))
						& (~a|b|~c|~d));
endmodule

