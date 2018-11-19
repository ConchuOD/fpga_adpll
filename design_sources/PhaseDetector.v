`timescale 1ns / 1ps

module PhaseDetector #(parameter WIDTH = 20) (
		input wire reset_i, 
		input wire fpga_clk_i,
		input wire reference_i,
		input wire generated_i,
		output wire signed [WIDTH-1:0] pd_clock_cycles_o
	);

	wire signed [WIDTH-1:0] counter_val_x;
	wire [1:0] count_instr_x;
	wire save_and_clear_x;
	wire counter_cleared_x;

	wire ref_edge_x;
	wire gen_edge_x;

	wire generated_synced_i;
	wire reference_synced_i;

	Synchroniser genSync (
		.clk_i(fpga_clk_i),
		.async_i(generated_i),
		.sync_o(generated_synced_i)
	);

	Synchroniser refSync (
		.clk_i(fpga_clk_i),
		.async_i(reference_i),
		.sync_o(reference_synced_i)
	);

	UpDownCounter #(.WIDTH(WIDTH)) upDownCounter (
		.reset_i(reset_i),
		.clear_i(save_and_clear_x),
		.fpga_clk_i(fpga_clk_i),
		.count_instr_i(count_instr_x),
		.counter_val_o(counter_val_x)
	);

	SaveCounter #(.WIDTH(WIDTH)) saveCounter (
		.fpga_clk_i(fpga_clk_i),
		.reset_i(reset_i),
		.trigger_i(save_and_clear_x),
		.counter_val_i(counter_val_x),
		.counter_val_saved_o(pd_clock_cycles_o),
		.counter_cleared_o(counter_cleared_x)
	);

	StateMachine stateMachine(
		.reset_i(reset_i),
		.fpga_clk_i(fpga_clk_i),
		.reference_synced_i(reference_synced_i),
		.generated_synced_i(generated_synced_i),
		.counter_cleared_i(counter_cleared_x),
		.save_and_clear_o(save_and_clear_x),
		.count_instr_o(count_instr_x)
	);
							

endmodule // PhaseDetector