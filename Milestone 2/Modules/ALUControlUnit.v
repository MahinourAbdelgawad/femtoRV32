`timescale 1ns / 1ps


module ALUControlUnit(
    input [1:0] ALUOp,
    input [2:0] inst14_12,
    input inst_30,
    output reg [3:0] ALU_sel 
    );
    
    always @ (*) begin
        case (ALUOp) 
            2'b00: ALU_sel = 4'b0010;
            2'b01: ALU_sel = 4'b0110;
    
            
            2'b10: begin 
            case (inst14_12)
            3'b000: ALU_sel = (inst_30 == 0) ? 4'b0010: 4'b0110;
            3'b111: ALU_sel = (inst_30 == 0) ? 4'b0000: 0;
            3'b110: ALU_sel = (inst_30 == 0) ? 4'b0001: 0;
            endcase 
            end
        endcase
       
    end
endmodule
