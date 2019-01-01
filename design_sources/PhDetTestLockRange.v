`timescale 1ns / 1ps

module PhDetTestLockRange (
        input clk100_i,        // 100 MHz clock from oscillator on board
        input rst_pbn_i,        // reset signal, active low, from CPU RESET pushbutton //
        input [15:0] switches_i,
        output [2:0] led_o,
        output [7:0] ra_o,
        output [7:0] segment_o,
        output [7:0] digit_o        
    );

    localparam ACCUM_WIDTH = 12;
    
	wire reset_x;
 
    wire gen_reference_x;
    wire clk5_x;
    wire clk5_0_x;
    wire clk5_45_x;
    wire clk5_90_x;
    wire clk5_135_x;

    wire clk258_x;

    wire [ACCUM_WIDTH-1:0] ref_sel_c;

    wire signed [7:0] error_x;
    wire [7:0] error_hex_x;

    assign ref_sel_c = switches_i[ACCUM_WIDTH-1:0];

    ClockReset5_258_PDiff  clkGen  (
        .clk100_i 	(clk100_i),      // input clock at 100 MHz
        .rst_pbn_i 	(rst_pbn_i),     // input reset, active low
        .clk5_0_o  	(clk5_0_x),
        .clk5_45_o  (clk5_45_x),
        .clk5_90_o  (),
        .clk5_135_o (),
        .clk258_o	(clk258_x),
        .reset_o  	(reset_x)     	 // output reset, active high
    );

    assign clk5_x = clk5_0_x;
    assign ra_o[1] = clk5_x;
    assign ra_o[2] = gen_reference_x;

    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) referenceOsc (
        .enable_i(1'b1),
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .clk_o(gen_reference_x),
        .k_val_i(ref_sel_c)
    ); 

    RingADPLL adpll (
    	.reset_i(reset_x),
    	.fpga_clk_i(clk258_x),
    	.ref_clk_i(gen_reference_x),
        .enable_i(1'b1),
    	.gen_clk_o(ra_o[0]),
    	.error_o(error_x)
    );

    SignedDec2Hex sDec2Hex(
        .signed_dec_i(error_x),
        .hex_o(error_hex_x)
    );

    //2s to unsigned to hex to seg lol
    DisplayInterface disp1 (
        .clock 		(clk5_0_x),       // 5 MHz clock signal
        .reset 		(reset_x),      // reset signal, active high
        .value 		(error_hex_x),   // input value to be displayed
        .point 		(4'b1111),    	// radix markers to be displayed
        .digit 		(digit_o),      // digit outputs
        .segment 	(segment_o)  	// segment outputs
    );

 endmodule // PhDetTopLevel