`timescale 1ns / 1ps

module RegisterFile(
    input [4:0] read_reg1, [4:0] read_reg2,
    output [31:0] read_data1, [31:0] read_data2,
    
    input [4:0] write_reg,
    input [31:0] write_data,
    
    input regWrite, clk, rst
    );
    
    
    reg [31:0] regFile[31:0];
    
    assign read_data1 = regFile[read_reg1];
    assign read_data2 = regFile[read_reg2];
    
    integer i;
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1)
        
            for (i = 0; i < 32; i = i + 1)
            regFile[i] = 0;
            
        else
            if (regWrite == 1'b1 && write_reg != 0)
                regFile[write_reg] = write_data;

    end
    

endmodule
