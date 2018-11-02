`timescale 1ns / 1ps

module StateMachine (
		input reset_i,
		input fpga_clk_i,
		input reference_synced_i,
		input generated_synced_i,
		input counter_cleared_i,
		output reg save_and_clear_o,
		output reg [1:0] count_instr_o
	);

	localparam [3:0] WAITING = 4'b0001, GEN_FIRST = 4'b0010, REF_FIRST = 4'b0100, COPY_CLEAR = 4'b1000;
	localparam [1:0] DISABLE = 2'b00, COUNT_UP = 2'b01, COUNT_DOWN = 2'b10;
	reg [3:0] next_state_r, current_state_r;
	
	always @ (posedge fpga_clk_i)
	begin
		if(reset_i)
			current_state_r <= WAITING;
		else
			current_state_r <= next_state_r;
	end
	
	always @ (current_state_r, reference_synced_i, generated_synced_i)
	begin
		case(current_state_r)
			WAITING:
				if (reference_synced_i && generated_synced_i) next_state_r = COPY_CLEAR; //if both edges occur then COPY_CLEAR
				else if (reference_synced_i) next_state_r = REF_FIRST; //otherwise if ref has an edge the REF_FIRST
				else if (generated_synced_i) next_state_r = GEN_FIRST; //similarly for GEN_FIRST
				else next_state_r = WAITING; //if not those then keep WAITING
			REF_FIRST:
				if (generated_synced_i) next_state_r = COPY_CLEAR; //edge on gen moves to COPY_CLEAR
				else if (!reference_synced_i) COPY_CLEAR; //negedge on ref also does
				else next_state_r = REF_FIRST; //otherwise stay here			
			GEN_FIRST:
				if (generated_synced_i) next_state_r = COPY_CLEAR; //edge on ref moves to COPY_CLEAR
				else if (!reference_synced_i) COPY_CLEAR; //negedge on gen also does
				else next_state_r = REF_FIRST; //otherwise stay here			
			COPY_CLEAR:
				if(counter_cleared_i) next_state_r = WAITING;
				else COPY_CLEAR;
			default: next_state_r = WAITING;
		endcase
	end
	
	always @ (current_state_r)
	begin
		case (current_state_r)
			WAITING:
				count_instr_o = DISABLE;
				save_and_clear_o = 1'b0;
			REF_FIRST:	
				count_instr_o = COUNT_UP;
				save_and_clear_o = 1'b0;
			GEN_FIRST:
				count_instr_o = COUNT_DOWN;
				save_and_clear_o = 1'b0;
			COPY_CLEAR:
				count_instr_o = DISABLE;
				save_and_clear_o = 1'b1;
			default: 
				count_instr_o = DISABLE;
				save_and_clear_o = 1'b0;
		endcase
	end

endmodule // StateMachine