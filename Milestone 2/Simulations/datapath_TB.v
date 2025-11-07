`timescale 1ns / 1ps

/*******************************************************************
*
* Module: datapath_TB.v
* Project: femtorv32
* Authors: Mahinour Abdelgawad mahinourabdelgawad@aucegypt.edu
           Joudy ElGayar Joudyelgayar@aucegypt.edu
           
* Description: Testbench to test the FullDataPath module

* Change history: 28/10/2025 - Created module           
**********************************************************************/

module datapath_TB();
    reg clk, reset;
    
    FullDatapath datapath (
        .clk(clk),
        .reset(reset),
        .Instruction_out(),
        .control_signals_out(),
        .PC_out_to_ssd(),
        .PC_4_out(),
        .PC_adder_ssd(),
        .PC_in_to_ssd(),
        .rs1_data(),
        .rs2_data(),
        .write_data_to_ssd(),
        .Imm_to_ssd(),
        .shift_out_to_ssd(),
        .muxALU_to_ssd(),
        .ALU_to_ssd(),
        .dataMem_to_ssd()
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        reset = 1;
        #10;
        reset = 0;
        
    end
endmodule
