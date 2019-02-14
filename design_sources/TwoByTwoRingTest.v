`timescale 1ns / 1ps

module TwoByTwoRingTest (
        input clk100_i,        // 100 MHz clock from oscillator on board
        input rst_pbn_i,        // reset signal, active low, from CPU RESET pushbutton //
        input [15:0] switches_i,
        output [2:0] led_o,
        output [6:0] ra_o,
		input ra_i, // external reference
        output [7:0] JB,
        output [7:0] segment_o,
        output [7:0] digit_o/*,  
        input temp,
        input temp_rst*/
    );

    localparam BIAS = 5'd15; //154 = 10 MHz
    localparam PDET_WIDTH = 5;
    localparam RINGSIZE = 383;
    localparam ACCUM_WIDTH = 12;
    //optimal gains w/ 5.25 M, ref : 11,12 -> 0001 0010
    
    wire reset_x;
 
    reg ext_reference_r;
    wire other_ref_div4_x;
    
    wire adpll_11_gen_x;
    wire adpll_11_div8_x;
    wire [PDET_WIDTH-1:0] adpll_11_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_11_error_left_x;
    reg [3:0] weight_left_11;
    reg [3:0] weight_above_11;
    reg [3:0] weight_right_11;
    reg [3:0] weight_below_11;

    wire adpll_12_gen_x;
    wire adpll_12_div8_x;
    wire [PDET_WIDTH-1:0] adpll_12_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_12_error_left_x;
    reg [3:0] weight_left_12;
    reg [3:0] weight_above_12;
    reg [3:0] weight_right_12;
    reg [3:0] weight_below_12;

    wire adpll_21_gen_x;
    wire adpll_21_div8_x;
    wire [PDET_WIDTH-1:0] adpll_21_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_21_error_left_x;
    reg [3:0] weight_left_21;
    reg [3:0] weight_above_21;
    reg [3:0] weight_right_21;
    reg [3:0] weight_below_21;

    wire adpll_22_gen_x;
    wire adpll_22_div8_x;
    wire [PDET_WIDTH-1:0] adpll_22_error_top_x;
    wire [PDET_WIDTH-1:0] adpll_22_error_left_x;
    reg [3:0] weight_left_22;
    reg [3:0] weight_above_22;
    reg [3:0] weight_right_22;
    reg [3:0] weight_below_22;

    wire clk5_x;
    wire clk5_0_x;
    wire clk5_45_x;
    wire clk5_90_x;
    wire clk5_135_x;

    wire clk258_x;

    reg [3:0] kp_sel_r;
    reg [3:0] ki_sel_r;
    wire [7:0] kp_ki_c;

    wire [7:0] half_7seg_x;

    wire enable_x = switches_i[15];
    wire uni_dir_x = switches_i[14];
    reg [ACCUM_WIDTH-1:0] ref_sel_r;
    
    assign kp_ki_c = {kp_sel_r,ki_sel_r};

    localparam KP_WIDTH = 5;
    localparam KP_FRAC_WIDTH = 3;
    localparam KI_WIDTH = 7;
    localparam KI_FRAC_WIDTH = 6;
    wire [KP_WIDTH-1:0] padded_kp_c;
    wire [KI_WIDTH-1:0] padded_ki_c;
    assign padded_kp_c = {{(KP_WIDTH-4){1'b0}},kp_sel_r}; 
    assign padded_ki_c = {{(KI_WIDTH-4){1'b0}},ki_sel_r}; 

    always @ (posedge clk258_x)
    begin
        ext_reference_r <= ra_i;
    end

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

    //assign clk258_x = temp;
    //assign reset_x = temp_rst;

    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) referenceOsc (
        .enable_i(1'b1),
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .clk_o(gen_reference_x),
        .k_val_i(ref_sel_r)
    ); 

    always @ (posedge clk258_x)
    begin 
        if (switches_i[12] == 1'b1)
        begin
            ref_sel_r <= switches_i[11:0];
            kp_sel_r <= kp_sel_r;
            ki_sel_r <= ki_sel_r;
        end
        else
        begin
            ref_sel_r <= ref_sel_r;
            kp_sel_r <= switches_i[11:8];
            ki_sel_r <= switches_i[3:0];
        end
    end

    assign JB[5-1:0] = adpll_11_error_left_x[5-1:0]; 
    assign clk5_x = clk5_0_x;
    assign ra_o[0] = adpll_11_gen_x;
    assign ra_o[1] = gen_reference_x;
    assign ra_o[2] = ext_reference_r;
    assign ra_o[3] = adpll_11_div8_x;
    assign ra_o[4] = adpll_12_gen_x;
    assign ra_o[5] = adpll_21_gen_x;
    assign ra_o[6] = adpll_22_gen_x;

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

    NetworkRing #(
        .BIAS(BIAS),
        .RO_WIDTH(PDET_WIDTH),
        .RINGSIZE(RINGSIZE),
        .PDET_WIDTH(PDET_WIDTH),
        //.KP(5'b00001),
        .KP_WIDTH(KP_WIDTH),
        .KP_FRAC_WIDTH(KP_FRAC_WIDTH),
        .KI_WIDTH(KI_WIDTH),
        .KI_FRAC_WIDTH(KI_FRAC_WIDTH),
        //.KI(7'b0000001)
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

    NetworkRing #(
        .BIAS(BIAS+10),
        .RO_WIDTH(PDET_WIDTH),
        .RINGSIZE(RINGSIZE),
        .PDET_WIDTH(PDET_WIDTH),
        //.KP(5'b00001),
        .KP_WIDTH(KP_WIDTH),
        .KP_FRAC_WIDTH(KP_FRAC_WIDTH),
        .KI_WIDTH(KI_WIDTH),
        .KI_FRAC_WIDTH(KI_FRAC_WIDTH),
        //.KI(7'b0000001)
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

    NetworkRing #(
        .BIAS(BIAS),
        .RO_WIDTH(PDET_WIDTH),
        .RINGSIZE(RINGSIZE),
        .PDET_WIDTH(PDET_WIDTH),
        //.KP(5'b00001),
        .KP_WIDTH(KP_WIDTH),
        .KP_FRAC_WIDTH(KP_FRAC_WIDTH),
        .KI_WIDTH(KI_WIDTH),
        .KI_FRAC_WIDTH(KI_FRAC_WIDTH),
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

    NetworkRing #(
        .BIAS(BIAS),
        .RO_WIDTH(PDET_WIDTH),
        .RINGSIZE(RINGSIZE),
        .PDET_WIDTH(PDET_WIDTH),
        //.KP(5'b00001),
        .KP_WIDTH(KP_WIDTH),
        .KP_FRAC_WIDTH(KP_FRAC_WIDTH),
        .KI_WIDTH(KI_WIDTH),
        .KI_FRAC_WIDTH(KI_FRAC_WIDTH),
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

 endmodule // end of module TwoByTwoRingTest