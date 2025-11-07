`timescale 1ns / 1ps
`include "defines.v"

/*******************************************************************
*
* Module: ControlUnit.v
* Project: femtorv32
* Authors: Mahinour Abdelgawad mahinourabdelgawad@aucegypt.edu
           Joudy ElGayar Joudyelgayar@aucegypt.edu
           
* Description: The control unit generates control signals based on opcode
*
* Change history: 28/10/2025 - Created module for Computer Architecture Lab 6
* 
*
**********************************************************************/


module ControlUnit(
    input [4:0] inst,
    output reg Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite,
    output reg [1:0] ALUOp
    );
    
    always @ (*) begin
        case (inst) 
            `OPCODE_Arith_R: begin // R Format
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b10;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;    
            end
            
            `OPCODE_Load: begin // LW
                Branch = 0;
                MemRead = 1;
                MemtoReg = 1;
                ALUOp = 2'b00;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
                
            end
            
            `OPCODE_Store: begin // SW
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 2'b00;
                MemWrite = 1;
                ALUSrc = 1;
                RegWrite = 0;
                
            end
            
            `OPCODE_Branch: begin // B-Type
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

