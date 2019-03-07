`timescale 1ns / 1ps

module PhaseDetectorDL #(parameter WIDTH = 5) (
        output wire sign_delay_o,
        input wire reset_i,
        input wire fpga_clk_i, //preserved for interface compatability
        input wire reference_i,
        input wire generated_i,
        output wire signed [WIDTH-1:0] pd_clock_cycles_o
    );

    localparam MAG_WIDTH = WIDTH-1;
    localparam NUM_TAPS = (2 ** MAG_WIDTH) - 1;

    (* DONT_TOUCH = "TRUE" *) reg ref_q_r, gen_q_r;
    (* DONT_TOUCH = "TRUE" *) reg sign_delay_r;
    (* DONT_TOUCH = "TRUE" *) reg clear_tdl_c;

    (* DONT_TOUCH = "TRUE" *) wire done_c, count_c, clear_c;
    (* DONT_TOUCH = "TRUE" *) wire which_first_c;
    (* DONT_TOUCH = "TRUE" *) wire sign_c;

    assign sign_delay_o = sign_delay_r;
    assign clear_c = done_c;

    reg [MAG_WIDTH-1:0] error_bin_r;
    reg [WIDTH-1:0] error_2s_comp_c;

    always @ (error_bin_r or sign_delay_r)
    begin
        if(sign_delay_r)    error_2s_comp_c = $signed({sign_delay_r,~error_bin_r[MAG_WIDTH-1:0]});
        else                error_2s_comp_c = $signed({sign_delay_r,error_bin_r[MAG_WIDTH-1:0]});
    end

    assign pd_clock_cycles_o = error_2s_comp_c;


    /* Sign Detection Section */

    always @ (posedge reference_i or posedge reset_i or posedge clear_c)
    begin
        if (reset_i || clear_c) ref_q_r <= 1'b0;

        else if (reference_i) ref_q_r <= 1'b1;

        else ref_q_r <= 1'b0;
    end

    always @ (posedge generated_i or posedge reset_i or posedge clear_c)
    begin
        if (reset_i || clear_c) gen_q_r <= 1'b0;

        else if (generated_i) gen_q_r <= 1'b1;

        else gen_q_r <= 1'b0; //should be unreachable
    end

    (* DONT_TOUCH = "TRUE" *) and done_and (done_c, ref_q_r, gen_q_r);
    (* DONT_TOUCH = "TRUE" *) or count_or (count_c, ref_q_r, gen_q_r);

    /* Time Difference Calculation */
    (* DONT_TOUCH = "TRUE" *) SRLatchGate arbitration(
        .R(~ref_q_r),
        .S(~gen_q_r),
        .Q(which_first_c)
    );

    (* DONT_TOUCH = "TRUE" *) SRLatchGate sign(
        .R(which_first_c),
        .S(~which_first_c),
        .Q(sign_c)
    );

    always @ (posedge done_c or posedge reset_i)
    begin
        if (reset_i) sign_delay_r <= 0'b0;

        else if (done_c) sign_delay_r <= sign_c;

        else  sign_delay_r <= 0'b0; //should be unreachable
    end

    (* DONT_TOUCH = "TRUE" *) wire [1:NUM_TAPS] count_input_c;
    (* DONT_TOUCH = "TRUE" *) reg [1:NUM_TAPS] error_taps_r;
    (* DONT_TOUCH = "TRUE" *) reg [1:NUM_TAPS] error_taps_buff_r;
    (* DONT_TOUCH = "TRUE" *) wire [0:2*NUM_TAPS] count_delayed_c;

    assign count_delayed_c[0] = count_c;

    always @ (count_c or done_c) //ditch this?
    begin
        if (done_c) clear_tdl_c = 1'b1;

        else clear_tdl_c = 1'b0;
    end

    genvar i;
    generate
        for (i = 1;i <= NUM_TAPS;i = i+1)
        begin: TAPPED_DELAY_LINE            
            (* DONT_TOUCH = "TRUE" *) not tap_delay_1(count_delayed_c[2*i-1], count_delayed_c[2*(i-1)]);
            (* DONT_TOUCH = "TRUE" *) not tap_delay_2(count_delayed_c[2*i], count_delayed_c[2*i-1]);  

            assign count_input_c[i] = count_delayed_c[2*(i-1)]; 

            always @ (posedge count_input_c[i] or posedge reset_i or posedge clear_tdl_c)
            begin
                if (reset_i == 1'b1 || clear_tdl_c == 1'b1) error_taps_r[i] <= 1'b0; //neg of clear_tdl_c

                else if (count_c == 1'b1) error_taps_r[i] <= 1'b1;

                else error_taps_r[i] <= 1'b0; // if edge arrives after counting has been stopped ?
            end

            always @ (posedge done_c or posedge reset_i)
            begin
                if (reset_i) error_taps_buff_r[i] <= 1'b0;

                else if (done_c) error_taps_buff_r[i] <= error_taps_r[i];

                else error_taps_buff_r[i] <= 1'b0;
            end

        end
    endgenerate

    integer j;

    always @ (*)
    begin
        error_bin_r = {(MAG_WIDTH){1'b0}};
        for (j=1;j<=NUM_TAPS;j=j+1)
        begin
            error_bin_r = error_bin_r + error_taps_buff_r[j];
        end
    end

endmodule // PhaseDetectorDL