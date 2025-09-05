// TCC - CI INOVADOR - POLO UFRGS
// Tema: Processador RISC-V 32 Bits Monociclo (7 Instruções)
// Aluno: Henrique Cardozo das Neves
// Orientador: Dr. André Reis

// Módulo 01 - PC (Program Counter)

module program_counter(clk, rst, pc_in, pc_out);
	 
input clk;                
input rst;                
input [31:0] pc_in;       
output reg [31:0] pc_out; 


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 32'b00;  
        end else begin
            pc_out <= pc_in;  
        end
    end

endmodule

// Módulo 02 - Adder (PC + 4)

module pc_adder(pc_in, pc_next);

input [31:0] pc_in;      
output reg [31:0] pc_next;


    always @(*) begin
        pc_next = pc_in + 4;  
    end

endmodule


// Módulo 03 - Multiplexador - PC

module pc_mux(pc_in, pc_branch, pc_select, pc_out);

input [31:0] pc_in;       
input [31:0] pc_branch;  
input pc_select;          
output reg[31:0] pc_out; 

	 
   always @(*) begin
        if (pc_select==1'b0) begin
            pc_out = pc_in;  
        end else begin
            pc_out = pc_branch;      
        end
    end

endmodule

// Módulo 04 - Instruction Memory

module Instruction_Memory(rst, clk, read_address, instruction_out);

input rst, clk;
input [31:0] read_address;
output [31:0] instruction_out;
reg [31:0] I_Mem [63:0];  
integer k;
assign instruction_out = I_Mem[read_address];

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        for (k = 0; k < 64; k = k + 1) begin 
            I_Mem[k] = 32'b00;  
        end
    end else begin
        // Operações Tipo-R
					 I_Mem[0]  = 32'b0000000_00000_00000_000_00000_0000000;       // xxxxx
					 I_Mem[4]  = 32'b0000000_11001_10000_000_01101_0110011;      // add x13, x16, x25
					 I_Mem[8]  = 32'b0100000_00011_01000_000_00101_0110011;      // sub x5, x8, x3
					 
					 // Operações Tipo-I
					 I_Mem[20]  = 32'b000000000011_10101_000_10110_0010011;     // addi x22, x21, 3					
				
					 // Operações Tipo-L
					 I_Mem[28] = 32'b000000001111_00101_010_01000_0000011;      // lw x8, 15(x5)
					 
					 // Operações Tipo-S
					 I_Mem[36] =  32'b0000000_01111_00101_010_01100_0100011;     // sw x15, 12(x5)
					 
					 // Operaçao Tipo-SB
					 I_Mem[44] = 32'h00948663; //beq x9,x9, 12
		

        
    end
end

endmodule

// Módulo 04 - Register File 

module Register_File(clk, rst, RegWrite,Rs1,Rs2, Rd,Write_data,read_data1, read_data2);

input clk, rst, RegWrite;
input [4:0] Rs1,Rs2, Rd;
input [31:0] Write_data;
output [31:0] read_data1, read_data2;

reg [31:0] Registers [31:0];

 initial begin
Registers[0] = 0;
Registers[1] = 3;
Registers[2] = 2;
Registers[3] = 12;
Registers[4] = 20;
Registers[5] = 3;
Registers[6] = 44;
Registers[7] = 4;
Registers[8] = 2;
Registers[9] = 1;
Registers[10] = 23;
Registers[11] = 4;
Registers[12] = 90;
Registers[13] = 10;
Registers[14] = 20;
Registers[15] = 30;
Registers[16] = 40;
Registers[17] = 50;
Registers[18] = 60;
Registers[19] = 70;
Registers[20] = 80;
Registers[21] = 80;
Registers[22] = 90;
Registers[23] = 70;
Registers[24] = 60;
Registers[25] = 65;
Registers[26] = 4;
Registers[27] = 32;
Registers[28] = 12;
Registers[29] = 34;
Registers[30] = 5;
Registers[31] = 10;
end

integer k;
always @(posedge clk) begin
if (rst) 
begin
      for (k = 0; k < 32; k = k + 1) begin
        Registers[k] = 32'b00;
      end
    end

    else if (RegWrite ) begin
      Registers[Rd] = Write_data;
    end
  end

  assign read_data1 = Registers[Rs1];
  assign read_data2 = Registers[Rs2];
endmodule


// Módulo 05 - Unidade de Controle (Control Unit)

module main_control_unit(opcode, RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch, ALUOp);
    
	 input [6:0] opcode;          
    output reg RegWrite;        
    output reg MemRead;         
    output reg MemWrite;         
    output reg MemToReg;        
    output reg ALUSrc;                      
    output reg Branch;                       
    output reg [1:0] ALUOp;       


    always @(*) begin
        case (opcode)
            7'b0110011:  // R-type 
            begin  {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10};end
            7'b0010011:   // I-type
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= {1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10};end
            7'b0000011:   // Load 
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00};end
            7'b0100011:   // Store 
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= {1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00};end
            7'b1100011:   // Branch 
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 2'b11};end  
            default: 
            begin {ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} <= {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 2'b00};end  
        endcase
    end

endmodule

// Módulo 06 - Gerador de Imediato (Imm Gen)

module immediate_generator(instruction, imm_out);

    input [31:0] instruction;   
    output reg [31:0] imm_out;  


    always @(*) begin
        case (instruction[6:0]) 
				7'b0010011: imm_out = {{20{instruction[31]}}, instruction[31:20]}; // I-type  
            7'b0000011: imm_out = {{20{instruction[31]}}, instruction[31:20]}; // Load-type
            7'b0100011: imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // Store-type
            7'b1100011: imm_out = {{19{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B-type  
            default: imm_out = 32'b0; // Default case
        endcase
    end

endmodule

// Módulo 07 - Unidade Lógica Aritmética (ULA)

module ALU(A, B, ALUcontrol_In, Result, Zero);
    
	 input [31:0] A;             
    input [31:0] B;            
    input [3:0] ALUcontrol_In;          
    output reg [31:0] Result;   
    output reg Zero;             


    always @(A or B or ALUcontrol_In) begin
        case (ALUcontrol_In)
            4'b0000: Result = A + B;           		// ADD
            4'b0001: Result = A - B;           		// SUB
            4'b0010: Result = A & B;           		// AND
            4'b0011: Result = A | B;           		// OR
            4'b0100: Result = A ^ B;           		// XOR
            default: Result = 32'b0;          		
        endcase

        
        Zero = (Result == 32'b0) ? 1 : 0;
    end

endmodule

// Módulo 08 - Controle: Unidade Lógica Aritmética (ULA)

module ALU_Control(funct3, funct7, ALUOp,ALUcontrol_Out);        
    
	 input [2:0] funct3;         
    input [6:0]funct7;       
    input [1:0] ALUOp;          
    output reg [3:0] ALUcontrol_Out; 

always @(*) begin
  case ({ALUOp, funct7, funct3})
    12'b10_0000000_000 : ALUcontrol_Out <= 4'b0000;    // ADD 
    12'b00_0000000_000 : ALUcontrol_Out <= 4'b0000;    // ADD 
    12'b00_0000000_001 : ALUcontrol_Out <= 4'b0000;    // ADD 
    12'b00_0000000_010 : ALUcontrol_Out <= 4'b0000;    // ADD 
    12'b10_0100000_000 : ALUcontrol_Out <= 4'b0001;    // SUB 
    12'b10_0000000_111 : ALUcontrol_Out <= 4'b0010;    // AND
    12'b10_0000000_110 : ALUcontrol_Out <= 4'b0011;    // OR
    12'b10_0000000_100 : ALUcontrol_Out <= 4'b0100;    // XOR
    default            : ALUcontrol_Out <= 4'b0000; 
  endcase
end


endmodule

// Módulo 09 - Multiplexador ULA  

module MUX2to1 (input0, input1, select, out);
    
	 input [31:0] input0;  
    input [31:0] input1;   
    input select;          
    output [31:0] out;     


    assign out = (select) ? input1 : input0;  

endmodule

// Módulo 10 - Memória

module Data_Memory(clk, rst, MemRead, MemWrite, address, write_data, read_data);

    input clk;               
    input rst;               
    input MemRead;          
    input MemWrite;         
    input [31:0] address;    
    input [31:0] write_data;
    output[31:0] read_data;

  reg [31:0] D_Memory [63:0];

  integer k;

  assign read_data = (MemRead) ? D_Memory[address] : 32'b00;

  always @(posedge clk or posedge rst) begin
    if (rst ) begin
      for (k = 0; k < 64; k = k + 1) begin
        D_Memory[k] = 32'b00;
      end
    end else if (MemWrite) begin
      D_Memory[address] = write_data;
    end
  end

endmodule

// Módulo 11 - Multiplexador Memoria

module MUX2to1_DataMemory (input0, input1, select, out);
    
	 input [31:0] input0;  
    input [31:0] input1;
    input select;         
    output [31:0] out;     


    assign out = (select) ? input1 : input0; 

endmodule

// Módulo 12 - Branch


module Branch_Adder(PC, offset, branch_target);

    input [31:0] PC;                    
    input [31:0] offset;                 
    output reg [31:0] branch_target;    


    always @(*) begin
        branch_target <= PC + (offset);  
    end

endmodule

// Modulo TOPO

module RISCV_Top(
		  input clk, rst
		); 

// Fios - Conectar Modulos
wire [31:0] pc_out_wire, pc_next_wire, pc_wire, decode_wire, read_data1, regtomux, WB_wire, branch_target, immgen_wire,muxtoAlu,read_data_wire,WB_data_wire;
wire RegWrite,ALUSrc, MemRead,MemWrite,MemToReg,Branch,Zero;
wire [1:0] ALUOp_wire;
wire [3:0] ALUcontrol_wire;


// Conexão dos Módulos - Instanciação (Conectar todos os módulos conforme o esquemático para formar o Processador RISC-V Monociclo)


// Módulo 01 - PC (Program Counter)
program_counter PC(.clk(clk),.rst(rst),.pc_in(pc_wire),.pc_out(pc_out_wire));

// Módulo 02 - Adder (PC + 4)
pc_adder PC_Adder(.pc_in(pc_out_wire),.pc_next(pc_next_wire));

// Módulo 03 - Multiplexador - PC
pc_mux pc_mux(.pc_in(pc_next_wire),.pc_branch(branch_target),.pc_select(Branch&Zero),.pc_out(pc_wire));

// Módulo 04 - Instruction Memory
Instruction_Memory Instr_Mem(.rst(rst),.clk(clk),.read_address(pc_out_wire),.instruction_out(decode_wire));

// Register File
Register_File Reg_File(.rst(rst), .clk(clk), .RegWrite(RegWrite), .Rs1(decode_wire[19:15]), .Rs2(decode_wire[24:20]), .Rd(decode_wire[11:7]), .Write_data(WB_data_wire), .read_data1(read_data1), .read_data2(regtomux));

// Control Unit
main_control_unit Control_Unit(.opcode(decode_wire[6:0]),.RegWrite(RegWrite),.MemRead(MemRead),.MemWrite(MemWrite),.MemToReg(MemToReg),.ALUSrc(ALUSrc),.Branch(Branch),.ALUOp(ALUOp_wire));
// ALU_Control
ALU_Control ALU_Control(.funct3(decode_wire[14:12]),.funct7(decode_wire[31:25]),.ALUOp(ALUOp_wire),.ALUcontrol_Out(ALUcontrol_wire));
// ALU
ALU ALU(.A(read_data1),.B(muxtoAlu),.ALUcontrol_In(ALUcontrol_wire),.Result(WB_wire),.Zero(Zero));
// Immediate Generator
immediate_generator Imm_Gen(.instruction(decode_wire),.imm_out(immgen_wire));
// ALU Mux
MUX2to1 Imm_Mux(.input0(regtomux),.input1(immgen_wire),.select(ALUSrc),.out(muxtoAlu));
// Data Memory
Data_Memory Data_Mem(.clk(clk),.rst(rst),.MemRead(MemRead),.MemWrite(MemWrite),.address(WB_wire),.write_data(regtomux),.read_data(read_data_wire));
//WB Mux
MUX2to1_DataMemory WB_Mux(.input0(WB_wire),.input1(read_data_wire),.select(MemToReg),.out(WB_data_wire));
//Branch_Adder
Branch_Adder Branch_Adder(.PC(pc_out_wire), .offset(immgen_wire), .branch_target(branch_target));
//
endmodule


// Testbench

module RISCV_ToP_Tb;

    reg clk, rst;
    
    RISCV_Top UUT (
        .clk(clk), 
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
    end

    always #50 clk = ~clk; 

    // Reset generation
    initial begin
        rst = 1'b1;
        #50;
        rst = 1'b0; 
        #5200; 
        $finish; 
    end

    
    initial begin
        $dumpfile("waveform.vcd");  
        $dumpvars(0, UUT);          
    end

endmodule
