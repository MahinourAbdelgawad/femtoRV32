`timescale 1ns / 1ps

module FullAdder(
    input A, B, Cin,
    output S, Cout

    );
    
    assign {Cout, S} = A + B + Cin;
    
    
endmodule
