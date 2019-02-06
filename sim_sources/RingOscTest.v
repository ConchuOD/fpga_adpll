`timescale 1ns / 1ps
module RingOscTest();//rename file
	wire clkmine;
    reg enable_r;
    reg [4:0] f_select;
    
    RingOsc #(.RINGSIZE(421), .CTRL_WIDTH(5)) testRing( //
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
            f_select = 5'b00001;
            #2000
            f_select = 5'b00010;
            #2000
            f_select = 5'd6;
            #2000
            f_select = 5'd15;
            #2000
            enable_r = 1'b0;
            #10
            $stop;
        end


endmodule // end
