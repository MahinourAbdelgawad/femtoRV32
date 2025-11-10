`timescale 1ns / 1ps
`include "defines.v" 

module ImmGen(
    output reg [31:0] gen_out,
    input [31:0] inst
    );
    
    wire [6:0] opcode;
    
    assign opcode = inst[`IR_opcode];
    
    always @ (*) begin
        case (opcode)
            
            `OPCODE_Load: begin
                gen_out = {{20{inst[31]}}, inst[31:20]};
            end

            `OPCODE_Store: begin
                gen_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end

            // SB-type 
            `OPCODE_Branch: begin
                gen_out = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8]};
            end
            
            `OPCODE_Arith_I: begin
                gen_out = {{20{inst[31]}}, inst[31:20]};
            end
            
            `OPCODE_JALR: begin
                gen_out = {{20{inst[31]}}, inst[31:20]};
            end
            
            `OPCODE_JAL: begin
                gen_out = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            end
            
             `OPCODE_LUI, `OPCODE_AUIPC: begin
                gen_out = {inst[31:12], 12'b0};
            end
            

            default: begin
                gen_out = 32'b0; 
            end
        endcase 
    
    end
endmodule