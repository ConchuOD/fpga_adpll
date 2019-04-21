`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-March-2019                                                  */
/* Function : Inverter based tapped delay line sig-num phase detector.       */
/*****************************************************************************/
module PhaseDetectorDL #(parameter WIDTH = 5) (
        input  wire                    reset_i,
        input  wire                    fpga_clk_i, //unused but preserved for interface compatability
        input  wire                    reference_i,
        input  wire                    generated_i,
        output wire signed [WIDTH-1:0] pd_clock_cycles_o //used & named as above
    );
    
    /*************************************************************************/
    /* Define nets and constants                                             */
    /*************************************************************************/
    
    //number of bits left after sign bit
    localparam MAG_WIDTH = WIDTH-1;
    
    //number of taps along the delay line
    localparam NUM_TAPS = (2 ** MAG_WIDTH) - 1;

    //liberal use of DONT_TOUCH required to maintain timing behaviour
    (* DONT_TOUCH = "TRUE" *) reg ref_q_r, gen_q_r;
    (* DONT_TOUCH = "TRUE" *) reg sign_delay_r;
    (* DONT_TOUCH = "TRUE" *) reg clear_tdl_c;

    (* DONT_TOUCH = "TRUE" *) wire done_c, count_c, clear_c;
    (* DONT_TOUCH = "TRUE" *) wire which_first_c;
    (* DONT_TOUCH = "TRUE" *) wire sign_c;  

    (* DONT_TOUCH = "TRUE" *) wire [1:NUM_TAPS]   count_input_c;
    (* DONT_TOUCH = "TRUE" *) reg  [1:NUM_TAPS]   error_taps_r;
    (* DONT_TOUCH = "TRUE" *) reg  [1:NUM_TAPS]   error_taps_buff_r;
    (* DONT_TOUCH = "TRUE" *) wire [0:2*NUM_TAPS] count_delayed_c;
    
    reg [MAG_WIDTH-1:0] error_bin_r;
    reg [WIDTH-1:0] error_2s_comp_c;

    //double named net for clarity
    assign clear_c = done_c;

    /*************************************************************************/
    /* Sign detection                                                        */
    /*************************************************************************/

    //reference edge detector
    always @ (posedge reference_i or posedge reset_i or posedge clear_c)
    begin
        if (reset_i || clear_c) ref_q_r <= 1'b0;

        else if (reference_i) ref_q_r <= 1'b1;

        else ref_q_r <= 1'b0;
    end

    //generated signal edge detector
    always @ (posedge generated_i or posedge reset_i or posedge clear_c)
    begin
        if (reset_i || clear_c) gen_q_r <= 1'b0;

        else if (generated_i) gen_q_r <= 1'b1;

        else gen_q_r <= 1'b0; //should be unreachable
    end

    //tapped delay line control signals
    (* DONT_TOUCH = "TRUE" *) and done_and (done_c, ref_q_r, gen_q_r);
    (* DONT_TOUCH = "TRUE" *) or  count_or (count_c, ref_q_r, gen_q_r);

    //Arbitrator imitation circuit
    (* DONT_TOUCH = "TRUE" *) SRLatchGate arbitration
    (
        .R(~ref_q_r),
        .S(~gen_q_r),
        .Q(which_first_c)
    );

    //Sign detection circuit
    (* DONT_TOUCH = "TRUE" *) SRLatchGate sign
    (
        .R(which_first_c),
        .S(~which_first_c),
        .Q(sign_c)
    );
    
    //output buffer
    always @ (posedge done_c or posedge reset_i)
    begin
        if (reset_i)     sign_delay_r <= 0'b0;

        else if (done_c) sign_delay_r <= sign_c;

        else             sign_delay_r <= 0'b0; //should be unreachable
    end

    /*************************************************************************/
    /* Tapped delay line                                                     */
    /*************************************************************************/

    //connect delay line to input signal
    assign count_delayed_c[0] = count_c;

    //tdl clear signal logic
    always @ (count_c or done_c)
    begin
        if (done_c) clear_tdl_c = 1'b1;

        else        clear_tdl_c = 1'b0;
    end

    //tapped delay line
    genvar i;
    generate
        for (i = 1;i <= NUM_TAPS;i = i+1)
        begin: TAPPED_DELAY_LINE
            //double inverter delay between taps
            (* DONT_TOUCH = "TRUE" *) not tap_delay_1(count_delayed_c[2*i-1], count_delayed_c[2*(i-1)]);
            (* DONT_TOUCH = "TRUE" *) not tap_delay_2(count_delayed_c[2*i],   count_delayed_c[2*i-1]);  
            
            assign count_input_c[i] = count_delayed_c[2*(i-1)]; 
            
            //tap registers
            always @ (posedge count_input_c[i] or posedge reset_i or posedge clear_tdl_c)
            begin
                //neg of clear_tdl_c
                if (reset_i == 1'b1 || clear_tdl_c == 1'b1) error_taps_r[i] <= 1'b0; 

                else if (count_c == 1'b1)                   error_taps_r[i] <= 1'b1;
                // in case edge arrives after counting period has ended
                else                                        error_taps_r[i] <= 1'b0;

            //output buffer registers
            always @ (posedge done_c or posedge reset_i)
            begin
                if (reset_i)     error_taps_buff_r[i] <= 1'b0;

                else if (done_c) error_taps_buff_r[i] <= error_taps_r[i];

                else             error_taps_buff_r[i] <= 1'b0;
            end

        end
    endgenerate

    /*************************************************************************/
    /* Taps to output                                                        */
    /*************************************************************************/

    //temperature code to binary
    integer j;
    always @ (*)
    begin
        error_bin_r = {(MAG_WIDTH){1'b0}};
        for (j=1;j<=NUM_TAPS;j=j+1)
        begin
            error_bin_r = error_bin_r + error_taps_buff_r[j];
        end
    end
    
    //concatanation of sign and magnutide
    always @ (error_bin_r or sign_delay_r)
    begin
        if(sign_delay_r)    error_2s_comp_c = $signed({sign_delay_r , ~(error_bin_r[MAG_WIDTH-1:0])}-1'b1);
        else                error_2s_comp_c = $signed({sign_delay_r , error_bin_r[MAG_WIDTH-1:0]});
    end
    
    //assign output
    assign pd_clock_cycles_o = error_2s_comp_c;

endmodule // PhaseDetectorDL