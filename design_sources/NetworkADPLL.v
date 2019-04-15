`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-January-2019                                                */
/* Function : ADPLL using FPGA clocked oscillator with dual phase detector   */
/*            and other connections required for cartesian network operation */
/*****************************************************************************/
module NetworkADPLL #(
        parameter ACCUM_WIDTH   = 12,       //accumulator width in oscillator
        parameter PDET_WIDTH    = 8,        //width of phase detector output
        parameter BIAS          = 12'd76,   //bias point of oscillator
        parameter DCO_CC_WIDTH  = 9,        //control width of oscillator
        //LoopFilter
        parameter DYNAMIC_VAL   = 0,        //whether filter gains will chain at runtime
        parameter KP_WIDTH      = 3,        //width of kp   
        parameter KP_FRAC_WIDTH = 1,        //fractional width of kp
        parameter KP            = 3'b010,   //kp compile time value 
        parameter KI_WIDTH      = 4,        //width of ki
        parameter KI_FRAC_WIDTH = 3,        //fractional width of ki    
        parameter KI            = 4'b0001,  //ki compile time value
        //errorCombiner
        parameter WEIGHT_WIDTH  = 4         //width of error combiner weights
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
        output wire signed [DCO_CC_WIDTH-1:0] dco_cc_o        //dco control code 
    );
    
    /*************************************************************************/
    /* Define nets & constants and assign outputs                            */
    /*************************************************************************/
    
    localparam PADDING_WIDTH = ACCUM_WIDTH-DCO_CC_WIDTH;

    wire        [ACCUM_WIDTH-1:0] f_sel_sw_pa_x;
    wire                          gen_clk_x;
    wire                          gen_div8_x;
    wire signed [PDET_WIDTH-1:0]  error_x;
    wire signed [PDET_WIDTH-1:0]  error_left_x;
    wire signed [PDET_WIDTH-1:0]  error_above_x;
    
    /*************************************************************************/
    /* Assign outputs                                                        */
    /*************************************************************************/
    
    assign gen_clk_o     = gen_clk_x;
    assign gen_div8_o    = gen_div8_x;
    assign error_left_o  = error_left_x;
    assign error_above_o = error_above_x;
    
    /*************************************************************************/
    /* Module instantiations                                                 */
    /*************************************************************************/     
    
    (* DONT_TOUCH = "TRUE" *)  PhaseDetector #(.WIDTH(PDET_WIDTH)) pDetLeft (
        .reset_i(reset_i), 
        .fpga_clk_i(fpga_clk_i),
        .reference_i(ref_left_i),
        .generated_i(gen_div8_x),
        .pd_clock_cycles_o(error_left_x)
    );

    (* DONT_TOUCH = "TRUE" *)  PhaseDetector #(.WIDTH(PDET_WIDTH)) pDetAbove (
        .reset_i(reset_i), 
        .fpga_clk_i(fpga_clk_i),
        .reference_i(ref_above_i),
        .generated_i(gen_div8_x),
        .pd_clock_cycles_o(error_above_x)
    );
    
    (* DONT_TOUCH = "TRUE" *)  ErrorCombiner #(.WEIGHT_WIDTH(WEIGHT_WIDTH)) errorCombiner ( //zero out unconnected, 2 weight on others
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
    LoopFilterFrac #(
        .ERROR_WIDTH(PDET_WIDTH),
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
        .gen_clk_i(gen_div8_x),
        .reset_i(reset_i),
        .error_i(error_x),
        .kp_i(kp_i),
        .ki_i(ki_i),
        .dco_cc_o(dco_cc_o) 
    );
    PhaseAccum #(.WIDTH(ACCUM_WIDTH)) testOsc (
        .enable_i(enable_i),
        .reset_i(reset_i),
        .fpga_clk_i(fpga_clk_i),
        .clk_o(gen_clk_x),
        .k_val_i(f_sel_sw_pa_x)
    ); 
    Div8 div8 ( 
        .reset_i(reset_i),
        .signal_i(gen_clk_x),
        .div1_o(gen_div8_x)
    );
    
    /*************************************************************************/
    /* Combinational logic                                                   */
    /*************************************************************************/
    
    //apply bias to loop filter output
    assign f_sel_sw_pa_x = BIAS + $signed({ {(PADDING_WIDTH){dco_cc_o[DCO_CC_WIDTH-1]}} ,dco_cc_o});

 endmodule // NetworkADPLL