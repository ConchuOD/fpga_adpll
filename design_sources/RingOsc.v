`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-November-2019                                               */
/* Function : Inverter based oscillator. Propagation delay and control code  */
/*            set the frequency of operation.                                 */
/*****************************************************************************/
module RingOsc #(
        parameter RINGSIZE = 421, //number of inverters, must be even
        parameter CTRL_WIDTH = 5  //width of the control code
    )
    ( 
	    input wire enable_i, //enable high
        input wire reset_i, // reset high
        input wire [CTRL_WIDTH-1:0] freq_sel_i, //bigger is shorter period
        output wire early_clk_o, //phase leading version of generated clock
        output wire clk_o
    );
    
    /*************************************************************************/
    /* Define nets and constants                                             */
    /*************************************************************************/

    //first "inverter" is actually a nand with enable signal
    localparam INVERTERNUM = RINGSIZE-1;

    //DONT_TOUCH ensures that what vivado deems to be "useless" logic will not be removed
    (* DONT_TOUCH = "TRUE" *) wire [0:INVERTERNUM] ringwire_c;

    reg f_sel_mux_out_r;
    
    /*************************************************************************/
    /* Inverter chain                                                        */
    /*************************************************************************/

    //generate statement used for ease of use, each inverter connected in a row
    genvar i;
    generate
        for (i = 1;i <= INVERTERNUM;i = i+1)
            begin: RING
                not inverter(ringwire_c[i], ringwire_c[i-1]);
        end
    endgenerate

    /*************************************************************************/
    /* Combiational logic                                                    */
    /*************************************************************************/
    
    //output selection multiplexor. 2* ensures odd number of inverters.
    always @(freq_sel_i,ringwire_c,reset_i)
    begin
        if (reset_i)
            f_sel_mux_out_r = 1'b0;
        else if (freq_sel_i == {(CTRL_WIDTH){1'b0}})
            f_sel_mux_out_r = ringwire_c[INVERTERNUM];
        else
            f_sel_mux_out_r = ringwire_c[INVERTERNUM-2*freq_sel_i];
    end
    
    //nand gate replaces first inverter for enable
    assign ringwire_c[0] = !((f_sel_mux_out_r) & (enable_i));

    //output bufferrs
    buf outbuf (clk_o, ringwire_c[INVERTERNUM]);
    buf outbuf_early (early_clk_o, ringwire_c[INVERTERNUM-2*CTRL_WIDTH-75]); //ensures edge before clk edge

endmodule