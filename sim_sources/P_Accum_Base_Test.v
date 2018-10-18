`timescale 1ns / 1ps
module PhaseAccumBaseTest();//rename file
	localparam WIDTH = 6;
	wire clkmine;
	reg reset;
	reg clk;
    reg enable;
    reg [WIDTH-1:0] f_select;
    /*clockReset  clkGen  (
            .clk100 (clk100),       // input clock at 100 MHz
            .rstPBn (rstPBn),       // input reset, active low
            .clk5   (clk5),         // output clock, 5 MHz
            .reset  (reset) );      // output reset, active high
            */
    PhaseAccum #(.WIDTH(WIDTH)) testOsc (
                .enable_i (enable),
                .reset_i (reset),
                .fpga_clk_i (clk),
				.clk_o (clkmine),
				.k_val_i (f_select));  // segment
    initial
		begin
			clk  = 1'b1;
			forever
				#10 clk  = ~clk ;
		end
    initial
        begin
        	reset = 1'b1;
            enable = 1'b0;
            f_select = 32'b1;
            #300
            reset = 1'b0;
            #1000
            enable = 1'b1;
            #1500
            f_select = 32'b10;
            #1500
            enable = 1'b0;
            #10
            $stop;
        end


endmodule // end