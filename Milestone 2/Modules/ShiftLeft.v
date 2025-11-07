`timescale 1ns / 1ps

module ShiftLeft #(parameter n = 8) (
    input [n-1:0] num,
    output [n-1:0] out
    );
    
    assign out = {{num[n-2:0]}, 1'b0};
    
endmodule