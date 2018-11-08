module LoopFilterTestBench ();
	reg rst_pbn;

    reg clk5_x;

    wire signed [7:0] error_x = 8'd10;

    wire [7:0] ra_o;

    assign reset_x = ~rst_pbn;

	initial
	begin
		clk5_x  = 1'b0;
		forever
		begin
			#99 clk5_x = ~clk5_x;
		end
	end
	LoopFilter loopFilter(
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