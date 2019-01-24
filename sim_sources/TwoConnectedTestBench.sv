`timescale 1ns / 0.01ps

module TwoConnectedTestBench ();


	localparam ACCUM_WIDTH = 12;
	localparam BIAS = 12'd150; //154 = 10 MHz
	localparam TARGET_HALF_PERIOD = 50;
	localparam REF_HALF_PERIOD = TARGET_HALF_PERIOD*8;

	wire reset_x;
 
	wire ext_reference_x;
    wire gen_reference_x;
    wire ref_adpll_div8_x;
    wire other_adpll_div8_x;

    wire clk5_x;
    wire clk5_0_x;
    wire clk5_45_x;
    wire clk5_90_x;
    wire clk5_135_x;

    //wire clk258_x;

    wire [ACCUM_WIDTH-1:0] ref_sel_c;

    wire signed [7:0] error_x;

    wire [7:0] half_7seg_x;

	reg rst_pbn;
	//
    wire digit_o;
    wire segment_o;
    wire [7:0] ra_o;

    reg ref_clk_x;
    reg clk258_x;
    reg clk129_x;	
    reg ref_div8_x;

    /**
    wire signed [7:0] error_x;
    wire signed [8:0] dco_cc;
    wire [7:0] error_hex_x;

	wire reset_x;
	*/

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

	assign ext_reference_x = ~ref_div8_x; //1.125 MHz ref_div8_x?

    wire [5-1:0] padded_kp_c;
    wire [8-1:0] padded_ki_c;
    assign padded_kp_c = {1'b0,5'b01001}; //opt is 5'b0 1001
    assign padded_ki_c = {4'b0000,8'b00000001}; //opt is 8'b0000 0001

    ADPLLw2Inputs #(
        .BIAS(BIAS),
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(8),
        .KI_FRAC_WIDTH(7),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1) 
    ) 
    refAdpll
    (
        .reset_i(reset_x),
        .fpga_clk_i(clk258_x),
        .ref_clk_i(ext_reference_x),
        .other_clk_i(other_adpll_div8_x),
        .enable_i(1'b1),
        .gen_clk_o(ra_o[0]),
        .gen_div8_o(ref_adpll_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

	ADPLL #(
		.BIAS(BIAS),
        //.KP(5'b00001),
        .KP_WIDTH(5),
        .KP_FRAC_WIDTH(4),
        .KI_WIDTH(8),
        .KI_FRAC_WIDTH(7),
        //.KI(7'b0000001)
        .DYNAMIC_VAL(1'b1)
	) 
	adpll
	(
    	.reset_i(reset_x),
    	.fpga_clk_i(clk258_x),
    	.ref_clk_i(ref_adpll_div8_x),
        .enable_i(1'b1),
    	.gen_clk_o(ra_o[4]),
        .gen_div8_o(other_adpll_div8_x),
        .kp_i(padded_kp_c), //padded_kp_c
        .ki_i(padded_ki_c) //padded_ki_c
    );

	initial
	begin
		rst_pbn = 1'b0;
		#100
		rst_pbn = 1'b1;
		#10000
		$stop;
        //$finish;
	end

endmodule // TwoConnectedTestBench