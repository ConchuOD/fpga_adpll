`timescale 1ns / 1ps

module Div8 (
        input wire signal_i,
        input wire reset_i,
        output wire div1_o, //loopback
        output wire div2_o,
        output wire div4_o,
        output wire div8_o
    );
 
 	wire d0_c, d1_c, d2_c;
 	reg q0_r, q1_r, q2_r;

 	assign d0_c = ~q0_r;
 	assign d1_c = ~q1_r;
 	assign d2_c = ~q2_r;

 	assign div1_o = signal_i;
 	assign div2_o = q0_r;
 	assign div4_o = q1_r;
 	assign div8_o = q2_r;

 	always @ (posedge signal_i or posedge reset_i)
 	begin
 		if(reset_i) q0_r = 0;
 		else q0_r = d0_c;
 	end

	always @ (posedge q0_r or posedge reset_i)
 	begin
 		if(reset_i) q1_r = 0;
 		else q1_r = d1_c;
 	end

 	always @ (posedge q1_r or posedge reset_i)
 	begin
 		if(reset_i) q2_r = 0;
 		else q2_r = d2_c;
 	end

 endmodule // Div8