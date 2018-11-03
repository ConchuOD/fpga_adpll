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