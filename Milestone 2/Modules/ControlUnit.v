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
<<<<<<< HEAD
*                 9/11/2025 - Added I-Type, LUI, AUIPC, and HALT support
=======
*                 10/11/2025 - Added I-Type, LUI, AUIPC, and HALT support
>>>>>>> 25a8ff37b7c4523f1ba239014727bdc50635f08f
**********************************************************************/


module ControlUnit (
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
            
            // I-type Arithmetic: (ADDI, ANDI, ORI, etc.)
            `OPCODE_Arith_I: begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = `MEMTOREG_ALU;
                ALUOp = `ALUOP_ITYPE;
                MemWrite = 0;
                ALUSrc_1 = 0;
                ALUSrc_2 = 1; // Immediate input
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
            
            
<<<<<<< HEAD
            `OPCODE_LUI: begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = `MEMTOREG_IMM;
                ALUOp = `ALUOP_ADD;
                MemWrite = 0;
                ALUSrc_1 = 0;
                ALUSrc_2 = 1;
                RegWrite = 1;
                Jump = 0;
            end
            
            `OPCODE_AUIPC: begin
=======
            `OPCODE_LUI, `OPCODE_AUIPC: begin
>>>>>>> 25a8ff37b7c4523f1ba239014727bdc50635f08f
                Branch = 0;
                MemRead = 0;
                MemtoReg = `MEMTOREG_ALU;
                ALUOp = `ALUOP_ADD;
                MemWrite = 0;
                ALUSrc_1 = 1;
                ALUSrc_2 = 1;
                RegWrite = 1;
                Jump = 0;
<<<<<<< HEAD
            
            end
=======
            end
            
            
>>>>>>> 25a8ff37b7c4523f1ba239014727bdc50635f08f
            // ECALL / EBREAK / FENCE / FENCE.TSO / PAUSE as well as any wrong inputs (halt)
            default: begin 
                Branch = 0;
                MemRead = 0;
                MemtoReg = `MEMTOREG_ALU;
                ALUOp = `ALUOP_ADD;
                MemWrite = 0;
                ALUSrc_1 = 0;
                ALUSrc_2 = 0;
                RegWrite = 0;
                Jump = 0;
            end
            
        endcase
        
    end
    
endmodule

