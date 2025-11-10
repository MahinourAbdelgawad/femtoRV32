`timescale 1ns / 1ps
/*******************************************************************
*
* Module: mux_4x1.v
* Project: femtorv32
* Authors: Mahinour Abdelgawad mahinourabdelgawad@aucegypt.edu
           Joudy ElGayar Joudyelgayar@aucegypt.edu
           
* Description: a 4x1 multiplexer
*
* Change history: 7/11/2025 - Created module 
* 
*
**********************************************************************/

module mux_4x1 #(parameter n = 32)(
    input  [n-1:0] A,
    input  [n-1:0] B,
    input  [n-1:0] C,
    input  [n-1:0] D,
    input  [1:0] sel,
    output reg [n-1:0] out
    );

    always @(*) begin
        case (sel)
            2'b00: out = A;
            2'b01: out = B;
            2'b10: out = C;
            2'b11: out = D;
            default: out = A;
        endcase
    end
endmodule

