`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-November-2019                                               */
/* Function : Bidirectional counter of a width set at compile time. Output   */
/*			  is a 2s complement signed integer                              */
/*****************************************************************************/
module UpDownCounter #(parameter WIDTH = 20)(
		input wire reset_i, reset high
		input wire clear_i,
		input wire fpga_clk_i,
		input wire [1:0] count_instr_i,
		output wire signed [WIDTH-1:0] counter_val_o
	);
    
    /*************************************************************************/
    /* Define constants and nets                                             */
    /*************************************************************************/

    //count instructions from state machine
	localparam [1:0] DISABLE = 2'b00, COUNT_UP = 2'b01, COUNT_DOWN = 2'b10;

	//constants for overflow prevention in accumulator
	localparam [WIDTH-1:0] MAXVAL = {1'b0, {(WIDTH-1){1'b1}}};
	localparam [WIDTH-1:0] MINVAL = {1'b1, {(WIDTH-2){1'b0}}, 1'b1};

	reg [WIDTH-1:0] count_r, next_count_r, count_inc_r;

    /*************************************************************************/
    /* Logic                                                                 */
    /*************************************************************************/

    //register to form counter
	always @ (posedge fpga_clk_i)
	begin
		if (reset_i == 1'b1)     count_r <= {(WIDTH){1'b0}};
		else if(clear_i == 1'b1) count_r <= {(WIDTH){1'b0}};
		else count_r <=          next_count_r;
	end

	//switch statement decides counter increment based on direction command from FSM
	always @ (count_instr_i)
	begin
		case (count_instr_i)
			DISABLE: 
				count_inc_r = {(WIDTH){1'b0}};
			COUNT_UP:
				count_inc_r = {{(WIDTH-1){1'b0}}, 1'b1};
			COUNT_DOWN: 
				count_inc_r = {(WIDTH){1'b1}};
			default : count_inc_r = {(WIDTH){1'b0}};
		endcase
	end

	//determine next count value based on direction and possibilty of overflow
	always @(count_inc_r, count_r)
	begin
		if (count_r == MAXVAL)
			 next_count_r = count_r; //at maxval
		else if (count_r == MINVAL)
			 next_count_r = count_r; //at symmmetrical minval
		else 
			next_count_r = count_r + count_inc_r; //otherwise count
	end

	//assign count value as output
	assign counter_val_o = count_r;

endmodule // UpDownCounter
