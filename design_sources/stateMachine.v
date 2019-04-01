`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Conor Dooley                                                   */
/* Date     : ??-November-2019                                               */
/* Function : State machine to compute the sign of the phase error, and to   */
/*            control measurement of the size of this difference.            */
/*			                                */
/*****************************************************************************/
module StateMachine (
		input reset_i,
		input fpga_clk_i,
		input reference_synced_i,
		input generated_synced_i,
		input counter_cleared_i,
		output reg save_and_clear_o,
		output reg [1:0] count_instr_o
	);
    
    /*************************************************************************/
    /* Define constants and nets                                             */
    /*************************************************************************/

    //one hot state represenation
	localparam [3:0] WAITING = 4'b0001, GEN_FIRST = 4'b0010, REF_FIRST = 4'b0100, COPY_CLEAR = 4'b1000;
	
	//signal to control direction of the 2's complement counter
	localparam [1:0] DISABLE = 2'b00, COUNT_UP = 2'b01, COUNT_DOWN = 2'b10;

	reg [3:0] next_state_r, current_state_r;

	wire ref_pos_edge_x;
	wire ref_neg_edge_x;

	wire gen_pos_edge_x;
	wire gen_neg_edge_x;
    
    /*************************************************************************/
    /* Edge detection circuitry                                              */
    /*************************************************************************/
 
	PulseOnPosEdge refPosEdge(
		.fpga_clk_i(fpga_clk_i),
		.trigger_i(reference_synced_i),
		.pulse_o(ref_pos_edge_x)
	);

	PulseOnPosEdge genPosPulse(
		.fpga_clk_i(fpga_clk_i),
		.trigger_i(generated_synced_i),
		.pulse_o(gen_pos_edge_x)
	);
    
    /*************************************************************************/
    /* State transition logic                                                */
    /*************************************************************************/
	
	always @ (posedge fpga_clk_i)
	begin
		if(reset_i)
			current_state_r <= WAITING;
		else
			current_state_r <= next_state_r;
	end
	
	always @ (current_state_r, ref_pos_edge_x, gen_pos_edge_x, counter_cleared_i)
	begin
		case(current_state_r)
			WAITING:
				//if both edges occur then COPY_CLEAR
				if (ref_pos_edge_x && gen_pos_edge_x) next_state_r = COPY_CLEAR;

				//otherwise if ref has an edge the REF_FIRST
				else if (ref_pos_edge_x) next_state_r = REF_FIRST; 
				
				//similarly for GEN_FIRST
				else if (gen_pos_edge_x) next_state_r = GEN_FIRST; 
				
				//if not those then keep WAITING
				else next_state_r = WAITING; 
			REF_FIRST:
				//edge on gen moves to COPY_CLEAR
				if (gen_pos_edge_x) next_state_r = COPY_CLEAR;

				//otherwise stay here 
				else next_state_r = REF_FIRST;
			GEN_FIRST:
				//edge on ref moves to COPY_CLEAR
				if (ref_pos_edge_x) next_state_r = COPY_CLEAR;

				//otherwise stay here 
				else next_state_r = GEN_FIRST;
			COPY_CLEAR:
				//if cleared move to wait state
				if(counter_cleared_i) next_state_r = WAITING;

				//otherwise stay here
				else next_state_r = COPY_CLEAR;

			default: next_state_r = WAITING;
		endcase
	end
    
    /*************************************************************************/
    /* State based output logic                                              */
    /*************************************************************************/
	
	always @ (current_state_r)
	begin
		case (current_state_r)
			WAITING: //do nothing
				begin
					count_instr_o = DISABLE;
					save_and_clear_o = 1'b0;
				end
			REF_FIRST: //ref leading is positively signed
				begin
					count_instr_o = COUNT_UP;
					save_and_clear_o = 1'b0;
				end
			GEN_FIRST: //gen leading is negatively signed
				begin
					count_instr_o = COUNT_DOWN;
					save_and_clear_o = 1'b0;
				end
			COPY_CLEAR: //disable the counter and save the value
				begin
					count_instr_o = DISABLE;
					save_and_clear_o = 1'b1;
				end
			default: //do nothing
				begin
					count_instr_o = DISABLE;
					save_and_clear_o = 1'b0;
				end
		endcase
	end

endmodule // StateMachine