module LoopFilter #(
		parameter ERROR_WIDTH = 8,
		parameter DCO_CC_WIDTH = 9,
		parameter KP_WIDTH = 2,
		parameter KP = 2'b01,
		parameter KI_WIDTH = 4,
		parameter KI = -4'b0001
	)
	(
		input wire gen_clk_i,
		input wire reset_i,
		input wire signed [ERROR_WIDTH-1:0] error_i,
		output wire signed [DCO_CC_WIDTH-1:0] dco_cc_o
	);

	reg signed [ERROR_WIDTH-1:0] error_delay_r;
	wire signed [ERROR_WIDTH:0] kp_error_c;
	wire signed [ERROR_WIDTH-1:0] kp_error_trun_c;
	wire signed [1:0] kp_x = KP;

	wire signed [ERROR_WIDTH-1:-3] ki_error_c;
	wire signed [ERROR_WIDTH-1:-3] ki_error_inte_c;
	reg signed [ERROR_WIDTH-1:-3] ki_error_inte_delay_r;
	wire signed [ERROR_WIDTH-1:0] ki_error_trun_c;
	wire signed [0:-3] ki_x = 4'b0001;

	always @ (posedge gen_clk_i or posedge reset_i)
	//always @ (posedge gen_clk_i)
	begin
		if(reset_i) error_delay_r <= {(ERROR_WIDTH){1'b0}};
		else error_delay_r <= error_i;
	end

	/*
		kp route
	*/
	//multiply by kp
	assign kp_error_c = error_delay_r*kp_x;
	//divide down by 2^n to get
	assign kp_error_trun_c = kp_error_c >>> 1;

	/*
		ki route
	*/
	//multiply by ki
	assign ki_error_c = error_delay_r*ki_x;
	//accumulator
	assign ki_error_inte_c = ki_error_inte_delay_r+ki_error_c;
	always @ (posedge gen_clk_i or posedge  reset_i)
	begin
		if(reset_i) ki_error_inte_delay_r <= {(ERROR_WIDTH+KI_WIDTH-1){1'b0}};
		else ki_error_inte_delay_r <= ki_error_inte_c;
	end

	//truncate to integer
	assign ki_error_trun_c = $signed(ki_error_inte_c[ERROR_WIDTH-1:0]);

	assign dco_cc_o = ki_error_trun_c+kp_error_c;

endmodule