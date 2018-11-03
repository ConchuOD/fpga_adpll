module JitterDetect #(parameter WIDTH = 7)(
	input clk_stable_i,    // Stable clock
	input enable_i, // Enable
	input clk_u_t_i, // Clock Under Test
	input reset_i  // Asynchronous reset active high
	);
	
	localparam increment = 1'b0;
	reg [WIDTH-1:0] cnt_r, next_cnt_r, last_reset_cnt_r;

	always @(posedge clk_stable_i)
	begin
		if (reset_i)
			cnt_val_r <= {(WIDTH){1'b0}};
		else
			cnt_r <= next_cnt_r;
	end

	always @(enable_i, cnt_r)
	begin
		if(enable_i)
			next_cnt_r = cnt_r + increment;
		else
			next_cnt_r = cnt_r;
	end

	always @(clk_u_t_i)
	begin
		last_reset_cnt_r <= cnt_r;
	end



endmodule