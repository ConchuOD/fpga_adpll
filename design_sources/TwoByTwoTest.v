`timescale 1ns / 1ps

module TwoByTwoTest (
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
	localparam PDET_WIDTH = 8;
    //optimal gains => kp @ 1.4 = 1000 lower
    //                 ki @ 1.8 = 1000 lower 
    
	wire reset_x;
 
	wire ext_reference_x;
    wire gen_reference_x;
	
    wire adpll_11_gen_x;
    wire adpll_11_div8_x;
    wire [PDET_WIDTH-1:0] adpll_11_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_11_error_left_x;

    wire adpll_12_gen_x;
    wire adpll_12_div8_x;
    wire [PDET_WIDTH-1:0] adpll_12_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_12_error_left_x;

    wire adpll_21_gen_x;
    wire adpll_21_div8_x;
    wire [PDET_WIDTH-1:0] adpll_21_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_21_error_left_x;

    wire adpll_22_gen_x;
    wire adpll_22_div8_x;
    wire [PDET_WIDTH-1:0] adpll_22_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_22_error_left_x;

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

    wire enable_x = switches_i[15];
    wire uni_dir_x = switches_i[14];

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
    assign ra_o[0] = adpll_11_gen_x;
    assign ra_o[1] = gen_reference_x;
    assign ra_o[2] = ext_reference_x;
    assign ra_o[4] = adpll_12_gen_x;
    assign ra_o[5] = adpll_21_gen_x;
    assign ra_o[6] = adpll_22_gen_x;

    NetworkADPLL #(
        .BIAS(BIAS),
        .PDET_WITH(PDET_WIDTH),
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(9),
        .KI_FRAC_WIDTH(8),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1) 
    ) 
    adpll_11
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .enable_i(enable_x),
        .error_right_i(~adpll_12_error_left_x), //adpll12
        .error_bottom_i(~adpll_21_error_above_x), //adpll21
        .ref_left_i(ext_reference_x), //reference
        .ref_top_above_i(0'b0), //unused so just looping back
        .weight_left_i(3'b001),
        .weight_above_i(3'b000),
        .weight_right_i(3'b001),
        .weight_below_i(3'b001), 
        .error_left_o(adpll_11_error_left_x),
        .error_above_o(adpll_11_error_top_x),       
        .gen_clk_o(adpll_11_gen_x),
        .gen_div8_o(adpll_11_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

    NetworkADPLL #(
        .BIAS(BIAS+1),
        .PDET_WITH(PDET_WIDTH),
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(9),
        .KI_FRAC_WIDTH(8),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1) 
    ) 
    adpll_12
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .enable_i(switches_i[15]),
        .error_right_i({(PDET_WIDTH){1'b0}}), //nothing
        .error_bottom_i(~adpll_22_error_above_x), //adpll21
        .ref_left_i(adpll_11_div8_x), //adpll11
        .ref_top_above_i(1'b0), //unused so just looping back
        .weight_left_i(3'b010),
        .weight_above_i(3'b000),
        .weight_right_i(3'b000),
        .weight_below_i(3'b010), 
        .error_left_o(adpll_12_error_left_x),
        .error_above_o(adpll_12_error_top_x),       
        .gen_clk_o(adpll_12_div8_x),
        .gen_div8_o(adpll_12_gen_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

    NetworkADPLL #(
        .BIAS(BIAS+2),
        .PDET_WITH(PDET_WIDTH),
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(9),
        .KI_FRAC_WIDTH(8),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1) 
    ) 
    adpll_21
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .enable_i(switches_i[15]),
        .error_right_i(~adpll_22_error_left_x), //adpll12
        .error_bottom_i({(PDET_WIDTH){1'b0}}), //nothing
        .ref_left_i(1'b0), //nothing
        .ref_top_above_i(adpll_11_div8_x),
        .weight_left_i(3'b000),
        .weight_above_i(3'b010),
        .weight_right_i(3'b010),
        .weight_below_i(3'b000), 
        .error_left_o(adpll_21_error_left_x),
        .error_above_o(adpll_21_error_top_x),       
        .gen_clk_o(adpll_21_gen_x),
        .gen_div8_o(adpll_21_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );
    NetworkADPLL #(
        .BIAS(BIAS-1),
        .PDET_WITH(PDET_WIDTH),
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(9),
        .KI_FRAC_WIDTH(8),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1) 
    ) 
    adpll_22
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .enable_i(switches_i[15]),
        .error_right_i({(PDET_WIDTH){1'b0}}), //adpll12
        .error_bottom_i({(PDET_WIDTH){1'b0}}), //adpll21
        .ref_left_i(adpll_21_div8_x), //reference
        .ref_top_above_i(adpll_12_div8_x), //unused so just looping back
        .weight_left_i(3'b010),
        .weight_above_i(3'b010),
        .weight_right_i(3'b000),
        .weight_below_i(3'b000), 
        .error_left_o(adpll_22_error_left_x),
        .error_above_o(adpll_22_error_top_x),       
        .gen_clk_o(adpll_22_gen_x),
        .gen_div8_o(adpll_22_div8_x),
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

 endmodule // end of module TwoByTwoTest