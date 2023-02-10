module ParallelIN (
input [15:0] Address,MemData,DataIn,
output [15:0] RegData
);
wire sel;

assign sel = (Address == 8'hFF);
assign RegData = sel ? DataIn : MemData;

endmodule
