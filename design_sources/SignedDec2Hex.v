`timescale 1ns / 1ps

module SignedDec2Hex#(parameter WIDTH = 8) (
		input wire signed [WIDTH-1:0] signed_dec_i,
		output reg [WIDTH-1:0] hex_o 
	);
	
	reg [WIDTH-1:0] dec_c;

	always @ (signed_dec_i)
	begin
		if(signed_dec_i[WIDTH-1]) hex_o = (~signed_dec_i)+1'b1;
		else hex_o = signed_dec_i;
	end

endmodule // SignedDec2Hex	