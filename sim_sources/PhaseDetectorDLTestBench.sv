`timescale 1ns / 1ps
module PhaseDetectorDLTestBench ();
	
	reg fpga_clk;
	reg ref_clk; //5 MHz -> 100 ns half period
	reg gen_clk; //5 MHz -> 100 ns half period
	reg reset;

	localparam EXPECTED_VAL = 0; //int

	PhaseDetectorDL lmao1pl8(
		.reset_i(reset), 
		.fpga_clk_i(fpga_clk),
		.reference_i(ref_clk),
		.generated_i(gen_clk),
		.pd_clock_cycles_o(pd_clock_cycles)
	);

	//setup clocks

	initial
	begin
		fpga_clk  = 1'b0;
		forever
		begin
			#1.25 fpga_clk = ~fpga_clk;
		end
	end

	initial
	begin
		ref_clk = 1'b0;
		#100 ref_clk = ~ref_clk;	
		#100 ref_clk = ~ref_clk;

		#100 ref_clk = ~ref_clk;	
		#100 ref_clk = ~ref_clk;		
		
		#100 ref_clk = ~ref_clk;	
		#100 ref_clk = ~ref_clk;			
		
		#100 ref_clk = ~ref_clk;	
		#100 ref_clk = ~ref_clk;
	end

	initial
	begin
		gen_clk = 1'b0;				/* Post Synth & Post Impl Timing */
		#104 gen_clk = ~gen_clk;	//(4) -n*1.5 	> 0 -> n = 2 + 1 free 	-----> 1 + 1
		#100 gen_clk = ~gen_clk;	//(4) -n*2 		> 0 -> n = 2 + 1 free 	-----> 1 + 1
		
		#104 gen_clk = ~gen_clk;	//(8) -n*1.5 	> 0 -> n = 5 + 1 free 	-----> 4 + 1
		#100 gen_clk = ~gen_clk;	//(8) -n*2 		> 0 -> n = 4 + 1 free 	-----> 3 + 1
		
		#104 gen_clk = ~gen_clk;	//(12) -n*1.5 	> 0 -> n = 8 + 1 free 	-----> 6 + 1
		#100 gen_clk = ~gen_clk;	//(12) -n*2 	> 0 -> n = 6 + 1 free 	-----> 5 + 1

		#104 gen_clk = ~gen_clk;	//(16) -n*1.5 	> 0 -> n = 10 + 1 free 	-----> 9 + 1
		#100 gen_clk = ~gen_clk;	//(16) -n*2 	> 0 -> n = 8 + 1 free 	-----> 7 + 1
	end

	//do testing
	
	initial
	begin
		reset = 1'b1;
		#5
		reset = 1'b0;
		#2350
		assert (pd_clock_cycles == EXPECTED_VAL);
		#2.5
		assert (pd_clock_cycles == EXPECTED_VAL);
		#2.5
		assert (pd_clock_cycles == EXPECTED_VAL);
		#2.5
		$stop;
	end

endmodule