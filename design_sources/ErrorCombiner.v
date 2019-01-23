`timescale 1ns / 1ps

module ErrorCombiner #(
		parameter ERROR_WIDTH = 8,
		parameter WEIGHT_WIDTH = 3
	)
	(
        input wire reset_i,
        input wire [WEIGHT_WIDTH-1:0] weight_0_i,
        input wire [WEIGHT_WIDTH-1:0] weight_1_i,
        input wire [WEIGHT_WIDTH-1:0] weight_2_i,
        input wire [WEIGHT_WIDTH-1:0] weight_3_i,
        input wire signed [ERROR_WIDTH-1:0] error_0_i,
        input wire signed [ERROR_WIDTH-1:0] error_1_i,        
        input wire signed [ERROR_WIDTH-1:0] error_2_i,
        input wire signed [ERROR_WIDTH-1:0] error_3_i,
        output wire signed [ERROR_WIDTH-1:0] error_comb_o
    );

	localparam WEIGHTED_WIDTH = ERROR_WIDTH+WEIGHT_WIDTH;
	localparam SUM_WIDTH = WEIGHTED_WIDTH+2; //+2 to fit times 4

	wire [WEIGHTED_WIDTH-1:0] weighted_0_c;
	wire [WEIGHTED_WIDTH-1:0] weighted_1_c;
	wire [WEIGHTED_WIDTH-1:0] weighted_2_c;
	wire [WEIGHTED_WIDTH-1:0] weighted_3_c;

	wire [SUM_WIDTH-1:0] weighted_sum_c;
	wire [ERROR_WIDTH-1:0] result_div4_c;

	assign weighted_0_c = weight_0_i*error_0_i;
	assign weighted_1_c = weight_1_i*error_1_i;
	assign weighted_2_c = weight_2_i*error_2_i;
	assign weighted_3_c = weight_3_i*error_3_i;

	assign weighted_sum_c = weighted_0_c+weighted_1_c+weighted_2_c+weighted_3_c;

	assign result_div4_c = weighted_sum_c[WEIGHTED_WIDTH-1:WEIGHTED_WIDTH-1-ERROR_WIDTH];
	assign error_comb_o = result_div4_c;

endmodule // ErrorCombiner