`timescale 1ns / 1ps

module SaveCounter #(parameter WIDTH = 20) (
		input wire fpga_clk_i,
		input wire reset_i,
		input wire trigger_i,		
		input wire signed [WIDTH-1:0] counter_val_i,
		output reg signed [WIDTH-1:0] counter_val_saved_o,
		output reg counter_cleared_o
	);
	
	always @ (posedge trigger_i or posedge reset_i)
	begin
		if (reset_i) counter_val_saved_o <= {(WIDTH){1'b0}};
		else counter_val_saved_o <= counter_val_i;
	end

	always @ (counter_val_i)
	begin
		if (counter_val_i == {(WIDTH){1'b0}}) counter_cleared_o = 1'b1;
		else counter_cleared_o = 1'b0;
	end

endmodule