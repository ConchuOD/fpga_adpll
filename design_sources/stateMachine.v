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

	wire ref_pos_edge_x;
	wire ref_neg_edge_x;
	wire gen_pos_edge_x;
	wire gen_neg_edge_x;

	//vivado will merge Pos/Neg edge detectors
	PulseOnPosEdge refPosEdge(
		.fpga_clk_i(fpga_clk_i),
		.trigger_i(reference_synced_i),
		.pulse_o(ref_pos_edge_x)
	);

	PulseOnNegEdge refNegEdge(
		.fpga_clk_i(fpga_clk_i),
		.trigger_i(reference_synced_i),
		.pulse_o(ref_neg_edge_x)
	);

	PulseOnPosEdge genPosPulse(
		.fpga_clk_i(fpga_clk_i),
		.trigger_i(generated_synced_i),
		.pulse_o(gen_pos_edge_x)
	);

	PulseOnNegEdge genNegPulse(
		.fpga_clk_i(fpga_clk_i),
		.trigger_i(generated_synced_i),
		.pulse_o(gen_neg_edge_x)
	);
	
	always @ (posedge fpga_clk_i)
	begin
		if(reset_i)
			current_state_r <= WAITING;
		else
			current_state_r <= next_state_r;
	end
	
	always @ (current_state_r, ref_pos_edge_x, ref_neg_edge_x, gen_pos_edge_x, gen_neg_edge_x, counter_cleared_i)
	begin
		case(current_state_r)
			WAITING:
				if (ref_pos_edge_x && gen_pos_edge_x) next_state_r = COPY_CLEAR; //if both edges occur then COPY_CLEAR
				else if (ref_pos_edge_x) next_state_r = REF_FIRST; //otherwise if ref has an edge the REF_FIRST
				else if (gen_pos_edge_x) next_state_r = GEN_FIRST; //similarly for GEN_FIRST
				else next_state_r = WAITING; //if not those then keep WAITING
			REF_FIRST:
				if (gen_pos_edge_x) next_state_r = COPY_CLEAR; //edge on gen moves to COPY_CLEAR
				else if (ref_neg_edge_x) next_state_r = COPY_CLEAR; //negedge on ref also does
				else next_state_r = REF_FIRST; //otherwise stay here			
			GEN_FIRST:
				if (ref_pos_edge_x) next_state_r = COPY_CLEAR; //edge on ref moves to COPY_CLEAR
				else if (gen_neg_edge_x) next_state_r = COPY_CLEAR; //negedge on gen also does
				else next_state_r = GEN_FIRST; //otherwise stay here			
			COPY_CLEAR:
				if(counter_cleared_i) next_state_r = WAITING;
				else next_state_r = COPY_CLEAR;
			default: next_state_r = WAITING;
		endcase
	end
	
	always @ (current_state_r)
	begin
		case (current_state_r)
			WAITING:
				begin
					count_instr_o = DISABLE;
					save_and_clear_o = 1'b0;
				end
			REF_FIRST:	
				begin
					count_instr_o = COUNT_UP;
					save_and_clear_o = 1'b0;
				end
			GEN_FIRST:
				begin
					count_instr_o = COUNT_DOWN;
					save_and_clear_o = 1'b0;
				end
			COPY_CLEAR:
				begin
					count_instr_o = DISABLE;
					save_and_clear_o = 1'b1;
				end
			default: 
				begin
					count_instr_o = DISABLE;
					save_and_clear_o = 1'b0;
				end
		endcase
	end

endmodule // StateMachine