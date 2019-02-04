`timescale 1ns / 1ps

module ADPLLw2Inputs #(
		parameter ACCUM_WIDTH = 12,
		parameter PDET_WITH = 8,
		parameter BIAS = 12'd76, //5 MHZ @ 258 MHZ CLOCK
		parameter DCO_CC_WIDTH = 9,
		//LoopFilter
		parameter DYNAMIC_VAL = 0,
		parameter ERROR_WIDTH = 8,
		parameter KP_WIDTH = 3,
		parameter KP_FRAC_WIDTH = 1,
		parameter KP = 3'b010,
		parameter KI_WIDTH = 4,
		parameter KI_FRAC_WIDTH = 3,
		parameter KI = 4'b0001
	)
	(
        input wire reset_i,
        input wire fpga_clk_i,
        input wire ref_clk_i,
        input wire other_clk_i,
        input wire enable_i,
		input wire [KP_WIDTH-1:0] kp_i,
		input wire [KI_WIDTH-1:0] ki_i,
        output wire gen_clk_o,
        output wire gen_div8_o,
        output wire signed [PDET_WITH-1:0] error_o,
        output wire signed [DCO_CC_WIDTH-1:0] dco_cc_o
    );
	
    localparam PADDING_WIDTH = ACCUM_WIDTH-DCO_CC_WIDTH;

    wire [ACCUM_WIDTH-1:0] f_sel_sw_pa_x; //TODO
    wire gen_clk_x;
    wire gen_div8_x;
    wire signed [PDET_WITH-1:0] error_x;
    wire signed [PDET_WITH-1:0] other_error_x;
    wire signed [PDET_WITH-1:0] summed_error_x;

    assign gen_clk_o = gen_clk_x;
    assign gen_div8_o = gen_div8_x;
    assign error_o = error_x;

    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) testOsc (
        .enable_i(enable_i),
        .reset_i(reset_i),
        .fpga_clk_i(fpga_clk_i),
        .clk_o(gen_clk_x),
        .k_val_i(f_sel_sw_pa_x)
	); 
	Div8 div8 ( 
		.reset_i(reset_i),
    	.signal_i(gen_clk_x),
    	.div8_o(gen_div8_x)
   	);
	PhaseDetector #(.WIDTH(PDET_WITH)) testPDet (
		.reset_i(reset_i), 
		.fpga_clk_i(fpga_clk_i),
		.reference_i(ref_clk_i),
		.generated_i(gen_div8_x),
		.pd_clock_cycles_o(error_x)
	);
	PhaseDetector #(.WIDTH(PDET_WITH)) otherPDet (
		.reset_i(reset_i), 
		.fpga_clk_i(fpga_clk_i),
		.reference_i(other_clk_i),
		.generated_i(gen_div8_x),
		.pd_clock_cycles_o(other_error_x)
	);
	ErrorCombiner errorCombiner ( //zero out unconnected, 2 weight on others
		.reset_i(reset_i),
        .weight_0_i(3'b010),
        .weight_1_i(3'b010),
        .weight_2_i(3'd0),
        .weight_3_i(3'd0),
        .error_0_i(error_x),
        .error_1_i(other_error_x),        
        .error_2_i(8'd0),
        .error_3_i(8'd0),
        .error_comb_o(summed_error_x)
	);
    LoopFilter #(
		.ERROR_WIDTH(ERROR_WIDTH),
		.DCO_CC_WIDTH(DCO_CC_WIDTH),
		.KP_WIDTH(KP_WIDTH),
		.KP_FRAC_WIDTH(),
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
        .error_i(summed_error_x),
        .kp_i(kp_i),
        .ki_i(ki_i),
        .dco_cc_o(dco_cc_o) 
    );

    //assign f_sel_sw_pa_x = BIAS;
    assign f_sel_sw_pa_x = BIAS + $signed({ {(PADDING_WIDTH){dco_cc_o[DCO_CC_WIDTH-1]}} ,dco_cc_o});

 endmodule // ADPLLw2Inputs