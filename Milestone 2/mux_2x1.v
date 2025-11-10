`timescale 1ns / 1ps


module mux_2x1 #(parameter n = 32) (
    input wire [n-1:0] A, [n-1:0] B,
    input sel,
    output wire [n-1:0] out
    );
    
    assign out = sel ? B : A;
    
endmodule
