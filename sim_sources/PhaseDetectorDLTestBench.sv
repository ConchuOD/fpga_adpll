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
		
		#25 ref_clk = ~ref_clk;	
		#100 ref_clk = ~ref_clk;	
	end

	initial
	begin
		gen_clk = 1'b0;
		#103 gen_clk = ~gen_clk;	
		#100 gen_clk = ~gen_clk;
		
		#104 gen_clk = ~gen_clk;
		#100 gen_clk = ~gen_clk;
		
		#111 gen_clk = ~gen_clk;	
		#100 gen_clk = ~gen_clk;	
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