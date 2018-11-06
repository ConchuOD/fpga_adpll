`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UCD School of Electrical and Electronic Engineering
// Engineer: Brian Mulkeen
//
// Module Name: clockreset_o
// Target Devices: Artix 7 FPGA
// Description: Instantiates MMCM block to divide 100 MHz input clock to get 
//              5 MHz output clock.  Also generates reset_o signal, active high.
//              reset_o is active when clock is not ready, or when reset_o button is
//              pressed, and remains active for at least one rising edge of clk5_o.
//////////////////////////////////////////////////////////////////////////////////

module ClockReset5_400_PDiff(
      input clk100_i,             // 100 MHz input clock
      input rst_pbn_i,            // input from reset_o pushbutton, active low
      output clk5_o,              // 5 MHz output clock, buffered
      output clk5_45_o,
      output clk5_90_o,
      output clk5_135_o,
      output reset_o,             // reset_o output, active high
      output clk400_o       // 100 MHz output clock, buffered
    );
 
// Clock manager - Internal signals
    wire        clk100_inbuf_x;
    wire        clk5_MMCM0_x;
    wire        clk_fb_x;
    wire        locked_x;
    wire        reset_o_high;
    wire        clk400_MMCM1_x;
    wire        clk5_45_MMCM2_x;
    wire        clk5_90_MMCM3_x;
    wire        clk5_135_MMCM4_x;

    wire        clkfboutb_unused;
    wire        clkout0b_unused;    
    wire        clkout1b_unused;
    wire        clkout2b_unused;
    wire        clkout3b_unused;
    wire        clkout5_unused;
    wire        clkout6_unused;

// Instantiate input buffer
    IBUF clkin_ibuf(
      .O (clk100_inbuf_x),
      .I (clk100_i)
    );
      
// MMCME2_BASE: Base Mixed Mode Clock Manager,  Artix-7
// Note reset_o is not used, so clock can stay running during reset_o.
    MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),    // Jitter programming (OPTIMIZED, HIGH, LOW)
      .CLKOUT4_CASCADE("FALSE"),  // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      .STARTUP_WAIT("FALSE"),     // Delays DONE until MMCM is locked (FALSE, TRUE)
      .DIVCLK_DIVIDE(8),          // Master division value (1-106)
      .CLKFBOUT_MULT_F(32.0),     // Multiply value for all CLKOUT (2.000-64.000).
      .CLKFBOUT_PHASE(0.0),       // Phase offset in degrees of CLKFB (-360.000-360.000).
      .CLKIN1_PERIOD(10.0),       // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      .REF_JITTER1(0.01),         // Reference input jitter in UI (0.000-0.999).
      .CLKOUT0_DIVIDE_F(80.0),   // Divide amount for CLKOUT0 (1.000-128.000).
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT0_PHASE(0.0),

      .CLKOUT1_DIVIDE(1),         // Divide amount for CLKOUT1 (1-128).
      .CLKOUT1_DUTY_CYCLE(0.5),
      .CLKOUT1_PHASE(0.0),

      .CLKOUT2_DIVIDE(80),   // Divide amount for CLKOUT0 (1.000-128.000).
      .CLKOUT2_DUTY_CYCLE(0.5),
      .CLKOUT2_PHASE(45.0),

      .CLKOUT3_DIVIDE(80),   // Divide amount for CLKOUT0 (1.000-128.000).
      .CLKOUT3_DUTY_CYCLE(0.5),
      .CLKOUT3_PHASE(90.0),

      .CLKOUT4_DIVIDE(80),   // Divide amount for CLKOUT0 (1.000-128.000).
      .CLKOUT4_DUTY_CYCLE(0.5),
      .CLKOUT4_PHASE(35.0)
   )
    MMCME2_BASE_inst (
       .CLKFBOUT            (clk_fb_x),      // feedback output, connects back to input
       .CLKFBOUTB           (clk5_buffout_xb_unused),
       .CLKOUT0             (clk5_MMCM0_x),        // 5 MHz output clock, unbuffered
       .CLKOUT0B            (clkout0b_unused),
       .CLKOUT1             (clk400_MMCM1_x),
       .CLKOUT1B            (clkout1b_unused),
       .CLKOUT2             (clk5_45_MMCM2_x),
       .CLKOUT2B            (clkout2b_unused),
       .CLKOUT3             (clk5_90_MMCM3_x),
       .CLKOUT3B            (clkout3b_unused),
       .CLKOUT4             (clk5_135_MMCM4_x),
       .CLKOUT5             (clkout5_unused),
       .CLKOUT6             (clkout6_unused),
       .CLKFBIN             (clk_fb_x),     // feedback input
       .CLKIN1              (clk100_inbuf_x),     // primary clock input
       .LOCKED              (locked_x),       // 1-bit output: locked_x
       .PWRDWN              (1'b0),       // 1-bit input: Power-down, unused
       .RST                 (1'b0)    // 1-bit input: reset_o - not used here
    );
   // End of MMCME2_BASE_inst instantiation

// Instantiate output buffer
    BUFG clkout0_bufg (
      .O   (clk5_o),
      .I   (clk5_MMCM0_x)
    );
    BUFG clkout1_bufg (
      .O   (clk400_o),
      .I   (clk400_MMCM1_x)
    );

    BUFG clkout2_bufg (
      .O   (clk5_45_o),
      .I   (clk5_45_MMCM2_x)
    );

    BUFG clkout3_bufg (
      .O   (clk5_90_o),
      .I   (clk5_90_MMCM3_x)
    );

    BUFG clkout4_bufg (
      .O   (clk5_135_o),
      .I   (clk5_135_MMCM4_x)
    );
      
// reset_o Generator - keeps system in reset_o until clock manager is locked_x.
// Want to reset_o if reset_o button pressed or clock manager is unlocked_x
    wire reset_in = ~rst_pbn_i | ~locked_x; // button signal is active low
    
// A flip-flop ensures reset_o is held for at least one edge of output clock.
// As output clock may not be available while MMCM is unlocked_x, this FF
// must use asynchronous reset_o, so it can change state without the clock.
    reg  reset_r;    // flip-flop for reset_o (0 = reset_o)
    always @ (posedge clk5_o, posedge reset_in)  // async reset_o
      if (reset_in) reset_r <= 1'b0;  // clear on reset_o
      else reset_r <= 1'b1;  // otherwise set to 1 on clock edge

    assign reset_o = ~reset_r;    // output reset_o signal active high

endmodule
