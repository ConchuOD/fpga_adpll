module PhaseAccum #(parameter WIDTH = 4)(
	input wire enable_i,
    input wire [WIDTH-1:0] k_val_i,
    input wire fpga_clk_i,
    input wire reset_i,
    output wire clk_o
    );

	reg [WIDTH-1:0] cnt_val_r, next_cnt_val_r;

	always @(enable_i, k_val_i, cnt_val_r) //if no enable then do nothing
	begin
		if(enable_i == 1'b1)
			next_cnt_val_r = k_val_i + cnt_val_r;
		else
			next_cnt_val_r = cnt_val_r;
	end


    always @(posedge fpga_clk_i) //synch or asynch reset?
    begin
    	if (reset_i)
    		cnt_val_r <= {(WIDTH){1'b0}};
    	else
    		cnt_val_r <= next_cnt_val_r;
    end

    assign clk_o = cnt_val_r[WIDTH-1];
                    
endmodule


//counter adds f_sel_i to cnt_val_r if enable is set
//D flipflop stores cnt_val_r
                    