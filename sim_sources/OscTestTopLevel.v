`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2018 16:21:25
// Design Name: 
// Module Name: OscTestTopLevel
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module OscTestTopLevel(
        input clk100_i,        // 100 MHz clock from oscillator on board
        input rstPBn_i,        // reset signal, active low, from CPU RESET pushbutton //
        input [15:0] switches_i,
        output [2:0] led_o,
        output [7:0] ra_o,
        output [7:0] segment_o,
        output [7:0] digit_o        
        );
	
	localparam ACCUM_WIDTH = 10;
	wire clk_pa_c;
	wire clk_ro_c;
	wire f_sel_sw_pa_c;
	wire [3:0] f_sel_sw_ro_c;
    wire enable_r = 1'b1;
    wire reset_c;
    wire clk5_c;

    
    //assign inputs
    assign f_sel_sw_ro_c = switches_i[15:12]; //TODO 4' variation
    assign f_sel_sw_pa_c = switches_i[8:0]; // 9' number, 10' counter

    //assign outputs
    assign ra_o = {6'b0, clk_ro_c, clk_pa_c};
    assign led_o = {1'b0, clk_ro_c, clk_pa_c};

    // Instantiate clock and reset generator, connect to signals
    clockReset  clkGen  (
            .clk100 (clk100_i),       // input clock at 100 MHz
            .rstPBn (rstPBn_i),       // input reset, active low
            .clk5   (clk5_c),         // output clock, 5 MHz
            .reset  (reset_c) );      // output reset, active high
   
    displayInterface disp1 (
				.clock(clk5_c), 			// 5 MHz clock signal
				.reset(reset_c), 		// reset signal, active high
				.value(switches_i),     // input value to be displayed
				.point(4'b1111),	// radix markers to be displayed
				.digit(digit_o),  		// digit outputs
				.segment(segment_o));  // segment outputs
    /*
    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) testOsc (
                .enable_i (enable_r),
                .reset_i (reset_c),
                .fpga_clk_i (clk100_i),
				.clk_o (clk_pa_c),
				.k_val_i (f_sel_sw_pa_c)
				);  // segment
				*/
	///*			
    RingOsc testRing( 
				.enable_i (enable_r),
    			.freq_sel_i (f_sel_sw_ro_c),
    			.clk_o (clk_ro_c)
   				);
   				//*/
    
endmodule
