`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-November-2018                                               */
/* Function : Fallling edge detection circuit                                */
/*****************************************************************************/
module SaveCounter #(parameter WIDTH = 20) (
		input wire reset_i, //active high
		input wire fpga_clk_i,
		input wire trigger_i,		
		input wire signed [WIDTH-1:0] counter_val_i,
		output reg signed [WIDTH-1:0] counter_val_saved_o,
		output reg counter_cleared_o
	);
    
    /*************************************************************************/
    /* Define nets                                                           */
    /*************************************************************************/

	wire trigger_x;

	 //detect positive edge on trigger signal
	PulseOnPosEdge triggerIPosEdge(
		.fpga_clk_i(fpga_clk_i),
		.trigger_i(trigger_i),
		.pulse_o(trigger_x)
	);
    
    /*************************************************************************/
    /* Assign to registers                                                   */
    /*************************************************************************/
	
	//update the saved value when trigger is high
	always @ (posedge fpga_clk_i or posedge reset_i)
	begin
		if (reset_i) counter_val_saved_o <= {(WIDTH){1'b0}};
		else if (trigger_x) counter_val_saved_o <= counter_val_i;
		else counter_val_saved_o <= counter_val_saved_o;
	end

	//set counter cleared flag if the counter is at zero & causes state transition
	always @ (counter_val_i)
	begin
		if (counter_val_i == {(WIDTH){1'b0}}) counter_cleared_o = 1'b1;
		else counter_cleared_o = 1'b0;
	end

endmodule