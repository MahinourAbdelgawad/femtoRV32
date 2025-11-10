`timescale 1ns / 1ps

module PC #(parameter n = 32)(
    input wire [n-1:0] D,
    input wire clk, load, rst,
    output [n-1:0] Q
    );
    
    wire [n-1:0] mux_out;
    
    genvar j;
    generate
        for(j = 0; j < n; j = j+1) 
            begin: Gen_Modules
            
                DFlipFlop DFF(
                .clk(clk), .rst(rst), .D(mux_out[j]), .Q(Q[j])
                );
                
                mux_2x1 mux(
                .A(Q[j]), .B(D[j]), .sel(load), .out(mux_out[j])
                );
         
            end
        
    endgenerate
endmodule
