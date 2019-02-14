`timescale 1ns / 0.01ps

module TwoByTwoTestBench ();

    localparam BIAS = 12'd154;
	localparam REF_HALF_PERIOD = 400;

	reg rst_pbn;

    reg clk100_x;	
    reg clk258_x;
    reg ref_div8_x;

    wire ra_x;
    wire reset_x;

    reg [15:0] switches_x;
    wire [6:0] outputs_x;

    assign reset_x = ~rst_pbn;

    initial
	begin
		clk100_x  = 1'b0;
		forever
		begin
			#10 clk100_x = ~clk100_x;
		end
	end
    initial
    begin
        clk258_x  = 1'b0;
        forever
        begin
            #1.9375 clk258_x = ~clk258_x;
        end
    end
	initial
	begin
		ref_div8_x  = 1'b0;
		forever
		begin
			#REF_HALF_PERIOD ref_div8_x = ~ref_div8_x; //10 MHz
		end
	end

    TwoByTwoRingTest ringTestTwoByTwo(
        .clk100_i(clk100_x),        // 100 MHz clock from oscillator on board
        .rst_pbn_i(rst_pbn),        // reset signal, active low, from CPU RESET pushbutton //
        .switches_i(switches_x),
        .ra_o(outputs_x),
        .ra_i(ref_div8_x), // external reference
        .temp(clk258_x),
        .temp_rst(~rst_pbn)   
    );

	initial
	begin
		rst_pbn = 1'b0;
        switches_x = 16'h8B01;
		#100
		rst_pbn = 1'b1;
        #10
        switches_x[15:12] = 4'b1111;
        #10
        switches_x[11:0] = 12'd80;
		#1000000
        $stop;
        //$finish;
	end

endmodule // PhDetTopTestBench	
