`timescale 1ns / 1ps

module ADPLL #(parameter ACCUM_WIDTH = 12,PDET_WITH = 8) (
        input wire reset_i,
        input wire fpga_clk_i,
        input wire temp,
        input wire ref_clk_i,
        input wire enable_i,
        output wire gen_clk_o,
        output wire gen_div8_o,
        output wire signed [PDET_WITH-1:0] error_o,
        output wire signed [DCO_CC_WIDTH-1:0] dco_cc_o
    );
    localparam DCO_CC_WIDTH = 9;
    localparam PADDING_WIDTH = ACCUM_WIDTH-DCO_CC_WIDTH;
    localparam BIAS = 12'd76;

    wire [ACCUM_WIDTH-1:0] f_sel_sw_pa_x; //TODO
    wire gen_clk_x;
    wire gen_div8_x;
    wire signed [PDET_WITH-1:0] error_x;

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
		.fpga_clk_i(temp),
		.reference_i(ref_clk_i),
		.generated_i(gen_div8_x),
		.pd_clock_cycles_o(error_x)
	);
    LoopFilter loopFilter (
        .gen_clk_i(gen_clk_x),
        .reset_i(reset_i),
        .error_i(error_x),
        .dco_cc_o(dco_cc_o) 
    );

    //assign f_sel_sw_pa_x = BIAS;
    assign f_sel_sw_pa_x = BIAS + $signed({ {(PADDING_WIDTH){dco_cc_o[DCO_CC_WIDTH-1]}} ,dco_cc_o});

 endmodule // PhDetTopLevel