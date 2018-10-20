`timescale 1ns / 1ps
module RingOscTest();//rename file
	wire clkmine;
    reg enable_r;
    reg [3:0] f_select;
    
    RingOsc testRing( 
				.enable_i (enable_r),
    			.freq_sel_i (f_select),
    			.clk_o (clkmine)
   				);
    initial
        begin
            enable_r = 1'b0;
            f_select = 1'b0;
            #1000
            enable_r = 1'b1;
            #2000
            f_select = 4'b0001;
            #2000
            f_select = 4'b0010;
            #2000
            f_select = 4'd6;
            #2000
            f_select = 4'd15;
            #2000
            enable_r = 1'b0;
            #10
            $stop;
        end


endmodule // end
