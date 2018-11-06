`timescale 1ns / 1ps

module PhDetTopLevel(
        input clk100_i,        // 100 MHz clock from oscillator on board
        input rst_pbn_i,        // reset signal, active low, from CPU RESET pushbutton //
        input [15:0] switches_i,
        output [2:0] led_o,
        output [7:0] ra_o,
        output [7:0] segment_o,
        output [7:0] digit_o        
    );

	wire reset_x;
 
    wire clk5_x;
    wire clk400_x;

    wire signed [7:0] error_x;
    wire [7:0] error_hex_x;

    ClockReset5_400  clkGen  (
        .clk100_i 	(clk100_i),      // input clock at 100 MHz
        .rst_pbn_i 	(rst_pbn_i),     // input reset, active low
        .clk5_o   	(clk5_x),        // output clock, 5 MHz
        .clk400_o	(clk400_x),
        .reset_o  	(reset_x)     	 // output reset, active high
    );

    ADPLL adpll (
    	.reset_i(reset_x),
    	.fpga_clk_i(clk400_x),
    	.ref_clk_i(clk5_x),
        .enable_i(1'b1),
    	.gen_clk_o(),
    	.error_o(error_x)
    );

    SignedDec2Hex sDec2Hex(
        .signed_dec_i(error_x),
        .hex_o(error_hex_x)
    );

    //2s to unsigned to hex to seg lol
    DisplayInterface disp1 (
        .clock 		(clk5_x),       // 5 MHz clock signal
        .reset 		(reset_x),      // reset signal, active high
        .value 		(error_hex_x),   // input value to be displayed
        .point 		(4'b1111),    	// radix markers to be displayed
        .digit 		(digit_o),      // digit outputs
        .segment 	(segment_o)  	// segment outputs
    );

 endmodule // PhDetTopLevel