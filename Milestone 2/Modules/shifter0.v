`timescale 1ns / 1ps

/*******************************************************************
*
* Module: shifter.v
* Project: femtorv32
* Authors: Mahinour Abdelgawad mahinourabdelgawad@aucegypt.edu
           Joudy ElGayar Joudyelgayar@aucegypt.edu
           
* Description: Shifter module used in prv32_ALU
*
* Change history: 7/11/2025 - Created module 
*                 8/11/2025 - Implemented module                                                            
**********************************************************************/

module shifter (
    input wire [31:0] a,
    input wire [4:0] shamt,
    input wire[1:0] type,
    output reg [31:0] r
    );
    
    always @(*) begin
        case (type)
            `SHIFT_SLL: r = a << shamt; // shift left logical

            `SHIFT_SRL: r = a >> shamt; // shift right logical

             `SHIFT_SRA: begin // shift right arithmetic
                if (a[31] == 1)
                    r = (a >> shamt) | (~(32'hFFFFFFFF >> shamt));
                else
                    r = a >> shamt;
            end
            
            default: r = 32'b0;
            
       endcase
    end
               
endmodule

