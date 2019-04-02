`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : DD-Month-YYYY                                                  */
/* Function : ADPLL using inverter based oscillator                          */
/*****************************************************************************/
module RingADPLL #(
		parameter RO_WIDTH = 5,			//control width of oscillator
		parameter PDET_WIDTH = 5,		//width of phase detector output
		parameter RINGSIZE = 401,   	//default number of inverters
		parameter BIAS = 5'd16, 		//bias point for oscillator
		//LoopFilter
		parameter DYNAMIC_VAL = 0,		//whether filter gains will chain at runtime
		parameter KP_WIDTH = 6,			//width of kp
		parameter KP_FRAC_WIDTH = 5,	//fractional width of kp
		parameter KP = 5'b01001,		//kp compile time value
		parameter KI_WIDTH = 4,			//width of ki
		parameter KI_FRAC_WIDTH = 7,	//fractional width of ki
		parameter KI = 8'b00000001		//ki compile time value
	)
	(
        input wire reset_i,				//reset high
        input wire fpga_clk_i,
        input wire ref_clk_i,			//reference clock
        input wire enable_i,
		input wire [KP_WIDTH-1:0] kp_i, //kp runtime value
		input wire [KI_WIDTH-1:0] ki_i,	//ki runtime value
        output wire gen_clk_o,			//clock output
        output wire gen_div8_o,			//divided clock output
        output wire signed [PDET_WIDTH-1:0] error_o,
        output wire signed [RO_WIDTH-1:0] dco_cc_o
    );
    
    /*************************************************************************/
    /* Define nets and assign outputs                                        */
    /*************************************************************************/

    wire [RO_WIDTH-1:0] 		 f_sel_sw_ro_x; //biased control code
    wire 						 gen_clk_x;
    wire 						 gen_div8_x;
    wire signed [PDET_WIDTH-1:0] error_x;

    assign gen_clk_o = gen_clk_x;
    assign gen_div8_o = gen_div8_x;
    assign error_o = error_x;

    /*************************************************************************/
    /* Module instantiation                                                  */
    /*************************************************************************/

    RingOsc #(
    	.RINGSIZE(RINGSIZE), 
    	.CTRL_WIDTH(RO_WIDTH)
    )
    testRing
    ( 
        .enable_i (enable_i),
        .reset_i (reset_i),
        .freq_sel_i (f_sel_sw_ro_x),
        .clk_o (gen_clk_x)
	);


	Div8 div8 ( 
		.reset_i(reset_i),
    	.signal_i(gen_clk_x),
    	.div4_o(gen_div8_x)
   	);

	PhaseDetector #(
		.WIDTH(PDET_WIDTH)
	) 
	testPDet
	(
		.reset_i(reset_i), 
		.fpga_clk_i(fpga_clk_i),
		.reference_i(ref_clk_i),
		.generated_i(gen_div8_x),
		.pd_clock_cycles_o(error_x)
	);

    LoopFilterFrac #(
		.ERROR_WIDTH(PDET_WIDTH),
		.DCO_CC_WIDTH(RO_WIDTH),
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
        .gen_clk_i(gen_clk_x),
        .reset_i(reset_i),
        .error_i(error_x),
        .kp_i(kp_i),
        .ki_i(ki_i),
        .dco_cc_o(dco_cc_o) 
    );

	//assign output
    assign f_sel_sw_ro_x = BIAS + dco_cc_o;

 endmodule // RingADPLL