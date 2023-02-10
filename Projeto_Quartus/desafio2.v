
module desafio2(
input clock,
output reg [17:0] res
);
reg direcao;
always @(posedge clock)
	begin
	if (!direcao)
		case(res)
			18'b000000000000000000 : res = 18'b100000000000000000;
			18'b000000000000000001 : direcao = ~direcao;
			default: res = res >> 1;
		endcase
	else
		case(res)
			18'b100000000000000000: direcao = ~direcao;
			default: res = res << 1;
			endcase
end	
endmodule