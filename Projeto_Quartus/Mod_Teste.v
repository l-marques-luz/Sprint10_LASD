`default_nettype none //Comando para desabilitar declaração automática de wires
module Mod_Teste (
//Clocks
input CLOCK_27, CLOCK_50,
//Chaves e Botoes
input [3:0] KEY,
input [17:0] SW,
//Displays de 7 seg e LEDs
output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
output [8:0] LEDG,
output [17:0] LEDR,
//Serial
output UART_TXD,
input UART_RXD,
inout [7:0] LCD_DATA,
output LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
//GPIO
inout [35:0] GPIO_0, GPIO_1
);
assign GPIO_1 = 36'hzzzzzzzzz;
assign GPIO_0 = 36'hzzzzzzzzz;
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;
wire [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5,
w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5;
LCD_TEST MyLCD (
.iCLK ( CLOCK_50 ),
.iRST_N ( KEY[0] ),
.d0x0(w_d0x0),.d0x1(w_d0x1),.d0x2(w_d0x2),.d0x3(w_d0x3),.d0x4(w_d0x4),.d0x5(w_d0x5),
.d1x0(w_d1x0),.d1x1(w_d1x1),.d1x2(w_d1x2),.d1x3(w_d1x3),.d1x4(w_d1x4),.d1x5(w_d1x5),
.LCD_DATA( LCD_DATA ),
.LCD_RW ( LCD_RW ),
.LCD_EN ( LCD_EN ),
.LCD_RS ( LCD_RS )
);
//---------- modifique a partir daqui --------

wire w_ULASrc,w_RegWrite,w_RegDst,w_MemtoReg,w_MemWrite,clk1,w_PCSrc,w_Jump,w_Branch,w_Z,w_We;
wire [2:0] w_ULAControl,w_wa3;
wire [15:0] w_PCp1,w_PC,w_rd1SrcA,w_rd2,w_SrcB,w_ULAResultWd3,w_wd3,w_RData,w_m1,w_nPC,w_PCBranch,w_DataOut,w_DataIn,w_RegData;
wire [31:0] w_Inst;


assign clk1 = SW[17];
//clock1s clk1s(.clock(CLOCK_50),.clocknovo(clk1)); //2 hz
ControlUnit c1(.OP(w_Inst[31:26]),.Funct(w_Inst[5:0]),.ULAControl(w_ULAControl[2:0]),.ULASrc(w_ULASrc),.Jump(w_Jump),.MemtoReg(w_MemtoReg),.MemWrite(w_MemWrite),.Branch(w_Branch),.RegWrite(w_RegWrite),.RegDst(w_RegDst));
RegisterFile r1(.we3(w_RegWrite),.ra1(w_Inst[25:21]),.ra2(w_Inst[20:16]),.wa3(w_wa3),.wd3(w_wd3),.rd1(w_rd1SrcA),.rd2(w_rd2),.clk(clk1),.S0(), .S1({w_d0x0, w_d0x1}), .S2({w_d0x2, w_d0x3}), .S3({w_d1x0, w_d1x1}), .S4({w_d1x2, w_d1x3}),
.S5(), .S6(), .S7());

//InstructionMemory m1(.A(w_PC),.RD(w_Inst));

PC pc1(.PCin(w_nPC),.PC(w_PC),.clk(clk1));
ULA ula1(.SrcA(w_rd1SrcA),.SrcB(w_SrcB),.shamt(w_Inst[10:6]),.ULAResult(w_ULAResultWd3),.ULAControl(w_ULAControl[2:0]),.Z(w_Z));
mux2 MuxULASrc(.entrada0(w_rd2),.entrada1(w_Inst[15:0]),.sel(w_ULASrc),.saida(w_SrcB));
mux2 MuxWR(.entrada0(w_Inst[20:16]),.entrada1(w_Inst[15:11]),.sel(w_RegDst),.saida(w_wa3));
mux2 MuxDDest(.entrada0(w_ULAResultWd3),.entrada1(w_RegData),.sel(w_MemtoReg),.saida(w_wd3));
mux2 MuxPCSrc(.entrada0(w_PCp1),.entrada1(w_PCBranch),.sel(w_PCSrc),.saida(w_m1));
mux2 MuxJump(.entrada0(w_m1),.entrada1(w_Inst[15:0]),.sel(w_Jump),.saida(w_nPC));
RomInstMem InstMem(.address(w_PC),.clock(CLOCK_50),.q(w_Inst));
RamDataMem DataMem(.address(w_ULAResultWd3),.data(w_rd2),.clock(CLOCK_50),.wren(w_We),.q(w_RData));

ParallelOUT saida(.RegData(w_rd2),.clk(clk1),.we(w_MemWrite),.Address(w_ULAResultWd3),.DataOut(w_DataOut),.wren(w_We));
ParallelIN entrada(.MemData(w_RData),.Address(w_ULAResultWd3),.DataIn(w_DataIn),.RegData(w_RegData));

assign LEDR[9] = w_RegWrite;
assign w_PCp1 = w_PC + 1;
assign LEDR[6:4] = w_ULAControl[2:0];
assign LEDR[7] = w_ULASrc;
assign LEDR[8] = w_RegDst;
assign LEDR[17] = ~clk1;
assign w_d0x4 = w_PC;
assign w_PCBranch = w_PCp1 + w_Inst[15:0];
assign w_PCSrc = w_Z & w_Branch;
assign w_d1x5 = w_DataOut[6:0];

assign HEX0 = ~w_DataOut[6:0];
assign w_DataIn = SW[7:0];

assign HEX1 = ~SW[6:0];
assign w_d1x4 = w_Inst[10:6];
endmodule


