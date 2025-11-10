
`timescale 1ns / 1ps

module DataMem (
    input clk, MemRead, MemWrite,
    input [2:0] func3, 
    input  [7:0]  addr, 
    input [31:0] data_in,
    output reg [31:0] data_out
     );
     
    reg [31:0] mem [0:63];
    
//    assign data_out = MemRead ? mem[addr] : 32'h00000000;
    always @ (*) begin
        if (MemRead) begin
            case (func3)
                `F3_LB: data_out = {{24{mem[addr][7]}}, mem[addr]}; 
                `F3_LH:  data_out = {{16{mem[addr][15]}}, mem[addr][15:0]};     
                `F3_LW:  data_out = mem[addr];                                   
                `F3_LBU: data_out = {24'b0, mem[addr][7:0]};                    
                `F3_LHU: data_out = {16'b0, mem[addr][15:0]};                    
                default: data_out = 32'b0;
                
            endcase
        end
        else
            data_out <= 32'b0;
    end    
    
    
    always @(posedge clk) begin
        if (MemWrite) begin
            case (func3)
                `F3_SB: mem[addr] <= data_in[7:0];
                `F3_SH: begin
                    mem[addr] <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                end
                `F3_SW: begin 
                    mem[addr] <= data_in[7:0];
                    mem[addr+1] <= data_in[15:8];
                    mem[addr+2] <= data_in[23:16];
                    mem[addr+3] <= data_in[31:24];
                end
                
          endcase  
        end
   end
    
    
   initial begin
   // Exp1
//     mem[0]=32'd17;
//     mem[1]=32'd9;
//     mem[2]=32'd25;

    // Exp 2
//    mem[0] = 32'd5;   // loop counter (n = 5)
//    mem[1] = 32'd0;   // sum = 0
//    mem[2] = 32'd1;   // decrement value

      mem[0] = 32'd5;   // x1 value
      mem[1] = 32'd5;   // x2 value (equal to x1)
      mem[2] = 32'd3;   // x3 value (less than x1)
      mem[3] = 32'd9;   // x4 value (greater than all)
    
    end
    
endmodule
