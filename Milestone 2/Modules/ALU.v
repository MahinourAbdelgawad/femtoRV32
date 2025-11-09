`timescale 1ns / 1ps

module ALU #(parameter n = 32) (
    input [n-1:0] A,
    input [n-1:0] B,
    input [3:0] sel,
    output reg [n-1:0] result,
    output reg zFlag, sFlag, cFlag, vFlag
    );
    
    wire [n-1:0] rca_sum;
    wire rca_Cout;
    wire [n-1:0] rca_B;
    
    
    mux_2x1 mux(.A(B), .B(~B + 1), .sel(sel[2]), .out(rca_B));
    
    RCA #(32) rca(.A(A), .B(rca_B), .sum(rca_sum ), .Cout(rca_Cout));
    
    always @ (*) begin
        case (sel)
            4'b0000: result = A & B; // AND
            4'b0001: result = A | B; // OR
            4'b0010: result = rca_sum ;// +
            4'b0110: result = rca_sum ; // -
            default: result = {n{1'b0}};
        endcase 
        
        
        zFlag = (result == 0) ? 1 : 0;
        sFlag = result[n-1];
        cFlag = rca_Cout;
        
        vFlag = (sel[2] == 0) ? 
                        ((A[n-1] & B[n-1] & ~result[n-1]) | (~A[n-1] & ~B[n-1] & result[n-1])) : 
                        ((A[n-1] & ~B[n-1] & ~result[n-1]) | (~A[n-1] & B[n-1] & result[n-1]));
     end

endmodule
