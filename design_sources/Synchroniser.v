module Synchroniser (
		input wire clk_i,
		input wire async_i,
		output wire sync_o
	);

	reg [1:0] delayed;

	always @ (posedge clk_i)
	begin
		delayed[0] <= async_i;
		delayed[1] <= delayed[0];
	end

	assign sync_o = delayed[1];

endmodule