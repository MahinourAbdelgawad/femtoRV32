`timescale 1ns / 1ps

/*******************************************************************
*
* Module: shifter0.v
* Project: femtorv32
* Authors: Mahinour Abdelgawad mahinourabdelgawad@aucegypt.edu
           Joudy ElGayar Joudyelgayar@aucegypt.edu
           
* Description: Shifter module used in prv32_ALU
*
* Change history: 7/11/2025 - Created module 
* 
* UNRESOLVED: Actually implement shifting logic
**********************************************************************/

module shifter0(
    input wire [31:0] a,
    input wire [4:0] shamt,
    input wire[1:0] type,
    output reg [31:0] r
    );
endmodule

