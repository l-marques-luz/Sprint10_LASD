module RegisterFile(
input [15:0] wd3,
input [2:0] wa3, ra1, ra2,
input we3, clk,
output reg [15:0] rd1,rd2,
output reg[15:0] S0,S1,S2,S3,S4,S5,S6,S7
);

reg [15:0] r0,r1,r2,r3,r4,r5,r6,r7;

	always @(posedge clk)
	begin
		if(we3)
		begin
			case(wa3)
			0 : r0 = 0;
			1 : r1 = wd3;
			2 : r2 = wd3;
			3 : r3 = wd3;
			4 : r4 = wd3;
			5 : r5 = wd3;
			6 : r6 = wd3;
			7 : r7 = wd3;
			endcase
		end
	end
	
	always @(ra1 or ra2)
	begin
		case(ra1)
		0 : rd1 = r0;
		1 : rd1 = r1; 
		2 : rd1 = r2;
		3 : rd1 = r3;
		4 : rd1 = r4; 
		5 : rd1 = r5; 
		6 : rd1 = r6; 
		7 : rd1 = r7;
		endcase
		
		case(ra2)
		0 : rd2 = r0;
		1 : rd2 = r1; 
		2 : rd2 = r2;
		3 : rd2 = r3;
		4 : rd2 = r4; 
		5 : rd2 = r5; 
		6 : rd2 = r6; 
		7 : rd2 = r7;
		endcase
	 S0 = r0;
	 S1 = r1;	
	 S2 = r2;	
	 S3 = r3;	
	 S4 = r4;	
	 S5 = r5;	
	 S6 = r6;
	 S7 = r7;
	
	end


endmodule