`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2018 01:35:56
// Design Name: 
// Module Name: TDC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TDC #(parameter WIDTH = 8)(
    input wire reset_i, //unused
    input wire mode_i,
    input wire fpga_clk_i,
    output reg [WIDTH-1:0] error_o
    );

	reg [WIDTH-1:0] cnt_val_r, next_cnt_val_r;

	not1 inverter(mode_i, reset_c[0]);
	not2 inverter(reset_c[0], reset_c[1]); // 2 gives 600 ps, enough?

	always @(mode_i, cnt_val_r) //if no enable then do nothing
	begin
		if(mode_i == 1'b1)
			next_cnt_val_r = cnt_val_r + 1'b1;
		else
			next_cnt_val_r = cnt_val_r;
	end

	always @(posedge fpga_clk_i, negedge reset_c[1]) //synch or asynch reset?
    begin
    	if (reset_c[1] == 1'b0) //eldar specified reset low
    		cnt_val_r <= {(WIDTH){1'b0}};
    	else
    		cnt_val_r <= next_cnt_val_r;
    end

    always @(negedge mode_i)
    begin
    	error_o <= cnt_val_r;
    end



endmodule
