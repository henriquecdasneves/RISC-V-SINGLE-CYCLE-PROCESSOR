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