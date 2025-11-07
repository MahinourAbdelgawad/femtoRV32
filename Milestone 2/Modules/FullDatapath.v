`timescale 1ns / 1ps
`include "defines.v"
/*******************************************************************
*
* Module: FullDataPath.v
* Project: femtorv32
* Authors: Mahinour Abdelgawad mahinourabdelgawad@aucegypt.edu
           Joudy ElGayar Joudyelgayar@aucegypt.edu
           
* Description: The full datapath that integrates all the modules

* Change history: 28/10/2025 - Created module 
*                 7/11/2025 - (1) Replaced ALU with the new one
*                             (2) added wires to decode func3 and func7
*                             (2) included defines file and cleaned up the module
*                             (3) Updated module to suppot B Type
*                                   --> integrated branch control unit
*                                   --> replaced the 2x1 PC_mux with a 4x1 mux
*                             (6) Updated module to support JALR and JAL
*                                   --> added jump signal and another ALUSrc to control unit
*                                   --> added a second 2x1 mux for alu source
*                                   --> replaced 2x1 writeback mux with a 4x1
* Unresolved: Missing parameter in ALU
**********************************************************************/

module FullDatapath(
    input clk,               
    input reset,
    output [31:0] Instruction_out,
    output [15:0] control_signals_out,
    output [31:0] PC_out_to_ssd, PC_4_out, PC_adder_ssd, PC_in_to_ssd,
     rs1_data, rs2_data, write_data_to_ssd, Imm_to_ssd, shift_out_to_ssd, muxALU_to_ssd, ALU_to_ssd, dataMem_to_ssd                                             
);

    // =====================================================================
    /** INSTRUCTION DECODING **/
    wire [4:0] opcode;
    wire [31:0] rs_1, rs_2, rd;
    wire [2:0] func3;
    wire [6:0] func7; 
    
    
    /* Major module outputs */
    wire [31:0] PC_in, PC_out, Instruction, Imm, ALUResult;
    
    /* Control Unit signals */
    wire Branch, MemRead, MemWrite, ALUSrc_1, ALUSrc_2, RegWrite, Jump;
    wire [1:0] ALUOp, MemtoReg;
    

    /* ALU control signal */
    wire [3:0] ALUcontrol_out;
    
    
    /* Branch Control unit signal */
    wire BranchControl_out;
    
    
    /* ALU Flags */
    wire zeroFlag, sFlag, cFlag, vFlag;
    
    
    wire [31:0] Shift_out;
    wire [31:0] write_data;
    wire [31:0] MuxALU_1_out, MuxALU_2_out;
    wire [31:0] DataMemOut;
    wire and_out;
    wire [31:0]adder_out;
    wire [31:0] PC_adder_out;
    // =====================================================================
    

    assign func3 = Instruction[`IR_funct3];
    assign func7 = Instruction[`IR_funct7];
    

    // =====================================================================
    /* MODULE INSTANCES */
    PC pc(.D(PC_in), .clk(clk), .load(1'b1), .rst(reset), .Q(PC_out));
    
    InstMem IM(.addr(PC_out[7:2]), .data_out(Instruction));
    
    ControlUnit CU(.inst(Instruction[6:2]), 
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc_1(ALUSrc_1),
        .ALUSrc_2(ALUSrc_2),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ALUOp(ALUOp));
        
        
    ImmGen IG(.gen_out(Imm), .inst(Instruction));
    
    RegisterFile RF(.read_reg1(Instruction[19:15]), 
        .read_reg2(Instruction[24:20]), 
        .read_data1(rs_1), 
        .read_data2(rs_2),
        .write_reg(Instruction[11:7]),
        .write_data(write_data),
        .regWrite(RegWrite),
        .clk(clk),
        .rst(reset));
     
     mux_2x1 MuxALU_1(.A(rs_1),.B(PC_out),.sel(ALUSrc_1),.out(MuxALU_1_out));   
     mux_2x1 MuxALU_2(.A(rs_2),.B(Imm),.sel(ALUSrc_2),.out(MuxALU_2_out));
     
//     ALU alu(.A(rs_1), 
//        .B(MuxALU_out), 
//        .sel(ALUcontrol_out), 
//        .result(ALUResult), 
//        .flag(zeroFlag));


// *********** MISSING PARAMETER IN ALU: shamt COMPLETE WHEN ADDING SHIFT SUPPORT!!!!******************
      prv32_ALU ALU(.a(MuxALU_1_out),
           .b(MuxALU_2_out), 
           .shamt(),  // HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
           .r(ALUResult), 
           .cf(cFlag), 
           .zf(zeroFlag), 
           .vf(vFlag), 
           .sf(sFlag), 
           .alufn(ALUcontrol_out));
     
    
    BranchControlUnit BranchControlUnit(.func3(func3),
                      .Z(zeroFlag),
                      .C(cFlag),
                      .V(vFlag),
                      .S(sFlag),
                      .Branch(Branch),
                      .Branch_output(BranchControl_out));
     
    ALUControlUnit ALUControl(.ALUOp(ALUOp), 
        .inst14_12(Instruction[14:12]), 
        .inst_30(Instruction[30]), 
        .ALU_sel(ALUcontrol_out));
        
   DataMem DM(.clk(clk),.MemRead(MemRead),.MemWrite(MemWrite),.addr(ALUResult[7:2]),.data_in(rs_2),.data_out(DataMemOut));     
    
//   mux_2x1 MUX_writeback(.A(ALUResult),.B(DataMemOut),.sel(MemtoReg),.out(write_data));
// *********** MISSING PARAMETER IN MUX_WRITEBACK: C COMPLETE WHEN ADDING U TYPE SUPPORT!!!!******************
     mux_4x1 MUX_writeback(.A(PC_adder_out), //PC + 4 -- 00
             .B(DataMemOut), // from data memory -- 01
             .C(ALUResult), //from ALU -- 10
             .D(), // MISSING PARAMETER -- ADD THIS WITH LUI/AUIPC
             .sel(MemtoReg),
             .out(write_data));
    
   assign and_out = Branch & zeroFlag;
    
   ShiftLeft #(32) SL(.num(Imm), .out(Shift_out));
   
   RCA #(32) adder(.A(PC_out),.B(Shift_out),.sum(adder_out),.Cout());
   
   // mux_2x1 PCMux(.A(PC_adder_out),.B(adder_out),.sel(and_out),.out(PC_in));
   
   mux_4x1 PCMux(.A(PC_adder_out), //PC+4 -- 00
           .B(adder_out), //Branch target -- 01
           .C(ALUResult), // Jump Target -- 10
           .D(), //unnecessary input, keep empty -- 11
           .sel({Jump, BranchControl_out}), 
           .out(PC_in));
           
   
   RCA #(32) PC_adder(.A(PC_out),.B(32'd4), .sum(PC_adder_out),.Cout());
   // =====================================================================
    
    
   // =====================================================================
   /* OUTPUTS FOR FPGA IMPLEMENTATION */
   assign Instruction_out = Instruction;
   assign control_signals_out = {ALUcontrol_out, zeroFlag, and_out, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc_1, ALUSrc_2, RegWrite};
   
   assign PC_out_to_ssd =PC_out ;
   assign PC_4_out = PC_adder_out;
   assign PC_adder_ssd = adder_out ;
   assign PC_in_to_ssd = PC_in;
   assign rs1_data =rs_1 ;
   assign rs2_data = rs_2 ;
   assign write_data_to_ssd =write_data ;
   assign Imm_to_ssd = Imm;
   assign shift_out_to_ssd =Shift_out ;
   assign muxALU_to_ssd = MuxALU_2_out ;
   assign ALU_to_ssd = ALUResult;
   assign dataMem_to_ssd =DataMemOut ;
   // =====================================================================
     
endmodule
