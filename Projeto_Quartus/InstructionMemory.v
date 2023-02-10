module InstructionMemory(
input [7:0] A,
output reg [31:0] RD
);

always @(*)
begin
	case(A)
		0: RD = 32'b_001000_00000_00001_00000_00000_000011;
		1: RD = 32'b_001000_00000_00010_00000_00000_001001;
		2: RD = 32'b_000000_00001_00010_00010_00000_100000;
		3: RD = 32'b_000000_00001_00010_00011_00000_100100;
		4: RD = 32'b_000000_00001_00010_00100_00000_100101;
		5: RD = 32'b_000000_00001_00010_00101_00000_100111;
		6: RD = 32'b_000000_00101_00100_00110_00000_101010;
		
		7: RD = 32'b_001000_00000_00001_00000_00011_001010;
		8: RD = 32'b_001000_00000_00010_00000_00001_110110;
		9: RD = 32'b_000000_00001_00010_00011_00000_100111;
		10: RD = 32'b_000000_00001_00010_00100_00000_100100;
		11: RD = 32'b_000000_00100_00011_00111_00000_100111;
		default: RD = 0;
	endcase

end
endmodule
