module decode7seg(
input [3:0] a,
output reg [6:0] res
);
always @(*)
begin 
	case(a)
		0 : res = 7'b0000001;
		1 : res = 7'b1001111;
		2 : res = 7'b0010010;
		3 : res = 7'b0000110;
		4 : res = 7'b1001100;
		5 : res = 7'b0100100;
		6 : res = 7'b0100000;
		7 : res = 7'b0001111;
		8 : res = 7'b0000000;
		9 : res = 7'b0000100;
		10 : res = 7'b0001000;
		11 : res = 7'b1100000;
		12 : res = 7'b0110001;
		13 : res = 7'b1000010;
		14 : res = 7'b0110000;
		15 : res = 7'b0111000;
	endcase
end
endmodule
