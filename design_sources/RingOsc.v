module RingOsc #(parameter RINGSIZE = 333, CTRL_WIDTH = 4)( 
	input wire enable_i,
    input wire [CTRL_WIDTH-1:0] freq_sel_i,
    output wire clk_o
    );

    localparam INVERTERNUM = RINGSIZE-1; //first is a NAND
    (* DONT_TOUCH = "TRUE" *) wire [0:INVERTERNUM] ringwire_c;
    reg f_sel_mux_out_r;

    genvar i;
    generate
        for (i = 1;i <= INVERTERNUM;i = i+1)
            begin: RING
                not inverter(ringwire_c[i], ringwire_c[i-1]);
        end
    endgenerate
    
    always @(freq_sel_i,ringwire_c)
    begin
        if (freq_sel_i == {(CTRL_WIDTH){1'b0}})
            f_sel_mux_out_r = ringwire_c[INVERTERNUM];
        else
            f_sel_mux_out_r = ringwire_c[INVERTERNUM-2*freq_sel_i];
    end
    
    assign ringwire_c[0] = !((f_sel_mux_out_r) & (enable_i));

    buf outbuf (clk_o, ringwire_c[INVERTERNUM]);

endmodule