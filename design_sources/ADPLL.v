`timescale 1ns / 1ps

module ADPLL #(parameter ACCUM_WIDTH = 12,PDET_WITH = 8) (
        input wire reset_i,
        input wire fpga_clk_i,
        input wire ref_clk_i,
        input wire enable_i,
        output wire gen_clk_o,
        output wire signed [PDET_WITH-1:0] error_o  
    );

    wire [ACCUM_WIDTH-1:0] f_sel_sw_pa_x = 12'd82; //TODO
    wire gen_clk_x;

    assign gen_clk_o = gen_clk_x;

    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) testOsc (
        .enable_i(enable_i),
        .reset_i(reset_i),
        .fpga_clk_i(fpga_clk_i),
        .clk_o(gen_clk_x),
        .k_val_i(f_sel_sw_pa_x)
	); 
	PhaseDetector #(.WIDTH(PDET_WITH)) testPDet (
		.reset_i(reset_i), 
		.fpga_clk_i(fpga_clk_i),
		.reference_i(ref_clk_i),
		.generated_i(gen_clk_x),
		.pd_clock_cycles_o(error_o)
	);

 endmodule // PhDetTopLevel