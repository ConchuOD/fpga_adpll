`timescale 1ns / 1ps
module PhaseDetectorTestBench ();
	
	localparam WIDTH = 8;
	localparam EXPECTED_VAL = {{(WIDTH-4){1'b0}}, 4'b1010};
	//localparam EXPECTED_VAL = {{(WIDTH-4){1'b1}}, 4'b0110};
	reg fpga_clk; //400 MHz -> 1.25 ns half period
	reg ref_clk; //5 MHz -> 100 ns half period
	reg gen_clk; //5 MHz -> 100 ns half period
	reg [WIDTH-1:0] pd_clock_cycles;
	reg reset;

	PhaseDetector #(.WIDTH(WIDTH)) testPDet(
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
		#35
		#100 ref_clk = ~ref_clk;	
		#100 ref_clk = ~ref_clk;		
		#100 ref_clk = ~ref_clk;	
		#100 ref_clk = ~ref_clk;	
	end

	initial
	begin
		gen_clk = 1'b0;
		#10
		#100 gen_clk = ~gen_clk;	
		#100 gen_clk = ~gen_clk;
		#150 gen_clk = ~gen_clk;
		#100 gen_clk = ~gen_clk;	
	end

	//do testing
	
	initial
	begin
		reset = 1'b1;
		#5
		reset = 1'b0;
		#235
		assert (pd_clock_cycles == EXPECTED_VAL);
		#2.5
		assert (pd_clock_cycles == EXPECTED_VAL);
		#2.5
		assert (pd_clock_cycles == EXPECTED_VAL);
		#2.5
		$stop;
	end

endmodule