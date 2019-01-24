module ErrorCombinerTestBench ();
	reg rst_pbn;

    reg clk5_x;

    wire signed [7:0] error_x;

    reg signed [3:0] w0,w1,w2,w3;
    reg signed [7:0] e0,e1,e2,e3;

    assign reset_x = ~rst_pbn;

	initial
	begin
		clk5_x  = 1'b0;
		forever
		begin
			#99 clk5_x = ~clk5_x;
		end
	end


	ErrorCombiner errorCombiner (
		.reset_i(reset_x),
        .weight_0_i(w0),
        .weight_1_i(w1),
        .weight_2_i(w2),
        .weight_3_i(w3),
        .error_0_i(e0),
        .error_1_i(e1),        
        .error_2_i(e2),
        .error_3_i(e3),
        .error_comb_o(error_x)
	);

	initial
	begin
		rst_pbn = 1'b0;
		w0 = 4'd2;
		w1 = 4'd2;
		w2 = 4'd0;
		w3 = 4'd0;
		e0 = 8'd10;
		e1 = -8'd20;
		e2 = 8'd10;
		e3 = 8'd10;
		#10 
		rst_pbn = 1'b1;
		#1000
		$stop;
	end

endmodule // ErrorCombinerTestBench