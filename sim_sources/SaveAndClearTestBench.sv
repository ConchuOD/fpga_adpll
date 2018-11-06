`timescale 1ns / 1ps
module SaveAndClearTestBench ();

	localparam WIDTH = 20;
	reg fpga_clk;
	reg reset;
	reg trigger;
	reg signed [WIDTH-1:0] counter_val;
	reg signed [WIDTH-1:0] saved_val;
	reg cleared;

	SaveCounter #(.WIDTH(WIDTH)) saveCounter (
		.fpga_clk_i(fpga_clk),
		.reset_i(reset),
		.trigger_i(trigger),
		.counter_val_i(counter_val),
		.counter_val_saved_o(saved_val),
		.counter_cleared_o(cleared)
	);

	//setup clocks

	initial
	begin
		fpga_clk  = 1'b0;
		forever
		begin
			#1.25 fpga_clk = ~fpga_clk;
		end
	end

	initial
	begin
		reset = 1'b1;
		trigger = 1'b0;
		counter_val = 20'h0000a;
		#10
		reset = 1'b0;
		#10
		trigger = 1'b1;
		#2.5
		trigger = 1'b0;
		#2.5
		$stop;
	end
endmodule // SaveAndClearTestBench