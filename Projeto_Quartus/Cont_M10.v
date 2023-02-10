module Cont_M10(
input clock,reset,
output reg [3:0] res
);

always @(posedge clock)
	begin
	if(!reset)
	res = 9;
	else
		begin
		if(res == 0)
		res = 9;
		else
		res = res - 1;
	end
end
endmodule