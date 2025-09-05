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