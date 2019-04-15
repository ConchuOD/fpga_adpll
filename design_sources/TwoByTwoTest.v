`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-February-2019                                               */
/* Function : 2x2 ADPLL network using FPGA clocked oscillator                */
/*****************************************************************************/
module TwoByTwoTest (
        input         clk100_i,         // 100 MHz clock from oscillator on board
        input         rst_pbn_i,        // reset signal, active low, from CPU RESET pushbutton //
        input         ra_i,             // external reference
        input  [15:0] switches_i,
        output [2:0]  led_o,
        output [6:0]  ra_o,
        output [7:0]  JB,
        output [7:0]  segment_o,
        output [7:0]  digit_o
    );
    
    /*************************************************************************/
    /* Define nets and assign outputs                                        */
    /*************************************************************************/

    localparam ACCUM_WIDTH = 12;
    localparam BIAS = 12'd77;
    localparam PDET_WIDTH = 8;
    localparam DCO_CC_WIDTH = 8;

    localparam KP_WIDTH = 6;
    localparam KP_FRAC_WIDTH = 5;
    localparam KI_WIDTH = 9;
    localparam KI_FRAC_WIDTH = 8;
    
    wire reset_x;
    
    //reference signals
 
    reg ext_reference_r;
    wire gen_reference_x;
    
    //ADPLL 11 connections
    wire adpll_11_gen_x;
    wire adpll_11_div8_x;
    wire [PDET_WIDTH-1:0] adpll_11_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_11_error_left_x;
    reg  [3:0] weight_left_11;
    reg  [3:0] weight_above_11;
    reg  [3:0] weight_right_11;
    reg  [3:0] weight_below_11;
    
    //ADPLL 12 connections
    wire adpll_12_gen_x;
    wire adpll_12_div8_x;
    wire [PDET_WIDTH-1:0] adpll_12_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_12_error_left_x;
    reg  [3:0] weight_left_12;
    reg  [3:0] weight_above_12;
    reg  [3:0] weight_right_12;
    reg  [3:0] weight_below_12;
    
    //ADPLL 21 connections
    wire adpll_21_gen_x;
    wire adpll_21_div8_x;
    wire [PDET_WIDTH-1:0] adpll_21_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_21_error_left_x;
    reg  [3:0] weight_left_21;
    reg  [3:0] weight_above_21;
    reg  [3:0] weight_right_21;
    reg  [3:0] weight_below_21;
    
    //ADPLL 22 connections
    wire adpll_22_gen_x;
    wire adpll_22_div8_x;
    wire [PDET_WIDTH-1:0] adpll_22_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_22_error_left_x;
    reg  [3:0] weight_left_22;
    reg  [3:0] weight_above_22;
    reg  [3:0] weight_right_22;
    reg  [3:0] weight_below_22;

    //clock outputsfrom clock manager
    wire clk5_x;
    wire clk5_0_x;
    wire clk5_45_x;
    wire clk5_90_x;
    wire clk5_135_x;
    wire clk258_x;

    //internal reference bias point
    wire [ACCUM_WIDTH-1:0] ref_sel_c;

    //Loop filter runtime game selection
    wire [3:0] kp_sel_x;
    wire [3:0] ki_sel_x;
    wire [7:0] kp_ki_c;
    wire [KP_WIDTH-1:0] padded_kp_c;
    wire [KI_WIDTH-1:0] padded_ki_c;

    //Output to 7 seg displays
    wire [7:0] half_7seg_x;

    //network configuration
    wire enable_x  = switches_i[15]; //0 disable,  1 enable
    wire uni_dir_x = switches_i[14]; //0 bi-dir,   1 uni-dir
    wire ref_sel_x = switches_i[13]; //0 internal, 1 external

    /*************************************************************************/
    /* Output assignments                                                    */
    /*************************************************************************/

    assign JB[6:0] = adpll_11_error_left_x[6:0]; 
    assign ra_o[0] = adpll_11_gen_x;
    assign ra_o[1] = gen_reference_x;
    assign ra_o[2] = ext_reference_r;
    assign ra_o[3] = adpll_11_div8_x;
    assign ra_o[4] = adpll_12_gen_x;
    assign ra_o[5] = adpll_21_gen_x;
    assign ra_o[6] = adpll_22_gen_x;

    /*************************************************************************/
    /* Continuous assignments                                                */
    /*************************************************************************/
    
    assign ref_sel_c = 12'd36;    
    assign clk5_x  = clk5_0_x;
    
    assign kp_sel_x    = switches_i[11:8];
    assign ki_sel_x    = switches_i[3:0];
    assign kp_ki_c     = {kp_sel_x,ki_sel_x};
    assign padded_kp_c = {{(KP_WIDTH-4){1'b0}},kp_sel_x};
    assign padded_ki_c = {{(KI_WIDTH-4){1'b0}},ki_sel_x};

    //clock input buffer register
    always @ (posedge clk258_x)
    begin
        ext_reference_r <= ra_i;
    end

    /*************************************************************************/
    /* Clock generation modules                                              */
    /*************************************************************************/

    ClockReset5_258_PDiff  clkGen  (
        .clk100_i   (clk100_i),      // input clock at 100 MHz
        .rst_pbn_i  (rst_pbn_i),     // input reset, active low
        .clk5_0_o   (clk5_0_x),
        .clk5_45_o  (clk5_45_x),
        .clk5_90_o  (),
        .clk5_135_o (),
        .clk258_o   (clk258_x),
        .reset_o    (reset_x)        // output reset, active high
    );

    //tunable internal reference provider
    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) referenceOsc (
        .enable_i(1'b1),
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .clk_o(gen_reference_x),
        .k_val_i(12'd20)
    );

    /*************************************************************************/
    /* ADPLL 11                                                              */
    /*************************************************************************/

    always @ (uni_dir_x)
    begin
        if(uni_dir_x)
        begin
            weight_left_11 = 4'd4;
            weight_above_11 = 4'd0;
            weight_right_11 = 4'd0;
            weight_below_11 = 4'd0;
        end
        else
        begin
            weight_left_11 = 4'd2;
            weight_above_11 = 4'd0;
            weight_right_11 = 4'd1;
            weight_below_11 = 4'd1;
        end
    end

    NetworkADPLL #(
        .BIAS(BIAS),
        .PDET_WIDTH(PDET_WIDTH),
        .DCO_CC_WIDTH(DCO_CC_WIDTH),
        .KP_WIDTH(KP_WIDTH),
        .KP_FRAC_WIDTH(KP_FRAC_WIDTH),
        .KI_WIDTH(KI_WIDTH),
        .KI_FRAC_WIDTH(KI_FRAC_WIDTH),
        .DYNAMIC_VAL(1'b1) 
    ) 
    adpll_11
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .enable_i(enable_x),
        .error_right_i(~adpll_12_error_left_x), //adpll12
        .error_bottom_i(~adpll_21_error_top_x), //adpll21
        .ref_left_i(ext_reference_r), //reference
        .ref_above_i(adpll_11_div8_x), //unused so just looping back
        .weight_left_i(weight_left_11),
        .weight_above_i(weight_above_11),
        .weight_right_i(weight_right_11),
        .weight_below_i(weight_below_11), 
        .error_left_o(adpll_11_error_left_x),
        .error_above_o(adpll_11_error_top_x),       
        .gen_clk_o(adpll_11_gen_x),
        .gen_div8_o(adpll_11_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

    /*************************************************************************/
    /* ADPLL 12                                                              */
    /*************************************************************************/

    always @ (uni_dir_x)
    begin
        if(uni_dir_x)
        begin
            weight_left_12 = 4'd4;
            weight_above_12 = 4'd0;
            weight_right_12 = 4'd0;
            weight_below_12 = 4'd0;
        end
        else
        begin
            weight_left_12 = 4'd2;
            weight_above_12 = 4'd0;
            weight_right_12 = 4'd0;
            weight_below_12 = 4'd2;
        end
    end

    NetworkADPLL #(
        .BIAS(BIAS+12'd1),
        .PDET_WIDTH(PDET_WIDTH),
        .DCO_CC_WIDTH(DCO_CC_WIDTH),
        .KP_WIDTH(KP_WIDTH),
        .KP_FRAC_WIDTH(KP_FRAC_WIDTH),
        .KI_WIDTH(KI_WIDTH),
        .KI_FRAC_WIDTH(KI_FRAC_WIDTH),
        .DYNAMIC_VAL(1'b1) 
    ) 
    adpll_12
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .enable_i(switches_i[15]),
        .error_right_i({(PDET_WIDTH){1'b0}}), //nothing
        .error_bottom_i(~adpll_22_error_top_x), //adpll21
        .ref_left_i(adpll_11_div8_x), //adpll11
        .ref_above_i(adpll_12_div8_x), //unused so just looping back
        .weight_left_i(weight_left_12),
        .weight_above_i(weight_above_12),
        .weight_right_i(weight_right_12),
        .weight_below_i(weight_below_12), 
        .error_left_o(adpll_12_error_left_x),
        .error_above_o(adpll_12_error_top_x),       
        .gen_clk_o(adpll_12_gen_x),
        .gen_div8_o(adpll_12_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

    /*************************************************************************/
    /* ADPLL 21                                                              */
    /*************************************************************************/

    always @ (uni_dir_x)
    begin
        if(uni_dir_x)
        begin
            weight_left_21 = 4'd0;
            weight_above_21 = 4'd4;
            weight_right_21 = 4'd0;
            weight_below_21 = 4'd0;
        end
        else
        begin
            weight_left_21 = 4'd0;
            weight_above_21 = 4'd2;
            weight_right_21 = 4'd2;
            weight_below_21 = 4'd0;
        end
    end

    NetworkADPLL #(
        .BIAS(BIAS-12'd3),
        .PDET_WIDTH(PDET_WIDTH),
        .DCO_CC_WIDTH(DCO_CC_WIDTH),
        .KP_WIDTH(KP_WIDTH),
        .KP_FRAC_WIDTH(KP_FRAC_WIDTH),
        .KI_WIDTH(KI_WIDTH),
        .KI_FRAC_WIDTH(KI_FRAC_WIDTH),
        .DYNAMIC_VAL(1'b1) 
    ) 
    adpll_21
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .enable_i(switches_i[15]),
        .error_right_i(~adpll_22_error_left_x), //adpll12
        .error_bottom_i({(PDET_WIDTH){1'b0}}), //nothing
        .ref_left_i(adpll_21_div8_x), //nothing
        .ref_above_i(adpll_11_div8_x),
        .weight_left_i(weight_left_21),
        .weight_above_i(weight_above_21),
        .weight_right_i(weight_right_21),
        .weight_below_i(weight_below_21), 
        .error_left_o(adpll_21_error_left_x),
        .error_above_o(adpll_21_error_top_x),       
        .gen_clk_o(adpll_21_gen_x),
        .gen_div8_o(adpll_21_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

    /*************************************************************************/
    /* ADPLL 22                                                              */
    /*************************************************************************/

    always @ (uni_dir_x)
    begin
        if(uni_dir_x)
        begin
            weight_left_22 = 4'd2;
            weight_above_22 = 4'd2;
            weight_right_22 = 4'd0;
            weight_below_22 = 4'd0;
        end
        else
        begin
            weight_left_22 = 4'd2;
            weight_above_22 = 4'd2;
            weight_right_22 = 4'd0;
            weight_below_22 = 4'd0;
        end
    end

    NetworkADPLL #(
        .BIAS(BIAS+12'd2),
        .PDET_WIDTH(PDET_WIDTH),
        .DCO_CC_WIDTH(DCO_CC_WIDTH),
        .KP_WIDTH(KP_WIDTH),
        .KP_FRAC_WIDTH(KP_FRAC_WIDTH),
        .KI_WIDTH(KI_WIDTH),
        .KI_FRAC_WIDTH(KI_FRAC_WIDTH),
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
        .ref_above_i(adpll_12_div8_x), //
        .weight_left_i(weight_left_22),
        .weight_above_i(weight_above_22),
        .weight_right_i(weight_right_22),
        .weight_below_i(weight_below_22), 
        .error_left_o(adpll_22_error_left_x),
        .error_above_o(adpll_22_error_top_x),       
        .gen_clk_o(adpll_22_gen_x),
        .gen_div8_o(adpll_22_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

    /*************************************************************************/
    /* Display modules                                                       */
    /*************************************************************************/

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