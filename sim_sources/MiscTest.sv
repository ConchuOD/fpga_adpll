`timescale 1ns / 1ps


module MiscTest ();

	localparam BIAS = 8'd127;
	localparam RO_WIDTH = 8;
    localparam DCO_CC_WIDTH = RO_WIDTH;
    localparam PADDING_WIDTH = RO_WIDTH-DCO_CC_WIDTH;
	wire [8:0] f_sel_sw_ro_x;
	wire [9:0] f_sel_sw_ro_interim_c;
	wire [9:0] bias_padded_c;
	reg signed [8:0] dco_cc_o;

	//assign f_sel_sw_ro_x = BIAS;
    //assign f_sel_sw_ro_x = BIAS - dco_cc_o;
	assign bias_padded_c = $signed({1'd0, BIAS});
	//convert to signed after concat, all the below line does is replicate the top bit the needed number of times and then subtract from the bias
	assign f_sel_sw_ro_interim_c = bias_padded_c + $signed({ {(PADDING_WIDTH){dco_cc_o[DCO_CC_WIDTH-1]}}, dco_cc_o});//minus avoids negative feedback
    assign f_sel_sw_ro_x = f_sel_sw_ro_interim_c[RO_WIDTH-1:0];

    initial
    begin
    	dco_cc_o = 0;
    	forever
    	begin
    	#100 dco_cc_o = dco_cc_o + 1'b1;
    	end
    end

endmodule // MiscTest
