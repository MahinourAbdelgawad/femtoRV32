`timescale 1ns / 1ps

module ImmGen(
    output reg [31:0] gen_out,
    input [31:0] inst
    );
    
    wire [6:0] opcode;
    
    assign opcode = inst[6:0];
    
    always @ (*) begin
        case (opcode)
            
            7'b0000011: begin
                gen_out = {{20{inst[31]}}, inst[31:20]};
            end

            // S-type 
            7'b0100011: begin
                gen_out = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end

            // SB-type 
            7'b1100011: begin
                gen_out = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8]};
            end

            default: begin
                gen_out = 32'b0; 
            end
        endcase 
    
    end
endmodule