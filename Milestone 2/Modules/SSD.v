`timescale 1ns / 1ps

module SSD (
    input        clk,            
    input  [12:0] num,           
    output reg [3:0] Anode,      
    output reg [6:0] LED_out    
);
    
    wire [3:0] bcd_thousands, bcd_hundreds, bcd_tens, bcd_ones;

    BCD b2bcd (
        .num(num),
        .Thousands(bcd_thousands),
        .Hundreds(bcd_hundreds),
        .Tens(bcd_tens),
        .Ones(bcd_ones)
    );

    reg  [3:0] LED_BCD;
    reg  [19:0] refresh_counter = 20'd0; 
    wire [1:0]  LED_activating_counter;

    
    always @(posedge clk)
        refresh_counter <= refresh_counter + 1;

    assign LED_activating_counter = refresh_counter[19:18];

    
    always @* begin
        case (LED_activating_counter)
            2'b00: begin
                Anode   = 4'b0111;     
                LED_BCD = bcd_thousands;
            end
            2'b01: begin
                Anode   = 4'b1011;      // hundreds
                LED_BCD = bcd_hundreds;
            end
            2'b10: begin
                Anode   = 4'b1101;      // tens
                LED_BCD = bcd_tens;
            end
            2'b11: begin
                Anode   = 4'b1110;      // ones
                LED_BCD = bcd_ones;
            end
        endcase
    end

    // 7-seg decoder for common-anode (segments active LOW)
    always @* begin
        case (LED_BCD)
            4'b0000: LED_out = 7'b0000001; // 0
            4'b0001: LED_out = 7'b1001111; // 1
            4'b0010: LED_out = 7'b0010010; // 2
            4'b0011: LED_out = 7'b0000110; // 3
            4'b0100: LED_out = 7'b1001100; // 4
            4'b0101: LED_out = 7'b0100100; // 5
            4'b0110: LED_out = 7'b0100000; // 6
            4'b0111: LED_out = 7'b0001111; // 7
            4'b1000: LED_out = 7'b0000000; // 8
            4'b1001: LED_out = 7'b0000100; // 9
            default: LED_out = 7'b0000001; // 0 (fallback)
        endcase
    end
endmodule


module BCD (
    input  [12:0] num,                  
    output reg [3:0] Thousands,
    output reg [3:0] Hundreds,
    output reg [3:0] Tens,
    output reg [3:0] Ones
);
    integer i;
    always @* begin
        
        Thousands = 4'd0;
        Hundreds  = 4'd0;
        Tens      = 4'd0;
        Ones      = 4'd0;

        
        for (i = 12; i >= 0; i = i - 1) begin
            if (Thousands >= 5) Thousands = Thousands + 3;
            if (Hundreds  >= 5) Hundreds  = Hundreds  + 3;
            if (Tens      >= 5) Tens      = Tens      + 3;
            if (Ones      >= 5) Ones      = Ones      + 3;

            Thousands = Thousands << 1;  Thousands[0] = Hundreds[3];
            Hundreds  = Hundreds  << 1;  Hundreds[0]  = Tens[3];
            Tens      = Tens      << 1;  Tens[0]      = Ones[3];
            Ones      = Ones      << 1;  Ones[0]      = num[i];
        end
    end
endmodule