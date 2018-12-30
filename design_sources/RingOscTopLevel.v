`timescale 1ns / 1ps

module RingOscTopLevel(
        input clk100_i,        // 100 MHz clock from oscillator on board
        input rst_pbn_i,        // reset signal, active low, from CPU RESET pushbutton //
        input [15:0] switches_i,
        output [2:0] led_o,
        output [7:0] ra_o,
        output [7:0] segment_o,
        output [7:0] digit_o        
    );
    
    localparam ACCUM_WIDTH = 12;
    wire clk_pa_x;
    wire clk_ro_x;
    wire [8:0] f_sel_sw_pa_x;
    wire [3:0] f_sel_sw_ro_x;
    wire enable_ro_x;
    wire enable_pd_x;
    wire enable_pa_x;
    wire reset_x;
    wire clk5_x;
    wire clk160_x;
    
    //assign inputs
    assign f_sel_sw_ro_x[3:2] = switches_i[15:14];
    assign f_sel_sw_ro_x[0] = 1'b0; 
    //12&13 unused due to 1 bit PD control
    assign enable_ro_x = switches_i[11];
    assign enable_pd_x = switches_i[10];
    assign enable_pa_x = switches_i[9];
    assign f_sel_sw_pa_x = switches_i[8:0]; 

    //assign outputs
    assign ra_o = {6'b0, clk_ro_x, clk_pa_x};
    assign led_o = {1'b0, clk_ro_x, clk_pa_x};

    // Instantiate clock and reset generator, connect to signals
    ClockReset  clkGen  (
        .clk100_i 	(clk100_i),      // input clock at 100 MHz
        .rst_pbn_i 	(rst_pbn_i),     // input reset, active low
        .clk5_o   	(clk5_x),        // output clock, 5 MHz
        .clk160_o	(clk160_x),
        .reset_o  	(reset_x)     	 // output reset, active high
    );
    DisplayInterface disp1 (
        .clock 		(clk5_x),       // 5 MHz clock signal
        .reset 		(reset_x),      // reset signal, active high
        .value 		(switches_i),   // input value to be displayed
        .point 		(4'b1111),    	// radix markers to be displayed
        .digit 		(digit_o),      // digit outputs
        .segment 	(segment_o)  	// segment outputs
    );
    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) testOsc (
        .enable_i (enable_pa_x),
        .reset_i (reset_x),
        .fpga_clk_i (clk160_x),
        .clk_o (clk_pa_x),
        .k_val_i (f_sel_sw_pa_x)
	);             
    RingOsc testRing( 
        .enable_i (enable_ro_x),
        .freq_sel_i (f_sel_sw_ro_x),
        .clk_o (clk_ro_x)
    );
    BangBangPD basicPD( //1 bit only, 
        .enable_i(enable_pd_x),
        .ref_i(clk_pa_x),
        .gen_i(clk_ro_x),
        .reset_i(reset_x),
        .pd_out_o(f_sel_sw_ro_x[1])
    );  
endmodule
