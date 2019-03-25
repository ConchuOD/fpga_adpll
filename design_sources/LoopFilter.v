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

	localparam KP_MULT_RES_INT_WIDTH = ERROR_WIDTH;//+KP_INT_WIDTH;
	localparam KI_MULT_RES_INT_WIDTH = ERROR_WIDTH;//+KI_INT_WIDTH;

	localparam SUM_INT_WIDTH = KP_MULT_RES_INT_WIDTH;//kp always bigger
	localparam SUM_FRAC_WIDTH = KI_FRAC_WIDTH; //ki always more bits

	reg signed [KP_INT_WIDTH-1:-KP_FRAC_WIDTH] kp_x;
	reg signed [KI_INT_WIDTH-1:-KI_FRAC_WIDTH] ki_x;

	wire signed [ERROR_WIDTH-1:0] error_delay_r;
	
	wire signed [KP_MULT_RES_INT_WIDTH-1:-KP_FRAC_WIDTH] kp_error_c;
	wire signed [ERROR_WIDTH-1:0] kp_error_trun_c;

	wire signed [KI_MULT_RES_INT_WIDTH-1:-KI_FRAC_WIDTH] ki_error_c;
	wire signed [KI_MULT_RES_INT_WIDTH-1:-KI_FRAC_WIDTH] ki_error_inte_c;
	reg  signed [KI_MULT_RES_INT_WIDTH-1:-KI_FRAC_WIDTH] ki_error_inte_delay_r;
	wire signed [ERROR_WIDTH-1:0] ki_error_trun_c;
	
	wire signed [SUM_INT_WIDTH-1:-SUM_FRAC_WIDTH] error_sum_c;
	wire signed [DCO_CC_WIDTH-1:0] error_sum_trun_c;
	reg signed [DCO_CC_WIDTH-1:0] error_sum_trun_delay_r;
	
	always @(DYNAMIC_VAL or reset_i or kp_i or ki_i)
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

	assign error_delay_r = error_i;
	assign dco_cc_o = error_sum_trun_delay_r;

	always @ (posedge gen_clk_i or posedge reset_i)
	begin
		if(reset_i) error_sum_trun_delay_r <= {(DCO_CC_WIDTH){1'b0}};
		else error_sum_trun_delay_r <= error_sum_trun_c;
	end

	/*
		kp route
	*/
	//multiply by kp
	assign kp_error_c = error_delay_r*kp_x;

	/*
		ki route
	*/
	//multiply by ki
	assign ki_error_c = error_delay_r*ki_x;
	//accumulator
	assign ki_error_inte_c = ki_error_inte_delay_r+ki_error_c;

	always @ (posedge gen_clk_i or posedge reset_i)
	begin
		if(reset_i) ki_error_inte_delay_r <= {(KI_MULT_RES_INT_WIDTH-1){1'b0}};
		else ki_error_inte_delay_r <= ki_error_inte_c;
	end

	//assign error_sum_c = ki_error_inte_c; 
	assign error_sum_c = $signed({kp_error_c, {(KI_FRAC_WIDTH-KP_FRAC_WIDTH){1'b0}} }) + ki_error_inte_c;

	assign error_sum_trun_c = error_sum_c[4:1];//[SUM_INT_WIDTH-1:SUM_INT_WIDTH-1-DCO_CC_WIDTH]; //

endmodule