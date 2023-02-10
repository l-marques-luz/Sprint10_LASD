# Sprint 10  - Lab de Arquitetura de Sistemas Digitais
# Aluna: Leiry Gabrielle Marques Luz Pinto
# 
# Alterações de hardware:
#
## Aumento no tamanho dos registradores:
#### O tamanho dos registradores foi aumentado de 8 para 16 bits, esse valor foi escolhido pois as funções de imediato so aceitam imediatos de 16 bits, logo tornar os registradores para 32 bits não traria muitas vantagens.
#### Para implementar essa modificação foi necessario alterar o modulo do RegisterFile, para criar registradores de 16 bits, assim como alterar todos os barramentos que interagem com dados do registrador
#### Alterações realizadas no RegisterFile:
```v
  module RegisterFile(
  input [15:0] wd3,
  input [2:0] wa3, ra1, ra2,
  input we3, clk,
  output reg [15:0] rd1,rd2,
  output reg[15:0] S0,S1,S2,S3,S4,S5,S6,S7
);
```
#### O modulo de memoria RAM também foi modificado, para ter o barramento de 16 bits, e sua memoria total foi expandida para 16384 words, para compensar o aumento
##
## Implementação das funções sll e srl:
#### No projeto era necessario utilizar amplamente as funções de deslocamento, logo foi necessario implementa-las no processador, para isso foi necessario realizar duas modificações no hardware:
#### Primeiramente foi necessario fazer a ControlUnity reconhecer essas funções, sll e srl sao funções do tipo R, com OP = 000000 e funct = 000000/000010, logo esses 2 casos foram adicionados ao ControlUnity:
```v
6'b000000: begin
	RegWrite = 1;
	RegDst = 1;
	ULASrc = 0;
	ULAControl = 3'b100;
	Branch = 0;
	MemWrite = 0;
	MemtoReg = 0;
	Jump = 0;
end
6'b000010: begin
	RegWrite = 1;
	RegDst = 1;
	ULASrc = 0;
	ULAControl = 3'b101;
	Branch = 0;
	MemWrite = 0;
	MemtoReg = 0;
	Jump = 0;
end
```
#### (Os valores da ULAControl correspondem aos 2 valores que não eram utilizados por outras funções)
####
#### A segunda modificação foi para a ULA conseguir realizar essas operações, a primeira mudança foi adicionar os 2 novos casos para a ULAControl, porém após isso era necessario carregar na ULA o valor do deslocamento, após pesquisar no livro texto da disciplina teorica e na internet não consegui achar a forma que a arquitetura MIPS implementa de fato esse problema, minha solução foi adicionar mais uma entrada à ULA, que recebe o valor do shamt diretamente do codigo da instrução, e so é usada nessas 2 funções, segue abaixo o novo codigo para a ULA:

```v
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
```

# Projeto:
#### Meu projeto consiste na implementação de um codigo para realizar uma operação de checksum, bastante usada para detectar dados corrompidos ou modificados, esse codigo é capaz de realizar checksum's de 1 ou 2 bytes em um dado de 16 bits.
#### Os detalhes de funcionamento do codigo foram explicados no video de demonstração, mas segue abaixo uma copia do codigo utilizado:
```assembly
addi $4,$0, abcd
addi $2,$0, 2
addi $5,$0, 2
addi $6,$0, 4
beq $2,$5, 2
beq $2,$6, 11
j 5F
srl $1,$4,C
sll $4,$4 4
srl $2,$4,C
sll $4,$4 4
srl $3,$4,C
sll $4,$4 4
srl $4,$4,C
add $1,$1,$2
add $1,$1,$3
add $1,$1,$4
srl $2,$1,4
sll $1,$1,C
srl $1,$1,C
add $1,$1,$2
nor $1,$1,$0
j 5F
srl $1,$4,8
sll $4,$4 8
srl $2,$4,8
add $1,$1,$2
srl $2,$1,8
sll $1,$1,8
srl $1,$1,8
add $1,$1,$2
nor $1,$1,$0    

```
