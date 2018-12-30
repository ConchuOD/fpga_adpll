`timescale 1ns / 0.01ps


module PhDetTopTestBenchValSave ();

    integer file;
    integer uid = 0;

    initial
    begin
        file = $fopen("log","w");
        $fwrite(file,"%d,\n",uid);
        forever
        begin
        	#3.875969 $fwrite(file,"%t,%d,%d,%d\n", $time, error_x, clk5_x, ra_o);
        end
        //always @ (posedge clk258_x)
        //begin
        //	$fwrite(file,"%t,%d,%d,%d\n", $time, error_x, clk5_x, ra_o);
        //end
    end

	reg rst_pbn;

    wire digit_o;
    wire segment_o;

    reg clk5_x;
    reg clk258_x;

    wire signed [7:0] error_x;
    wire signed [8:0] dco_cc;
    wire [7:0] error_hex_x;

    wire ra_o;

    assign reset_x = ~rst_pbn;

    initial
	begin
		clk258_x  = 1'b0;
		forever
		begin
			#1.937984 clk258_x = ~clk258_x;
		end
	end
	initial
	begin
		clk5_x  = 1'b0;
		forever
		begin
			#100 clk5_x = ~clk5_x;
		end
	end

    RingADPLL adpll (
    	.reset_i(reset_x),
    	.fpga_clk_i(clk258_x),
    	.ref_clk_i(clk5_x),
        .enable_i(1'b1),
    	.gen_clk_o(ra_o),
    	.error_o(error_x),
        .dco_cc_o(dco_cc)
    );

    SignedDec2Hex sDec2Hex(
        .signed_dec_i(error_x),
        .hex_o(error_hex_x)
    );

    //2s to unsigned to hex to seg lol
    DisplayInterface disp1 (
        .clock 		(clk5_x),       // 5 MHz clock signal
        .reset 		(reset_x),      // reset signal, active high
        .value 		({8'b1,error_hex_x}),   // input value to be displayed
        .point 		(4'b1111),    	// radix markers to be displayed
        .digit 		(digit_o),      // digit outputs
        .segment 	(segment_o)  	// segment outputs
    );   

	initial
	begin
		rst_pbn = 1'b0;
		#100
		rst_pbn = 1'b1;
		#1000000
		$stop;
        #10
        $fclose(file);
        $finish;
	end

endmodule // PhDetTopTestBench	
