module LoopFilter #(
		parameter DYNAMIC_VAL = 0,
		parameter ERROR_WIDTH = 8,
		parameter DCO_CC_WIDTH = 9,
		parameter KP_WIDTH = 3,
		parameter KP_FRAC_WIDTH = 1,
		parameter KP = 3'b001,
		parameter KI_WIDTH = 4,
		parameter KI_FRAC_WIDTH = 3,
		parameter KI = 4'b0001
	)
	(
		input wire gen_clk_i,
		input wire reset_i,
		input wire [KP_WIDTH-1:0] kp_i,
		input wire [KI_WIDTH-1:0] ki_i,
		input wire signed [ERROR_WIDTH-1:0] error_i,
		output wire signed [DCO_CC_WIDTH-1:0] dco_cc_o
	);
	
	localparam KP_INT_WIDTH = KP_WIDTH-KP_FRAC_WIDTH;
	localparam KI_INT_WIDTH = KI_WIDTH-KI_FRAC_WIDTH;

	reg signed [KP_INT_WIDTH-1:-KP_FRAC_WIDTH] kp_x;
	reg signed [KI_INT_WIDTH-1:-KI_FRAC_WIDTH] ki_x;

	reg signed [ERROR_WIDTH-1:0] error_delay_r;
	
	wire signed [(ERROR_WIDTH-1)+KP_INT_WIDTH:-KP_FRAC_WIDTH] kp_error_c;
	wire signed [ERROR_WIDTH-1:0] kp_error_trun_c;

	wire signed [(ERROR_WIDTH-1)+KI_INT_WIDTH:-KI_FRAC_WIDTH] ki_error_c;
	wire signed [(ERROR_WIDTH-1)+KI_INT_WIDTH:-KI_FRAC_WIDTH] ki_error_inte_c;
	reg signed [(ERROR_WIDTH-1)+KI_INT_WIDTH:-KI_FRAC_WIDTH] ki_error_inte_delay_r;
	wire signed [ERROR_WIDTH-1:0] ki_error_trun_c;
	
	always @(DYNAMIC_VAL)
	begin
		if (DYNAMIC_VAL)
		begin
			kp_x = kp_i;
			ki_x = ki_i;
		end
		else
		begin
			kp_x = KP;
			ki_x = KI;
		end
	end

	always @ (posedge gen_clk_i or posedge reset_i)
	begin
		if(reset_i) error_delay_r <= {((ERROR_WIDTH-1)+KI_INT_WIDTH+KI_FRAC_WIDTH){1'b0}};
		else error_delay_r <= error_i;
	end

	/*
		kp route
	*/
	//multiply by kp
	assign kp_error_c = error_delay_r*kp_x;
	//truncate
	assign kp_error_trun_c = $signed(kp_error_c[ERROR_WIDTH-1:0]);

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

	assign dco_cc_o = ki_error_trun_c+kp_error_trun_c;

endmodule