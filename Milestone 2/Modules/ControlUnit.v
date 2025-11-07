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
*                 7/11/2025 - Added Jump and a second ALUSrc signal to support jump, turned MemtoReg into 2 bits
*
**********************************************************************/


module ControlUnit(
    input [4:0] inst,
    output reg Branch, MemRead, MemWrite, ALUSrc_1, ALUSrc_2, RegWrite, Jump,
    output reg [1:0] ALUOp, MemtoReg
    );
    
    always @ (*) begin
        case (inst) 
            `OPCODE_Arith_R: begin // R Format
                Branch = 0;
                MemRead = 0;
                MemtoReg = `MEMTOREG_ALU;
                ALUOp = `ALUOP_RTYPE;
                MemWrite = 0;
                ALUSrc_1 = 0;
                ALUSrc_2 = 0;
                RegWrite = 1; 
                Jump = 0;   
            end
            
            `OPCODE_Load: begin // LW
                Branch = 0;
                MemRead = 1;
                MemtoReg = `MEMTOREG_DM;
                ALUOp = `ALUOP_ADD;
                MemWrite = 0;
                ALUSrc_1 = 0;
                ALUSrc_2 = 1;
                RegWrite = 1;
                Jump = 0;
            end
            
            `OPCODE_Store: begin // SW
                Branch = 0;
                MemRead = 0;
                MemtoReg = `MEMTOREG_ALU;
                ALUOp = `ALUOP_ADD;
                MemWrite = 1;
                ALUSrc_1 = 0;
                ALUSrc_2 = 1;
                RegWrite = 0;
                Jump = 0;
            end
            
            `OPCODE_Branch: begin // B-Type
                Branch = 1;
                MemRead = 0;
                MemtoReg = `MEMTOREG_ALU;
                ALUOp = `ALUOP_SUB;
                MemWrite = 0;
                ALUSrc_1 = 0;
                ALUSrc_2 = 0;
                RegWrite = 0;
                Jump = 0;
            end
            
            `OPCODE_JALR: begin // JALR
                Branch = 0;
                MemRead = 0;
                MemtoReg = `MEMTOREG_PC4;
                ALUOp = `ALUOP_ADD;
                MemWrite = 0;
                ALUSrc_1 = 0;
                ALUSrc_2 = 1;
                RegWrite = 1;
                Jump = 1;
            end
            
            `OPCODE_JAL: begin // JAL
                Branch = 0;
                MemRead = 0;
                MemtoReg = `MEMTOREG_PC4;
                ALUOp = `ALUOP_ADD;
                MemWrite = 0;
                ALUSrc_1 = 1;
                ALUSrc_2 = 1;
                RegWrite = 1;
                Jump = 1;
            end
            
        endcase
    end
endmodule

