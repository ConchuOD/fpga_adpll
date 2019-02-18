module LoopFilterTestBench ();
	reg rst_pbn;

    reg clk5_x;

    wire signed [4:0] error_x = 5'd10;

    wire [7:0] ra_o;

    wire reset_x;

    assign reset_x = ~rst_pbn;

	initial
	begin
		clk5_x  = 1'b0;
		forever
		begin
			#99 clk5_x = ~clk5_x;
		end
	end

	
	localparam DYNAMIC_VAL = 0;
	localparam DCO_CC_WIDTH = 5;
	localparam ERROR_WIDTH = 5;
	localparam KP_WIDTH = 5;
	localparam KP_FRAC_WIDTH = 3;
	localparam KP = 5'b00100;
	localparam KI_WIDTH = 6;
	localparam KI_FRAC_WIDTH = 5;
	localparam KI = 6'b000100;
	

	/*
	localparam DYNAMIC_VAL = 0;
	localparam DCO_CC_WIDTH = 9;
	localparam ERROR_WIDTH = 8;
	localparam KP_WIDTH = 5;
	localparam KP_FRAC_WIDTH = 4;
	localparam KP = 4'b01001;
	localparam KI_WIDTH = 8;
	localparam KI_FRAC_WIDTH = 7;
	localparam KI = 6'b00000001;
	*/
	

	LoopFilter #(
		.ERROR_WIDTH(ERROR_WIDTH),
		.DCO_CC_WIDTH(DCO_CC_WIDTH),
		.KP_WIDTH(KP_WIDTH),
		.KP_FRAC_WIDTH(KP_FRAC_WIDTH),
		.KP(KP),
		.KI_WIDTH(KI_WIDTH),
		.KI_FRAC_WIDTH(KI_FRAC_WIDTH),
		.KI(KI),
		.DYNAMIC_VAL(DYNAMIC_VAL)
	)
	loopFilter
	(
		.gen_clk_i(clk5_x),
		.reset_i(reset_x),
		.error_i(error_x),
		.dco_cc_o(ra_o)	
	);

	initial
	begin
		rst_pbn = 1'b0;
		#10 
		rst_pbn = 1'b1;
		#1000
		$stop;
	end

endmodule // LoopFilterTestBench