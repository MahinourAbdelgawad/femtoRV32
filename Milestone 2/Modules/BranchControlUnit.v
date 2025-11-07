`timescale 1ns / 1ps
`include "defines.v"

/*******************************************************************
*
* Module: BranchControlUnit.v
* Project: femtorv32
* Authors: Mahinour Abdelgawad mahinourabdelgawad@aucegypt.edu
           Joudy ElGayar Joudyelgayar@aucegypt.edu
           
* Description: The branch control unit generates control signals based on branch type using func3
*
* Change history: 7/11/2025 - Created module 
* 
*
**********************************************************************/


module BranchControlUnit(
    input [2:0] func3, // from instruction[14:12]
    input Z, C, V, S, Branch, // Z,C,V,S are flags from ALU, Branch is from control unit
    output reg Branch_output // should go to mux that determines PC_in
    );
    
    always @(*) begin
        if (Branch)
            case (func3)
                `BR_BEQ: Branch_output = Z;         
                `BR_BNE: Branch_output = ~Z;           
                `BR_BLT: Branch_output = (S != V);            
                `BR_BGE: Branch_output = (S == V);       
                `BR_BLTU: Branch_output = ~C;       
                `BR_BGEU: Branch_output = C;
            endcase
   end
endmodule
