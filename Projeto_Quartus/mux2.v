module mux2(
input [15:0] entrada0,entrada1,
input sel,
output reg [15:0] saida
);

always @(*)
begin
	case(sel)
	0 :  saida = entrada0;
	1 :  saida = entrada1;
	endcase
end
endmodule