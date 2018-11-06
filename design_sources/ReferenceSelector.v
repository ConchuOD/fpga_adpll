module ReferenceSelector (
		input wire clk_0_i,
        input wire clk_45_i,
        input wire clk_90_i,
        input wire clk_135_i,
        input [1:0] ps_select_i,
        output reg clk_o
	);

	always @ (ps_select_i)
	begin
		case (ps_select_i)
			2'b00:
				clk_o = clk_0_i;
			2'b01:
				clk_o = clk_45_i;
			2'b10:
				clk_o = clk_90_i;
			2'b11:
				clk_o = clk_135_i;
			default:
				clk_o = clk_0_i;
		endcase // ps_select_i
	end
endmodule // ReferenceSelector