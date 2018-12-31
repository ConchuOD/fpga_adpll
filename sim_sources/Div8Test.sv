`timescale 1ns / 1ps
module Div8Test();//rename file
	reg clkmine;
    reg reset;
    wire div8clk;
    
    Div8 testDiv( 
				.reset_i (reset),
    			.signal_i (clkmine),
    			.div8_o (div8clk)
   				);

    initial
    begin
        clkmine  = 1'b0;
        forever
        begin
            #2 clkmine = ~clkmine;
        end
    end

    initial
        begin
            reset = 1'b1;
            #1000
            reset = 1'b0;
            #2000
            reset = 1'b0;
            #10
            $stop;
        end


endmodule // end
