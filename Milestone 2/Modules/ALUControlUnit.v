`timescale 1ns / 1ps
`include "defines.v" 

/*******************************************************************
*
* Module: ALUControlUnit.v
* Project: femtorv32
* Authors: Mahinour Abdelgawad mahinourabdelgawad@aucegypt.edu
           Joudy ElGayar Joudyelgayar@aucegypt.edu
           
* Description: The ALU control unit generates ALU selection control signals based on ALUOP, func3, and instruction[5
*
* Change history: 28/10/2025 - Created module for Computer Architecture Lab 6
*                 9/11/2025 - Expanded module to support all instructions. renamed inst_14_12 to func3
**********************************************************************/

module ALUControlUnit(
    input [1:0] ALUOp,
    input [2:0] func3,
    input inst_30, inst_5,
    output reg [3:0] ALU_sel 
    );
    
    always @ (*) begin
        case (ALUOp) 
            2'b00: ALU_sel = `ALU_ADD;
            2'b01: ALU_sel = `ALU_SUB;
    
            2'b10: begin
                if (inst_5 == 0) begin // I TYPE (inst_5 is used to determine I or R type
                    case (func3)
                        `F3_ADD: ALU_sel = `ALU_ADD; //addi
                        `F3_SLL: ALU_sel = `ALU_SLL; //slli
                        `F3_SLT: ALU_sel = `ALU_SLT; //slti
                        `F3_SLTU: ALU_sel = `ALU_SLTU; //sltui
                        `F3_XOR: ALU_sel = `ALU_XOR; //xori
                        `F3_SRL: ALU_sel = (inst_30) ? `ALU_SRA: `ALU_SRL; //srai or srli
                        `F3_OR: ALU_sel = `ALU_OR; //ori
                        `F3_AND: ALU_sel = `ALU_AND; //andi
                        
                        default: ALU_sel = `ALU_PASS; 
                    endcase 
                end
                
                else begin // R TYPE
                    case(func3)
                        `F3_ADD: ALU_sel = (inst_30 == 0) ? `ALU_ADD : `ALU_SUB;
                        `F3_SLL: ALU_sel = `ALU_SLL;
                        `F3_SLT: ALU_sel = `ALU_SLT;
                        `F3_SLTU: ALU_sel = `ALU_SLTU;
                        `F3_XOR: ALU_sel = `ALU_XOR;
                        `F3_SRL: ALU_sel = (inst_30 == 0) ? `ALU_SRL : `ALU_SRA;
                        `F3_OR: ALU_sel = `ALU_OR;
                        `F3_AND: ALU_sel = `ALU_AND;
                        
                        default: ALU_sel = `ALU_PASS;
                    endcase
                end
            end
            
            default: ALU_sel = `ALU_PASS;
        endcase
       
    end
endmodule