`timescale 1ns / 1ps

module ControlUnit(
    input [4:0] inst,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp
    );
    
    always @ (*) begin
        case (inst) 
            5'b01100: begin // R Format
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b10;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;    
            end
            
            5'b00000: begin // LW
                Branch = 0;
                MemRead = 1;
                MemtoReg = 1;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
                
            end
            
            5'b01000: begin // SW
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b00;
                MemWrite = 1;
                ALUSrc = 1;
                RegWrite = 0;
                
            end
            
            5'b11000: begin // BEQ
                Branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b01;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 0;
                
            end
            
        endcase
    end
endmodule

