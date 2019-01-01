`timescale 1ns / 1ps


module RingADPLLTestBench ();
	reg rst_pbn;

    wire digit_o;
    wire segment_o;

    reg ref_clk_x;
	reg ref_div8_x;
    reg clk258_x;
	
	wire reset_x;

    wire signed [7:0] error_x;
    wire signed [8:0] dco_cc;
    wire [7:0] error_hex_x;

    wire ra_o;

    assign reset_x = ~rst_pbn;
	
	localparam RINGSIZE = 301;
	localparam TARGET_HALF_PERIOD = 50;
	localparam REF_HALF_PERIOD = TARGET_HALF_PERIOD*8;

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

    RingADPLL #(.RINGSIZE(301)) adpll (
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
        .clock 		(ref_clk_x),       // 5 MHz clock signal
        .reset 		(reset_x),      // reset signal, active high
        .value 		(error_hex_x),   // input value to be displayed
        .point 		(4'b1111),    	// radix markers to be displayed
        .digit 		(digit_o),      // digit outputs
        .segment 	(segment_o)  	// segment outputs
    );   

	initial
	begin
		rst_pbn = 1'b0;
		#100
		rst_pbn = 1'b1;
		#100000
		$stop;
	end

endmodule // PhDetTopTestBench	
