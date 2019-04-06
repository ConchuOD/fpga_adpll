`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : 29-March-2019                                                  */
/* Function : Variable gain PI controller for use in ADPLLs                  */
/*****************************************************************************/
module LoopFilterFrac #(
		parameter DYNAMIC_VAL = 0,      //whether or not to set gains at runtime
		parameter ERROR_WIDTH = 8,      //width of the error signal
		parameter DCO_CC_WIDTH = 9,     //width of the filter output
		parameter KP_WIDTH = 3,         
		parameter KP_FRAC_WIDTH = 1,    
		parameter KP = 3'b001,          //compile time default kp
		parameter KI_WIDTH = 4,         
		parameter KI_FRAC_WIDTH = 3,
		parameter KI = 4'b0001          //compile time default ki
	)
	(
		input wire gen_clk_i,
		input wire reset_i, //reset high
		input wire [KP_WIDTH-1:0] kp_i,
		input wire [KI_WIDTH-1:0] ki_i,
		input wire signed [ERROR_WIDTH-1:0] error_i,
		output wire signed [DCO_CC_WIDTH-1:0] dco_cc_o
	);
    
    /*************************************************************************/
    /* Define constants and nets                                             */
    /*************************************************************************/
	
	localparam KP_INT_WIDTH = KP_WIDTH-KP_FRAC_WIDTH;
	localparam KI_INT_WIDTH = KI_WIDTH-KI_FRAC_WIDTH;

	localparam KP_MULT_RES_INT_WIDTH = ERROR_WIDTH;
	localparam KI_MULT_RES_INT_WIDTH = ERROR_WIDTH;

	localparam SUM_INT_WIDTH = KP_MULT_RES_INT_WIDTH;//kp always bigger
	localparam SUM_FRAC_WIDTH = KI_FRAC_WIDTH; //ki always more bits

    //gains
	reg signed [KP_INT_WIDTH-1:-KP_FRAC_WIDTH] kp_x;
	reg signed [KI_INT_WIDTH-1:-KI_FRAC_WIDTH] ki_x;
	
    //input delay register
	wire signed [ERROR_WIDTH-1:0] error_delay_r;

    //kp path nets	
	wire signed [KP_MULT_RES_INT_WIDTH-1:-KP_FRAC_WIDTH] kp_error_c;
	wire signed [ERROR_WIDTH-1:0] kp_error_trun_c;

    //ki path net
	wire signed [KI_MULT_RES_INT_WIDTH-1:-KI_FRAC_WIDTH] ki_error_c;
	wire signed [KI_MULT_RES_INT_WIDTH-1:-KI_FRAC_WIDTH] ki_error_inte_c;
	reg  signed [KI_MULT_RES_INT_WIDTH-1:-KI_FRAC_WIDTH] ki_error_inte_delay_r;
	wire signed [ERROR_WIDTH-1:0] ki_error_trun_c;
	
    //path combining nets	
	wire signed [SUM_INT_WIDTH-1:-SUM_FRAC_WIDTH] error_sum_c;
	wire signed [DCO_CC_WIDTH-1:0] error_sum_trun_c;
	reg signed [DCO_CC_WIDTH-1:0] error_sum_trun_delay_r;

    /*************************************************************************/
    /* Select from dynamic or compile time set gains                         */
    /*************************************************************************/
	
	always @(DYNAMIC_VAL or reset_i or kp_i or ki_i)
	begin
		if (DYNAMIC_VAL)
		begin
			kp_x = kp_i;
			ki_x = ki_i;
		end
		else
		begin
			kp_x = KP;
			ki_x = KI;
		end
	end
    
    /*************************************************************************/
    /* Input & output delays                                                 */
    /*************************************************************************/

	assign error_delay_r = error_i;

	always @ (posedge gen_clk_i or posedge reset_i)
	begin
		if(reset_i) error_sum_trun_delay_r <= {(DCO_CC_WIDTH){1'b0}};
		else error_sum_trun_delay_r <= error_sum_trun_c;
	end

	/*************************************************************************/
    /* Kp path                                                               */
    /*************************************************************************/
    
	//multiply by kp
	assign kp_error_c = error_delay_r*kp_x;

	/*************************************************************************/
    /* Ki path                                                               */
    /*************************************************************************/
    
	//multiply by ki
	assign ki_error_c = error_delay_r*ki_x;
    
	//add to value in accumulator to perform integration
	assign ki_error_inte_c = ki_error_inte_delay_r+ki_error_c;
    
    //accumulator register
	always @ (posedge gen_clk_i or posedge reset_i)
	begin
		if(reset_i) ki_error_inte_delay_r <= {(KI_MULT_RES_INT_WIDTH-1){1'b0}};
		else ki_error_inte_delay_r <= ki_error_inte_c;
	end

    /*************************************************************************/
    /* Combine paths                                                         */
    /*************************************************************************/
    
    //pad kp to match ki width then add
	assign error_sum_c = $signed({kp_error_c, {(KI_FRAC_WIDTH-KP_FRAC_WIDTH){1'b0}} }) + ki_error_inte_c;

    //divide combination result to fit in output value then assign

	assign error_sum_trun_c = error_sum_c[SUM_INT_WIDTH-1:SUM_INT_WIDTH-1-DCO_CC_WIDTH];
	assign dco_cc_o = error_sum_trun_delay_r; //

endmodule