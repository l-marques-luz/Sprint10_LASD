module ULA(
input [15:0] SrcA,SrcB,
input [2:0] ULAControl,
input [4:0] shamt,
output reg Z,
output reg [15:0] ULAResult
);

always @(*)
begin
	case(ULAControl)
		3'b000 :  ULAResult = SrcA & SrcB;
		3'b001 :  ULAResult = SrcA | SrcB;
		3'b010 :  ULAResult = SrcA + SrcB;
		3'b011 :  ULAResult = ~(SrcA | SrcB);
		3'b110 :  ULAResult = SrcA + ~SrcB + 1;
		3'b100 :  ULAResult = SrcB << shamt;
		3'b101 :  ULAResult = SrcB >> shamt;  
		
	endcase
	
	if ( ULAControl == 3'b111)
	begin
		if( SrcA < SrcB)
			ULAResult = 1;
		else
			ULAResult = 0;
	end
	
	
	if(ULAResult == 0)
		Z = 1;
	else
		Z = 0; 

end
endmodule