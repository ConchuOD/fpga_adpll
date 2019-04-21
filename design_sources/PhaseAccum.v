/***************************************************************************/
/* Author   : Conor Dooley                                                 */
/* Date     : ??-October-2019                                              */
/* Function : Phase accumulator based oscillator with period set by the    */
/*            width and control code                                       */
/***************************************************************************/

module PhaseAccum #(parameter WIDTH = 4)(
    input  wire enable_i,
    input  wire [WIDTH-1:0] k_val_i, //control code - bigger is high freq
    input  wire fpga_clk_i,
    input  wire reset_i, //reset high
    output wire clk_o
    );
    
    /***********************************************************************/
    /* Define nets                                                         */
    /***********************************************************************/

    reg [WIDTH-1:0] cnt_val_r, next_cnt_val_r;

    /***********************************************************************/
    /* Counter logic                                                       */
    /***********************************************************************/

    //increment count by control code if enable is high, otherwise do nothing
    always @(enable_i, k_val_i, cnt_val_r)
    begin
        if(enable_i == 1'b1) next_cnt_val_r = k_val_i + cnt_val_r;
        else                 next_cnt_val_r = cnt_val_r;
    end

    //counter register
    always @(posedge fpga_clk_i or posedge reset_i)
    begin
        if (reset_i) cnt_val_r <= {(WIDTH){1'b0}};
        else         cnt_val_r <= next_cnt_val_r;
    end

    //assign count MSB is the output
    assign clk_o = cnt_val_r[WIDTH-1];
                    
endmodule                    