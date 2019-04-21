`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-November-2019                                               */
/* Function : FPGA clocked phase detector with a resolution of 1/fpga_clock, */
/*            made up of a up/down counter & a state machine for sign        */
/*            detection                                                      */
/*****************************************************************************/
module PhaseDetector #(parameter WIDTH = 8) (
        input  wire                    reset_i,            //reset high
        input  wire                    fpga_clk_i,
        input  wire                    reference_i,
        input  wire                    generated_i,
        output wire signed [WIDTH-1:0] pd_clock_cycles_o
    );
    
    /*************************************************************************/
    /* Define nets                                                           */
    /*************************************************************************/

    wire signed [WIDTH-1:0] counter_val_x;
    wire        [1:0]       count_instr_x;
    wire                    save_and_clear_x;
    wire                    counter_cleared_x;

    wire ref_edge_x;
    wire gen_edge_x;

    wire generated_synced_i;
    wire reference_synced_i;

    /*************************************************************************/
    /* Phase detector sub-modules                                            */
    /*************************************************************************/

    //synchronisers to avoid metastability & perform measurement quantisation
    Synchroniser genSync (
        .clk_i(fpga_clk_i),
        .async_i(generated_i),
        .sync_o(generated_synced_i)
    );

    Synchroniser refSync (
        .clk_i(fpga_clk_i),
        .async_i(reference_i),
        .sync_o(reference_synced_i)
    );

    //two directional counter with variable width 2s complement answer
    UpDownCounter #(.WIDTH(WIDTH)) upDownCounter (
        .reset_i(reset_i),
        .clear_i(save_and_clear_x),
        .fpga_clk_i(fpga_clk_i),
        .count_instr_i(count_instr_x),
        .counter_val_o(counter_val_x)
    );

    //module holds the result constant between measureme
    SaveCounter #(.WIDTH(WIDTH)) saveCounter (
        .fpga_clk_i(fpga_clk_i),
        .reset_i(reset_i),
        .trigger_i(save_and_clear_x),
        .counter_val_i(counter_val_x),
        .counter_val_saved_o(pd_clock_cycles_o),
        .counter_cleared_o(counter_cleared_x)
    );

    //finite state machine governs phase detector behaviour
    StateMachine stateMachine(
        .reset_i(reset_i),
        .fpga_clk_i(fpga_clk_i),
        .reference_synced_i(reference_synced_i),
        .generated_synced_i(generated_synced_i),
        .counter_cleared_i(counter_cleared_x),
        .save_and_clear_o(save_and_clear_x),
        .count_instr_o(count_instr_x)
    );

endmodule // PhaseDetector