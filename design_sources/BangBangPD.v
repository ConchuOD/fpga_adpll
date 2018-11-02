`timescale 1ns / 1ps

//1 bit only, will lower the frequency when gen occurs first
//and will increase the frequency if reference does.
//this requires the 

module BangBangPD( //1 bit only, 
		input enable_i,
	    input ref_i,
	    input gen_i,
	    input reset_i,
	    output reg pd_out_o
    );

	always @ (posedge gen_i)
	begin
		if (reset_i == 1'b1 || enable_i == 1'b0)
			pd_out_o <= 1'b0;
		else
			pd_out_o <= ref_i;
	end
	
endmodule
