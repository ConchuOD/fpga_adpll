`timescale 1ns / 1ps

module UpDownCounter #(parameter WIDTH = 20)(
		input wire reset_i,
		input wire clear_i,
		input wire fpga_clk_i,
		input wire [1:0] count_instr_i,
		output wire [WIDTH-1:0] counter_val_o
	);

	localparam [1:0] DISABLE = 2'b00, COUNT_UP = 2'b01, COUNT_DOWN = 2'b10;
	localparam [WIDTH-1:0] MAXVAL = {1'b0, {(WIDTH-1){1'b1}}};
	localparam [WIDTH-1:0] MINVAL = {1'b1, {(WIDTH-2){1'b0}}, 1'b1};
	reg [WIDTH-1:0] count_r, next_count_r, count_inc_r;

	assign counter_val_o = count_r;

	always @ (posedge fpga_clk_i)
	begin
		if (reset_i == 1'b1 || clear_i == 1'b1) count_r <= {(WIDTH){1'b0}};
		else count_r <= next_count_r;
	end

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

	always @(count_inc_r, count_r)
	begin
		if (count_r == MAXVAL)
			 next_count_r = count_r; //at maxval
		else if (count_r == MINVAL)
			 next_count_r = count_r; //at symmmetrical minval
		else 
			next_count_r = count_r + count_inc_r; //otherwise count
	end


endmodule // UpDownCounter
