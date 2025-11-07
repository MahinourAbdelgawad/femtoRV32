`timescale 1ns / 1ps

module datapath_TB();
    reg clk, reset;
    
    FullDatapath datapath(
    .clk(clk),               
    .reset(reset)       
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        reset = 1;
        #10;
        reset = 0;
        
    end
endmodule
