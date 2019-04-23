`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-January-2019                                                */
/* Function : ADPLL using inverter based oscillator with dual phase detector */
/*            and other connections required for cartesian network operation */
/*****************************************************************************/
module NetworkRingADPLL #(
        parameter RO_WIDTH      = 5,            //control width of oscillator
        parameter PDET_WIDTH    = 5,            //width of phase detector output
        parameter RINGSIZE      = 401,          //default number of inverters
        parameter BIAS          = 5'd15,        //bias point for oscillator
        //LoopFilter
        parameter DYNAMIC_VAL   = 0,            //whether filter gains will chain at runtime
        parameter KP_WIDTH      = 6,            //width of kp
        parameter KP_FRAC_WIDTH = 5,            //fractional width of kp
        parameter KP            = 5'b01001,     //kp compile time value
        parameter KI_WIDTH      = 8,            //fractional width of ki
        parameter KI_FRAC_WIDTH = 7,            //width of ki
        parameter KI            = 8'b00000001,  //ki compile time value
        //ErrorCombiner
        parameter WEIGHT_WIDTH  = 4             //width of error combiner weights
    )
    (   
        input  wire                           reset_i,        //reset high
        input  wire                           enable_i,
        input  wire                           fpga_clk_i,      
        input  wire                           ref_left_i,     //reference clock from left neighbour
        input  wire                           ref_above_i,    //reference clock from above neighbour
        input  wire        [PDET_WIDTH-1:0]   error_right_i,  //error input from right neighbour
        input  wire        [PDET_WIDTH-1:0]   error_bottom_i, //error input from bottom neighbour
        input  wire        [KP_WIDTH-1:0]     kp_i,           //kp runtime value
        input  wire        [KI_WIDTH-1:0]     ki_i,           //ki runtime value
        input  wire        [WEIGHT_WIDTH-1:0] weight_left_i,  //sum weights
        input  wire        [WEIGHT_WIDTH-1:0] weight_above_i,
        input  wire        [WEIGHT_WIDTH-1:0] weight_right_i,
        input  wire        [WEIGHT_WIDTH-1:0] weight_below_i,
        output wire                           gen_clk_o,      //clock output
        output wire                           gen_div8_o,     //divided clock output
        output wire signed [PDET_WIDTH-1:0]   error_left_o,   //error output from left detector
        output wire signed [PDET_WIDTH-1:0]   error_above_o,  //error output from above detector
        output wire signed [RO_WIDTH-1:0]     dco_cc_o        //dco control code 
    );
    
    /*************************************************************************/
    /* Define nets and assign outputs                                        */
    /*************************************************************************/

    wire signed [RO_WIDTH-1:0]   lf_out_x;
    wire        [RO_WIDTH-1:0]   f_sel_sw_ro_x;
    wire                         gen_clk_x;
    wire                         gen_div_x;
    wire                         early_clk_x;
    wire                         early_div_x;
    wire signed [PDET_WIDTH-1:0] error_x;
    wire signed [PDET_WIDTH-1:0] error_left_x;
    wire signed [PDET_WIDTH-1:0] error_above_x;
    
    /*************************************************************************/
    /* Assign outputs                                                        */
    /*************************************************************************/

    assign dco_cc_o      = lf_out_x;
    assign gen_clk_o     = gen_clk_x;
    assign gen_div8_o    = gen_div_x;
    assign error_left_o  = error_left_x;
    assign error_above_o = error_above_x; 
    
    /*************************************************************************/
    /* Module instantiations                                                 */
    /*************************************************************************/  
    
    (* DONT_TOUCH = "TRUE" *)  PhaseDetector #(.WIDTH(PDET_WIDTH)) pDetLeft (
        .reset_i(reset_i), 
        .fpga_clk_i(fpga_clk_i),
        .reference_i(ref_left_i),
        .generated_i(gen_div_x),
        .pd_clock_cycles_o(error_left_x)
    );

    (* DONT_TOUCH = "TRUE" *)  PhaseDetector #(.WIDTH(PDET_WIDTH)) pDetAbove (
        .reset_i(reset_i), 
        .fpga_clk_i(fpga_clk_i),
        .reference_i(ref_above_i),
        .generated_i(gen_div_x),
        .pd_clock_cycles_o(error_above_x)
    );
    
    (* DONT_TOUCH = "TRUE" *)  ErrorCombiner #(
        .WEIGHT_WIDTH(WEIGHT_WIDTH),
        .ERROR_WIDTH(PDET_WIDTH)
    )
    errorCombiner
    ( 
        //zero out unconnected, 2 weight on others
        .reset_i(reset_i),
        .weight_0_i(weight_above_i),
        .weight_1_i(weight_left_i),
        .weight_2_i(weight_right_i),
        .weight_3_i(weight_below_i),
        .error_0_i(error_above_x),
        .error_1_i(error_left_x),
        .error_2_i(error_right_i),        
        .error_3_i(error_bottom_i),
        .error_comb_o(error_x)
    );

    LoopFilter #(
        .ERROR_WIDTH(PDET_WIDTH),
        .DCO_CC_WIDTH(RO_WIDTH),
        .KP_WIDTH(KP_FRAC_WIDTH),
        .KP(KP),
        .KI_WIDTH(KI_FRAC_WIDTH),
        .KI(KI),
        .DYNAMIC_VAL(DYNAMIC_VAL)   
    )
    loopFilter 
    (
        .gen_clk_i(early_div_x),
        .reset_i(reset_i),
        .error_i(error_x),
        .kp_i(kp_i),
        .ki_i(ki_i),
        .dco_cc_o(lf_out_x) 
    );

    RingOsc #(
        .RINGSIZE(RINGSIZE), 
        .CTRL_WIDTH(RO_WIDTH)
    ) 
    testRing
    ( 
        .enable_i (enable_i),
        .reset_i (reset_i),
        .freq_sel_i (f_sel_sw_ro_x),
        .early_clk_o (early_clk_x),
        .clk_o (gen_clk_x)
    );

    Div8 div8 ( 
        .reset_i(reset_i),
        .signal_i(gen_clk_x),
        .div1_o(gen_div_x)
    );

    Div8 div8Early ( 
        .reset_i(reset_i),
        .signal_i(early_clk_x),
        .div1_o(early_div_x)
    );
    
    /*************************************************************************/
    /* Combinational logic                                                   */
    /*************************************************************************/
    
    //apply bias to loop filter output
    assign f_sel_sw_ro_x = BIAS + lf_out_x;

 endmodule // NetworkRingADPLL