module UpDownCounterTestBench ();

	localparam WIDTH = 20;

	reg reset;
	reg clear;
	reg fpga_clk;
	reg [1:0] count_instr;
	wire [WIDTH-1:0] counter_val;
	
	UpDownCounter #(.WIDTH(WIDTH)) upDownCounter (
		.reset_i(reset),
		.clear_i(clear),
		.fpga_clk_i(fpga_clk),
		.count_instr_i(count_instr),
		.counter_val_o(counter_val)
	);

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
		reset = 1'b1;
		clear = 1'b0;
		count_instr = 2'b00;
		#10
		reset = 1'b0;
		#10
		count_instr = 2'b01;
		#1000
		$stop;
	end		

endmodule