module LoopFilterTest #(
		parameter DYNAMIC_VAL = 0,
		parameter ERROR_WIDTH = 5,
		parameter DCO_CC_WIDTH = 5,
		parameter KP_WIDTH = 5,
		parameter KP = 5'd1,
		parameter KI_WIDTH = 7,
		parameter KI = 7'd1
	)
	(
		output wire [7:0] temp_8bit_bus1,
		output wire [7:0] temp_8bit_bus2,
		input wire gen_clk_i,
		input wire reset_i,
		input wire [KP_WIDTH-1:0] kp_i,
		input wire [KI_WIDTH-1:0] ki_i,
		input wire signed [ERROR_WIDTH-1:0] error_i,
		output wire signed [DCO_CC_WIDTH-1:0] dco_cc_o
	);

	localparam KP_MULT_RES_WIDTH = ERROR_WIDTH+KP_WIDTH;
	localparam KI_MULT_RES_WIDTH = ERROR_WIDTH+KI_WIDTH;
	localparam KI_ACCUM_OVERHEAD = 5;
	localparam SUM_WIDTH = KI_MULT_RES_WIDTH;//ki always wider

	reg signed [KP_WIDTH-1:0] kp_x;
	reg signed [KI_WIDTH-1:0] ki_x;
	
	reg signed [ERROR_WIDTH-1:0] error_delay_r;

	wire signed [KP_MULT_RES_WIDTH-1:0] kp_error_c;
	wire signed [KI_MULT_RES_WIDTH-1:0] kp_error_padded_c;

	wire signed [KI_ACCUM_OVERHEAD+KI_MULT_RES_WIDTH-1:0] ki_error_c;
	wire signed [KI_ACCUM_OVERHEAD+KI_MULT_RES_WIDTH-1:0] ki_error_inte_c;
	reg  signed [KI_ACCUM_OVERHEAD+KI_MULT_RES_WIDTH-1:0] ki_error_inte_delay_r;
	wire signed [KI_MULT_RES_WIDTH-1:0] ki_error_resize_c;
	
	wire signed [SUM_WIDTH-1:0] error_sum_c;
	wire signed [DCO_CC_WIDTH-1:0] error_sum_trun_c;
	reg signed [DCO_CC_WIDTH-1:0] error_sum_trun_delay_r;
	
	assign temp_8bit_bus1 = $unsigned(error_delay_r);
	assign temp_8bit_bus2 = $unsigned(ki_error_inte_c); 

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

	assign dco_cc_o = error_sum_trun_delay_r;

	always @ (posedge gen_clk_i or posedge reset_i)
	begin
		if(reset_i) error_sum_trun_delay_r <= {(DCO_CC_WIDTH){1'b0}};
		else error_sum_trun_delay_r <= error_sum_trun_c;
	end

	always @ (posedge gen_clk_i or posedge reset_i)
	begin
		if(reset_i) error_delay_r <= {(ERROR_WIDTH){1'b0}};
		else error_delay_r <= error_i;
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
    assign ki_error_resize_c = $signed(ki_error_inte_c[KI_ACCUM_OVERHEAD+KI_MULT_RES_WIDTH-1:KI_ACCUM_OVERHEAD]);

	always @ (posedge gen_clk_i or posedge reset_i)
	begin
		if(reset_i) ki_error_inte_delay_r <= {(KI_MULT_RES_WIDTH-1){1'b0}};
		else ki_error_inte_delay_r <= ki_error_inte_c;
	end

	//assign error_sum_c = ki_error_inte_c;
    assign kp_error_padded_c = $signed({kp_error_c, {(KI_WIDTH-KP_WIDTH){1'b0}} }) ;
	assign error_sum_c = kp_error_padded_c + ki_error_resize_c;

	assign error_sum_trun_c = error_sum_c[SUM_WIDTH-1:SUM_WIDTH-DCO_CC_WIDTH];

endmodule