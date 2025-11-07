`timescale 1ns / 1ps


module topModule(
    input clk,               
    input reset,            
    input [1:0] ledSel,      
    input [3:0] ssdSel,      
    input ssdClk,            
    output reg [15:0] leds,     
   output [3:0] Anode,      
    output [6:0] LED_out
    );
    
    wire [31:0] Instruction_out;
    wire [13:0] control_signals_out;
    wire [31:0] PC_out_to_ssd, PC_4_out, PC_adder_ssd, PC_in_to_ssd,
     rs1_data, rs2_data, write_data_to_ssd, Imm_to_ssd, shift_out_to_ssd, muxALU_to_ssd, ALU_to_ssd, dataMem_to_ssd;
     
    FullDatapath CPU(.clk(clk), .reset(reset), .Instruction_out(Instruction_out),.control_signals_out(control_signals_out),
   .PC_out_to_ssd(PC_out_to_ssd), .PC_4_out(PC_4_out), .PC_adder_ssd(PC_adder_ssd), .PC_in_to_ssd(PC_in_to_ssd),
     .rs1_data(rs1_data), .rs2_data(rs2_data), .write_data_to_ssd(write_data_to_ssd), .Imm_to_ssd(Imm_to_ssd), .shift_out_to_ssd(shift_out_to_ssd), .muxALU_to_ssd(muxALU_to_ssd), .ALU_to_ssd(ALU_to_ssd), .dataMem_to_ssd(dataMem_to_ssd));
    
    
  reg [12:0] sevensegment;
  
  always @ (posedge clk) begin
      case (ledSel)
          2'b00: leds = Instruction_out[15:0];
          2'b01: leds = Instruction_out[31:16];
          2'b10: leds = {2'b00, control_signals_out}; 
      endcase
      
      case (ssdSel)
            4'b0000: sevensegment = PC_out_to_ssd[12:0];
            4'b0001: sevensegment = PC_4_out[12:0];
            4'b0010: sevensegment = PC_adder_ssd[12:0];
            4'b0011: sevensegment = PC_in_to_ssd[12:0];
            4'b0100: sevensegment = rs1_data[12:0];
            4'b0101: sevensegment = rs2_data[12:0];
            4'b0110: sevensegment = write_data_to_ssd[12:0];
            4'b0111: sevensegment = Imm_to_ssd[12:0];
            4'b1000: sevensegment = shift_out_to_ssd[12:0];
            4'b1001: sevensegment = muxALU_to_ssd[12:0];
            4'b1010: sevensegment = ALU_to_ssd[12:0];
            4'b1011: sevensegment = dataMem_to_ssd[12:0];
            default: sevensegment = 13'b0;
        endcase
    end
  
  SSD ssd(.clk(ssdClk), .num(sevensegment), .Anode(Anode), .LED_out(LED_out));   
     
endmodule
