`timescale 1ns / 1ps

module RingADPLL #(
		parameter RO_WIDTH = 5,
		parameter PDET_WITH = 8,
		parameter RINGSIZE = 551, //~5 MHZ @ 258 MHZ CLOCK
		parameter BIAS = 5'd16, 
		//LoopFilter
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
        input wire enable_i,
        output wire gen_clk_o,
        output wire gen_div8_o,
        output wire signed [PDET_WITH-1:0] error_o,
        output wire signed [DCO_CC_WIDTH-1:0] dco_cc_o
    );
    localparam DCO_CC_WIDTH = RO_WIDTH;
    localparam PADDING_WIDTH = RO_WIDTH-DCO_CC_WIDTH;

    wire [RO_WIDTH-1:0] f_sel_sw_pa_x; //TODO
    wire gen_clk_x;
    wire signed [PDET_WITH-1:0] error_x;

    assign gen_clk_o = gen_clk_x;
    assign gen_div8_o = gen_div8_x;
    assign error_o = error_x;

    RingOsc #(.RINGSIZE(RINGSIZE), .CTRL_WIDTH(RO_WIDTH)) testRing( 
        .enable_i (~reset_i),
        .freq_sel_i (f_sel_sw_pa_x),
        .clk_o (gen_clk_x)
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
    LoopFilter #(
		.ERROR_WIDTH(ERROR_WIDTH),
		.DCO_CC_WIDTH(DCO_CC_WIDTH),
		.KP_WIDTH(KP_WIDTH),
		.KP_FRAC_WIDTH(),
		.KP(KP),
		.KI_WIDTH(KI_WIDTH),
		.KI_FRAC_WIDTH(KI_FRAC_WIDTH),
		.KI(KI)		
	)
	loopFilter 
	(
        .gen_clk_i(gen_clk_x),
        .reset_i(reset_i),
        .error_i(error_x),
        .dco_cc_o(dco_cc_o) 
    );

    //assign f_sel_sw_pa_x = BIAS;
    assign f_sel_sw_pa_x = BIAS - $signed({ {(PADDING_WIDTH){dco_cc_o[DCO_CC_WIDTH-1]}} ,dco_cc_o});

 endmodule // PhDetTopLevel