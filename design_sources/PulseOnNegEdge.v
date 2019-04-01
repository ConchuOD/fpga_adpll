`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-November-2018                                               */
/* Function : Fallling edge detection circuit                                */
/*****************************************************************************/
module PulseOnNegEdge (
	input fpga_clk_i,
	input trigger_i,
	output pulse_o
	);

	reg trigger_delayed_r;

	always @ (posedge fpga_clk_i)
	begin
		trigger_delayed_r <= trigger_i;
	end 

	assign pulse_o = trigger_delayed_r & ~trigger_i;

endmodule