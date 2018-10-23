module DisplayInterface (
    input [15:0] value,
    input clock, reset,
    input [3:0] point,
    output reg [7:0] segment, 
    output reg [7:0] digit
    );

reg [1:0] countOutput;
wire [1:0] nextCount;
reg [3:0] rawSeg;
wire [6:0] segSeven;
wire [10:0] enableCountNext;
reg [10:0] enableCount;
wire enableReg;
reg radixOut;
wire [3:0] point;
//slows down clock 2048 times to get readable digit cycling, by using an 11 bit counter & an enable input on the 2 bit count register
always @ (posedge clock or posedge reset)
begin
    if(reset) enableCount <= 11'b0;
    else enableCount <= enableCountNext;
end
assign enableCountNext = enableCount + 1'b1;
//enable digit count register every 2048 cycles
assign enableReg = (enableCount == 11'd0)? 1'b1 : 1'b0;
//2 bit counter selects which 4 bits to send to hex2seg, which point bit to use, and which digit to light up
always @ (posedge clock or posedge reset)
begin
    if(reset) countOutput <= 2'd0;
    else if (enableReg)countOutput <= nextCount;
    else countOutput <= countOutput; 
end
assign nextCount = countOutput + 1'b1;
//selecting digit changes 2 bit count into 1 cold for display selection
always @ (countOutput)
begin
    case(countOutput)
        2'b00: digit = 8'b11111110;
        2'b01: digit = 8'b11111101;
        2'b10: digit = 8'b11111011;
        2'b11: digit = 8'b11110111;
    endcase
end
//chooses which 4 bits to send to hex2seg based on 2 bit counter
always @ (countOutput, value)
begin
    case(countOutput)
        2'b00: rawSeg = value[3:0];
        2'b01: rawSeg = value[7:4];
        2'b10: rawSeg = value[11:8];
        2'b11: rawSeg = value[15:12];
    endcase
end
//converts 4 bit input hex into 7 bit segment information
hex2seg hexSeg(
    .number(rawSeg), 
    .pattern(segSeven)
    );
//selecting radix - pipes 1 bit onwards to be joined with 7bit segment info depending on digit counter
always @ (countOutput, point)
begin
    case(countOutput)
        2'b00: radixOut = point[0:0];
        2'b01: radixOut = point[1:1]; 
        2'b10: radixOut = point[2:2];
        2'b11: radixOut = point[3:3];
        default: radixOut = point[0:0];
    endcase
end
//7 bit pattern + 1 bit radix point to 8 bit segment output
always @ (*)
begin
    segment = { segSeven[6:0], radixOut };
end
endmodule