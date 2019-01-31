`timescale 1ns / 1ps

module ExtRefTest5M (
        input clk100_i,        // 100 MHz clock from oscillator on board
        input rst_pbn_i,        // reset signal, active low, from CPU RESET pushbutton //
        input [15:0] switches_i,
        output [2:0] led_o,
        output [6:0] ra_o,
		input ra_i, // external reference
        output [7:0] segment_o,
        output [7:0] digit_o        
    );

    localparam ACCUM_WIDTH = 12;
	localparam BIAS = 12'd154;
    
	wire reset_x;
 
	wire ext_reference_x;
    wire gen_reference_x;
    wire clk5_x;
    wire clk5_0_x;
    wire clk5_45_x;
    wire clk5_90_x;
    wire clk5_135_x;

    wire clk258_x;

    wire [ACCUM_WIDTH-1:0] ref_sel_c;

    wire [3:0] kp_sel_x;
    wire [3:0] ki_sel_x;
    wire [7:0] kp_ki_c;

    wire signed [7:0] error_x;
    wire [7:0] error_hex_x;

    assign ref_sel_c = 12'd80;
    
    assign kp_sel_x = switches_i[11:8];
    assign ki_sel_x = switches_i[3:0];
	
	assign ext_reference_x = ra_i;

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
    assign ra_o[1] = gen_reference_x;
    assign ra_o[2] = ext_reference_x;

    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) referenceOsc (
        .enable_i(1'b1),
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .clk_o(gen_reference_x),
        .k_val_i(ref_sel_c)
    ); 

    wire [5:0] padded_kp_c;
    wire [4:0] padded_ki_c;
    assign padded_kp_c = {2'b00,kp_sel_x}; //opt is 5'b0 1001
    assign padded_ki_c = {1'b0,ki_sel_x}; //opt is 8'b0000 0001

	RingADPLL #(
        .BIAS(BIAS),
        //.KP(5'b00001),
        .KP_WIDTH(6),
        .KP_FRAC_WIDTH(0),
        .KI_WIDTH(5),
        .KI_FRAC_WIDTH(0),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1)  
    ) 
    adpll
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .ref_clk_i(gen_reference_x),
        .enable_i(switches_i[0]),
        .gen_clk_o(ra_o[0]),
        .error_o(error_x),
        .kp_i(padded_kp_c),
        .ki_i(padded_ki_c)
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