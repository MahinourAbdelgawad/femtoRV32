`timescale 1ns / 1ps
`include "defines.v" 

/*******************************************************************
*
* Module: ALU.v
* Project: femtorv32
* Authors: Mahinour Abdelgawad mahinourabdelgawad@aucegypt.edu
           Joudy ElGayar Joudyelgayar@aucegypt.edu
           
* Description: The ALU performs arithmetic and logical operations based on sel and outputs z,s,c,v flags
*
* Change history: 28/10/2025 - Created module for Computer Architecture Lab 6
*                 9/11/2025 - Expanded module to support all instructions
**********************************************************************/

module ALU #(parameter n = 32) (
    input [n-1:0] A,
    input [n-1:0] B,
    input [3:0] sel,
    input wire [4:0] shamt,
    input wire type_IR,
    output reg [n-1:0] result,
    output reg zFlag, sFlag, cFlag, vFlag
    );
    
    wire [n-1:0] rca_sum;
    wire rca_Cout;
    wire [n-1:0] rca_B;
    
    
    mux_2x1 mux(.A(B), .B(~B + 1), .sel(sel[2]), .out(rca_B));
    
    RCA #(32) rca(.A(A), .B(rca_B), .sum(rca_sum ), .Cout(rca_Cout));
    
    always @ (*) begin
        result = 0;
        zFlag = 0;
        sFlag = 0;
        cFlag = 0;
        vFlag = 0;
        
        case (sel)
          `ALU_ADD: result = rca_sum;
          `ALU_SUB: result = rca_sum;
          `ALU_PASS: result = A;
          `ALU_OR: result = A | B;
          `ALU_AND: result = A & B;
          `ALU_XOR: result = A ^ B;
          `ALU_SRL: result = type_IR ? (A >> shamt) : (A >> B[4:0]);
          `ALU_SRA: result = type_IR ? (A >>> shamt) : (A >>> B[4:0]); //sra or srai
          `ALU_SLL: result = type_IR ? (A << shamt) : (A << B[4:0]);
          `ALU_SLT: result = {31'b0, (sFlag ^ vFlag)};
          `ALU_SLTU: result = {31'b0, (~cFlag)};
        endcase 
        
        //FLAGS
        zFlag = (result == 0);
        sFlag = result[n-1];
        
        if(sel == `ALU_ADD || sel == `ALU_SUB)
            cFlag = rca_Cout;

        
         if(sel == `ALU_ADD)
            vFlag = (~A[n-1] & ~B[n-1] & result[n-1]) | (A[n-1] & B[n-1] & ~result[n-1]);
            
        else if(sel == `ALU_SUB)
            vFlag = (~A[n-1] & B[n-1] & result[n-1]) | (A[n-1] & ~B[n-1] & ~result[n-1]);
        
     end

endmodule
