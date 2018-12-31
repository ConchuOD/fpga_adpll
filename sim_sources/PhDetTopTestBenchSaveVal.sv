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
        	#3.875969 $fwrite(file,"%t,%d,%d,%d\n", $time, error_x, ref_clk_x, ra_o);
        end
        //always @ (posedge clk258_x)
        //begin
        //	$fwrite(file,"%t,%d,%d,%d\n", $time, error_x, ref_clk_x, ra_o);
        //end
    end
	
	localparam BIAS = 12'd154;
	localparam TARGET_HALF_PERIOD = 50;
	localparam REF_HALF_PERIOD = TARGET_HALF_PERIOD*8;

	reg rst_pbn;

    wire digit_o;
    wire segment_o;

    reg ref_clk_x;
    reg clk258_x;
    reg clk129_x;	
    reg ref_div8_x;

    wire signed [7:0] error_x;
    wire signed [8:0] dco_cc;
    wire [7:0] error_hex_x;

    wire ra_o;
	wire reset_x;

    assign reset_x = ~rst_pbn;

    initial
	begin
		clk129_x  = 1'b0;
		forever
		begin
			#7.751936 clk129_x = ~clk129_x;
		end
	end
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
		ref_clk_x  = 1'b0;
		forever
		begin
			#TARGET_HALF_PERIOD ref_clk_x = ~ref_clk_x; //10 MHz
		end
	end
	initial
	begin
		ref_div8_x  = 1'b0;
		forever
		begin
			#REF_HALF_PERIOD ref_div8_x = ~ref_div8_x; //10 MHz
		end
	end

    ADPLL #(
		.BIAS(BIAS),
		.KP(3'b001),
		.KI_WIDTH(5),
		.KI_FRAC_WIDTH(4),
		.KI(5'b00001)	
	) 
	adpll
	(
    	.reset_i(reset_x),
    	.fpga_clk_i(clk258_x),
    	.ref_clk_i(ref_div8_x),
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
        .clock 		(ref_clk_x),       // 5 MHz clock signal
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
        //$finish;
	end

endmodule // PhDetTopTestBench	
