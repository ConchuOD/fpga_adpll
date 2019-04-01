`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-November-2019                                               */
/* Function : Synchronises a signal to the FPGA clock, through sampling      */
/*****************************************************************************/
module Synchroniser (
		input wire reset_i, //active high
		input wire clk_i,
		input wire async_i,
		output wire sync_o
	);
	
	//2 bit wise for 2 stage process
	reg [1:0] delayed;

	//two chained flip flops, output of the 1st may be metastable, 2nd is stable
	always @ (posedge clk_i or posedge reset_i)
	begin
		if(reset_i) delayed <= 2'b00;
		else        delayed <= { delayed[0],async_i };
	end

	//assign stable value to output
	assign sync_o = delayed[1];

endmodule