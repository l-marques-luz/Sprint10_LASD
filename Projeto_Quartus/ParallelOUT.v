module ParallelOUT (
input clk, we,
input [15:0] Address, RegData,
output [15:0] wren,
output reg [15:0] DataOut
);

wire fioA,fioB;

assign fioA = (Address == 8'hFF);

assign fioB = we && fioA;
assign wren = we && ~fioA;

always @(posedge clk && fioB)
	DataOut = RegData;
	
endmodule

