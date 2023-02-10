module PC(
input clk,
input [15:0] PCin,
output reg [15:0] PC

);

always @(posedge clk)
begin
PC = PCin ;
end
endmodule