`timescale 1ns / 1ps

module RCA #(parameter n = 8) (
    
    input[n-1:0] A, [n-1:0]B,
    output [n-1:0] sum,
    output Cout
    );
    
    wire [n:0] w;
    assign w[0] = 0;
    
    
    genvar j;
    generate
        for(j = 0; j < n; j = j+1) 
            begin: Gen_Modules
                FullAdder FAs(
                .A(A[j]), .B(B[j]), .Cin(w[j]), .S(sum[j]), .Cout(w[j+1])
                );
         
            end
        
    endgenerate
    
    assign Cout = w[n];
        

endmodule

