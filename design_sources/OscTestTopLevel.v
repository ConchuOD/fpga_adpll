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
	wire f_sel_sw_ro_c;
    wire enable_r = 1'b1;

    
    //assign inputs
    assign f_sel_sw_ro_c = switches_i[15:12]; //TODO 4' variation
    assign f_sel_sw_pa_c = switches_i[8:0]; // 9' number, 10' counter

    //assign outputs
    assign ra_o = {6'b0, clk_ro_c, clk_pa_c};
    assign led_o = {1'b0, clk_ro_c, clk_pa_c};

    //*/
    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) testOsc (
                .enable_i (enable_r),
                .reset_i (rstPBn_i),
                .fpga_clk_i (clk100_i),
				.clk_o (clk_pa_c),
				.k_val_i (f_sel_sw_pa_c)
				);  // segment
				//*/
	///*			
    RingOsc testRing( 
				.enable_i (enable_r),
    			.freq_sel_i (f_sel_sw_ro_c),
    			.clk_o (clk_ro_c)
   				);
   				//*/
    
endmodule
