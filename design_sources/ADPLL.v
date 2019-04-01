`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-November-2018                                               */
/* Function : FPGA clock driven ADPLL                                        */
/*****************************************************************************/
module ADPLL #(
		parameter ACCUM_WIDTH = 12,
		parameter PDET_WITH = 8,
		parameter BIAS = 12'd76,    //biased to 5 MHZ @ 258 MHZ CLOCK
		parameter DCO_CC_WIDTH = 9,
		//LoopFilter Settings
		parameter DYNAMIC_VAL = 0,  //set to allow variable control of the filter gains with ki/p_i
		parameter ERROR_WIDTH = 8,
		parameter KP_WIDTH = 3,
		parameter KP_FRAC_WIDTH = 1,
		parameter KP = 3'b010,
		parameter KI_WIDTH = 4,
		parameter KI_FRAC_WIDTH = 3,
		parameter KI = 4'b0001
	)
	(
        input  wire reset_i, //reset high
        input  wire fpga_clk_i,
        input  wire ref_clk_i,
        input  wire enable_i,
		input  wire [KP_WIDTH-1:0] kp_i,
		input  wire [KI_WIDTH-1:0] ki_i,
        output wire gen_clk_o,
        output wire gen_div8_o,
        output wire signed [PDET_WITH-1:0] error_o,
        output wire signed [DCO_CC_WIDTH-1:0] dco_cc_o
    );
    
    /*************************************************************************/
    /* Define constants and nets                                             */
    /*************************************************************************/
    
    localparam PADDING_WIDTH = ACCUM_WIDTH-DCO_CC_WIDTH;

    wire [ACCUM_WIDTH-1:0] f_sel_sw_pa_x; //TODO
    wire gen_clk_x;
    wire gen_div8_x;
    wire signed [PDET_WITH-1:0] error_x;

    assign gen_clk_o = gen_clk_x;
    assign gen_div8_o = gen_div8_x;
    assign error_o = error_x;

    /*************************************************************************/
    /* Module instantiation                                             */
    /*************************************************************************/
    
    //oscillator
    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) testOsc (
        .enable_i(enable_i),
        .reset_i(reset_i),
        .fpga_clk_i(fpga_clk_i),
        .clk_o(gen_clk_x),
        .k_val_i(f_sel_sw_pa_x)
	); 
    
    //feedback divider
	Div8 div8 ( 
		.reset_i(reset_i),
    	.signal_i(gen_clk_x),
    	.div8_o(gen_div8_x)
   	);
    
    //phase detector
	PhaseDetector #(.WIDTH(PDET_WITH)) testPDet (
		.reset_i(reset_i), 
		.fpga_clk_i(fpga_clk_i),
		.reference_i(ref_clk_i),
		.generated_i(gen_div8_x),
		.pd_clock_cycles_o(error_x)
	);
    
    //loop filter
    LoopFilter #(
		.ERROR_WIDTH(ERROR_WIDTH),
		.DCO_CC_WIDTH(DCO_CC_WIDTH),
		.KP_WIDTH(KP_WIDTH),
		.KP_FRAC_WIDTH(KP_FRAC_WIDTH),
		.KP(KP),
		.KI_WIDTH(KI_WIDTH),
		.KI_FRAC_WIDTH(KI_FRAC_WIDTH),
		.KI(KI),
		.DYNAMIC_VAL(DYNAMIC_VAL)	
	)
	loopFilter 
	(
        .gen_clk_i(gen_clk_x),
        .reset_i(reset_i),
        .error_i(error_x),
        .kp_i(kp_i),
        .ki_i(ki_i),
        .dco_cc_o(dco_cc_o) 
    );

    //add control code to the bias
    assign f_sel_sw_pa_x = BIAS + $signed({ {(PADDING_WIDTH){dco_cc_o[DCO_CC_WIDTH-1]}} ,dco_cc_o});

 endmodule // ADPLL