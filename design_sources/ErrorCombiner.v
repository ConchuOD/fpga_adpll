`timescale 1ns / 1ps
/*************************************************************************/
/* Author   : Conor Dooley                                               */
/* Date     : ??-Feburary-2019                                           */
/* Function : Performs a weighted average of up to 4 error signals, with */
/*            weights set dynamically                                    */
/*************************************************************************/
module ErrorCombiner #(
        parameter ERROR_WIDTH  = 8,
        parameter WEIGHT_WIDTH = 4
    )
    (
        input  wire reset_i,
        input  wire signed [WEIGHT_WIDTH-1:0] weight_0_i,
        input  wire signed [WEIGHT_WIDTH-1:0] weight_1_i,
        input  wire signed [WEIGHT_WIDTH-1:0] weight_2_i,
        input  wire signed [WEIGHT_WIDTH-1:0] weight_3_i,
        input  wire signed [ERROR_WIDTH-1:0]  error_0_i,
        input  wire signed [ERROR_WIDTH-1:0]  error_1_i,
        input  wire signed [ERROR_WIDTH-1:0]  error_2_i,
        input  wire signed [ERROR_WIDTH-1:0]  error_3_i,
        output wire signed [ERROR_WIDTH-1:0]  error_comb_o
    );
    
    /*********************************************************************/
    /* Define constants and nets                                         */
    /*********************************************************************/
    
    localparam WEIGHTED_WIDTH = ERROR_WIDTH+WEIGHT_WIDTH;
    localparam SUM_WIDTH      = WEIGHTED_WIDTH+2; //increased by two to fit x4 multiplication

    wire signed [WEIGHTED_WIDTH-1:0] weighted_0_c;
    wire signed [WEIGHTED_WIDTH-1:0] weighted_1_c;
    wire signed [WEIGHTED_WIDTH-1:0] weighted_2_c;
    wire signed [WEIGHTED_WIDTH-1:0] weighted_3_c;

    wire signed [SUM_WIDTH-1:0]   weighted_sum_c;
    wire signed [ERROR_WIDTH-1:0] result_div4_c;
    
    /*********************************************************************/
    /* Combinational logic                                               */
    /*********************************************************************/
    
    //perform multiplication by weights
    assign weighted_0_c = weight_0_i*error_0_i;
    assign weighted_1_c = weight_1_i*error_1_i;
    assign weighted_2_c = weight_2_i*error_2_i;
    assign weighted_3_c = weight_3_i*error_3_i;

    //sum the results
    assign weighted_sum_c = weighted_0_c+weighted_1_c+weighted_2_c+weighted_3_c;

    //divide by four to perform average
    assign result_div4_c = $signed({weighted_sum_c[WEIGHTED_WIDTH-1] , weighted_sum_c[((ERROR_WIDTH-1)-1)+2:0+2]});
    
    //assign result to output
    assign error_comb_o = result_div4_c;

endmodule // ErrorCombiner