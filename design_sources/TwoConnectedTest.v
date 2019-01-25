`timescale 1ns / 1ps

module TwoConnectedTest (
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
	localparam BIAS = 12'd154; //154 = 10 MHz
	localparam PDET_WITH = 8;
    //optimal gains => kp @ 1.4 = 1000 lower
    //                 ki @ 1.8 = 1000 lower 
    
	wire reset_x;
 
	wire ext_reference_x;
    wire gen_reference_x;
	
    wire ref_adpll_div8_x;
    wire other_adpll_div8_x;
	
	wire ref_adpll_gen_x;
	wire other_adpll_gen_x;

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

    wire signed [7:0] ref_adpll_error_x;
	wire signed [7:0] other_adpll_error_x;

    wire [7:0] half_7seg_x;

    assign ref_sel_c = 12'd36;
	
	assign ext_reference_x = ra_i;

    assign kp_sel_x = switches_i[11:8];
    assign ki_sel_x = switches_i[3:0];
    assign kp_ki_c = {kp_sel_x,ki_sel_x};


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
    assign ra_o[0] = ref_adpll_gen_x;
    assign ra_o[1] = gen_reference_x;
    assign ra_o[2] = ext_reference_x;
    assign ra_o[4] = other_adpll_gen_x;

    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) referenceOsc (
        .enable_i(1'b1),
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .clk_o(gen_reference_x),
        .k_val_i(ref_sel_c)
    ); 

    wire [5-1:0] padded_kp_c;
    wire [9-1:0] padded_ki_c;
    assign padded_kp_c = {1'b0,kp_sel_x}; //opt is 5'b0 1001
    assign padded_ki_c = {5'b00000,ki_sel_x}; //opt is 8'b0000 0001
	
	PhaseDetector #(.WIDTH(PDET_WITH)) refPDet ( // output to ref_adpll
		.reset_i(reset_x), 
		.fpga_clk_i(clk258_x),
		.reference_i(ext_reference_x),
		.generated_i(ref_adpll_div8_x),
		.pd_clock_cycles_o(ref_adpll_error_x)
	);
	
	ADPLLwNoPDet #(
        .BIAS(BIAS),
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(9),
        .KI_FRAC_WIDTH(8),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1) 
    ) 
    refAdpll
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .enable_i(switches_i[15]),
		.error_top_x(8'd0),
		.error_right_x(~other_adpll_error_x), //replace this w/ ~other_adpll_error_x
		.error_bottom_x(8'd0),
		.error_left_x(ref_adpll_error_x),
        .gen_clk_o(ref_adpll_gen_x),
        .gen_div8_o(ref_adpll_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

	(* DONT_TOUCH = "TRUE" *) 
    PhaseDetector #(.WIDTH(PDET_WITH)) otherPDet ( // output to other, complement to ref_adpll
		.reset_i(reset_x), 
		.fpga_clk_i(clk258_x),
		.reference_i(ref_adpll_div8_x),
		.generated_i(other_adpll_div8_x),
		.pd_clock_cycles_o(other_adpll_error_x)
	);
	
	ADPLLwNoPDet #(
        .BIAS(BIAS-1), //spice it up
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(9),
        .KI_FRAC_WIDTH(8),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1) 
    ) 
    otherAdpll
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .enable_i(switches_i[15]),
		.error_top_x(8'd0),
		.error_right_x(other_adpll_error_x), //replace this w/ 8'b0
		.error_bottom_x(8'd0),
		.error_left_x(other_adpll_error_x),
        .gen_clk_o(other_adpll_gen_x),
        .gen_div8_o(other_adpll_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

    SignedDec2Hex sDec2Hex(
        .signed_dec_i(kp_ki_c),
        .hex_o(half_7seg_x)
    );

    //2s to unsigned to hex to seg lol
    DisplayInterface disp1 (
        .clock 		(clk5_0_x),       // 5 MHz clock signal
        .reset 		(reset_x),      // reset signal, active high
        .value 		(half_7seg_x),   // input value to be displayed
        .point 		(4'b1111),    	// radix markers to be displayed
        .digit 		(digit_o),      // digit outputs
        .segment 	(segment_o)  	// segment outputs
    );

 endmodule // end of module TwoConnectedTest
 
 /*
	ADPLLw2Inputs #(
        .BIAS(BIAS),
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(8),
        .KI_FRAC_WIDTH(7),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1) 
    ) 
    refAdpll
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .ref_clk_i(ext_reference_x),
        .other_clk_i(other_adpll_div8_x),
        .enable_i(switches_i[15]),
        .gen_clk_o(ra_o[0]),
        .gen_div8_o(ref_adpll_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

	ADPLL #(
		.BIAS(BIAS),
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(8),
        .KI_FRAC_WIDTH(7),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1)	
	) 
	adpll
	(
    	.reset_i(reset_x),
    	.fpga_clk_i(clk258_x),
    	.ref_clk_i(ref_adpll_div8_x),
        .enable_i(switches_i[15]),
    	.gen_clk_o(ra_o[4]),
        .gen_div8_o(other_adpll_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );
*/