------------------------------------ TESTING GUIDE -----------------------------------

We have provided 5 files for you to test our CPU with;

 - r_type_test.txt
 - i_type_test.txt
 - memory_test.txt
 - branch_test.txt
 - jump_test.txt

These files demonstrate all of the instructions included in our design.

To edit register values at any time, turn SW[9] and SW[8] ON, this is the CLOCK 
disable and PC disable, respectively. When PC is disabled, the CLOCK can be re-enabled 
and the data on SW[7:4] will be written to the register at address SW[3:0].

When the PC is re-enabled, data writing to the register will be disabled.

LEDG[0] indicates the CLOCK, which is currently set to 1.5Hz. The clcock can be set 
faster or slower using CLK_USED = q[n],where larger values of n create a slower clock.

LEDG[6:1] indicates the instruction type {J,B1,B2,M,I,R}

LEDR[5:0] indicates the program counter.
When our program reads a blank line from the ROM, it automatically jumps back to 
line 0 of the program

By default, 	HEX0 = RD3[3:0]
		HEX1 = RD3[7:4]
		HEX2 = RD3[11:8]
		HEX3 = RD3[15:12]

There is some commented hardware for the HEX displays that make testing the jump and
branch instructions easier, ie, display PC and PC_next.


For loading full 16 bit words into registers, the I-Type lui, lmui, lmli and ori can 
be added to the test files store the data 4 bits at a time. lmui and lmli both function 
the same as ori, where the instruction should say [rs] = ( [rs] OR CompImm) ; where CompImm 
is determined depending on which function is used.