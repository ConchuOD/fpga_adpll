//////////////////////////////////////////////////////////////////////////////////
// Company: UCD School of Electrical and Electronic Engineering
// Engineer: Brian Mulkeen
//
// Module Name: clockReset
// Target Devices: Artix 7 FPGA
// Description: Instantiates MMCM block to divide 100 MHz input clock to get 
//              5 MHz output clock.  Also generates reset signal, active high.
//              Reset is active when clock is not ready, or when reset button is
//              pressed, and remains active for at least one rising edge of clk5.
//////////////////////////////////////////////////////////////////////////////////

module clockReset(
    input clk100,           // 100 MHz input clock
    input rstPBn,           // input from reset pushbutton, active low
    output clk5,            // 5 MHz output clock, buffered
    output reset            // reset output, active high
    );
 
// Clock manager - Internal signals
    wire        clk100buf;
    wire        clk5_0;
    wire        clkfbout;
    wire        locked;
    wire        reset_high;
    wire        clkfboutb_unused;
    wire        clkout0b_unused;
    wire        clkout1_unused;
    wire        clkout1b_unused;
    wire        clkout2_unused;
    wire        clkout2b_unused;
    wire        clkout3_unused;
    wire        clkout3b_unused;
    wire        clkout4_unused;
    wire        clkout5_unused;
    wire        clkout6_unused;

// Instantiate input buffer
    IBUF clkin_ibuf
     (.O (clk100buf),
      .I (clk100));
      
// MMCME2_BASE: Base Mixed Mode Clock Manager,  Artix-7
// Note reset is not used, so clock can stay running during reset.
   MMCME2_BASE #(
      .BANDWIDTH("OPTIMIZED"),   // Jitter programming (OPTIMIZED, HIGH, LOW)
      .CLKOUT4_CASCADE("FALSE"), // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
      .STARTUP_WAIT("FALSE"),     // Delays DONE until MMCM is locked (FALSE, TRUE)
      .DIVCLK_DIVIDE(5),         // Master division value (1-106)
      .CLKFBOUT_MULT_F(32.0),     // Multiply value for all CLKOUT (2.000-64.000).
      .CLKFBOUT_PHASE(0.0),      // Phase offset in degrees of CLKFB (-360.000-360.000).
      .CLKIN1_PERIOD(10.0),       // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
      .REF_JITTER1(0.01),         // Reference input jitter in UI (0.000-0.999).
      .CLKOUT0_DIVIDE_F(128.0),    // Divide amount for CLKOUT0 (1.000-128.000).
      .CLKOUT0_DUTY_CYCLE(0.5),
      .CLKOUT0_PHASE(0.0)
   )
   MMCME2_BASE_inst (
      .CLKFBOUT            (clkfbout),      // feedback output, connects back to input
      .CLKFBOUTB           (clkfboutb_unused),
      .CLKOUT0             (clk5_0),        // 5 MHz output clock, unbuffered
      .CLKOUT0B            (clkout0b_unused),
      .CLKOUT1             (clkout1_unused),
      .CLKOUT1B            (clkout1b_unused),
      .CLKOUT2             (clkout2_unused),
      .CLKOUT2B            (clkout2b_unused),
      .CLKOUT3             (clkout3_unused),
      .CLKOUT3B            (clkout3b_unused),
      .CLKOUT4             (clkout4_unused),
      .CLKOUT5             (clkout5_unused),
      .CLKOUT6             (clkout6_unused),
      .CLKFBIN             (clkfbout),     // feedback input
      .CLKIN1              (clk100buf),     // primary clock input
      .LOCKED              (locked),       // 1-bit output: Locked
      .PWRDWN              (1'b0),       // 1-bit input: Power-down, unused
      .RST                 (1'b0)    // 1-bit input: Reset - not used here
      );
   // End of MMCME2_BASE_inst instantiation

// Instantiate output buffer
    BUFG clkout1_bufg
     (.O   (clk5),
      .I   (clk5_0));
      
// Reset Generator - keeps system in reset until clock manager is locked.
// Want to reset if reset button pressed or clock manager is unlocked
    wire resetIn = ~rstPBn | ~locked; // button signal is active low
    
// A flip-flop ensures reset is held for at least one edge of output clock.
// As output clock may not be available while MMCM is unlocked, this FF
// must use asynchronous reset, so it can change state without the clock.
    reg  resetFFn;    // flip-flop for reset (0 = reset)
    always @ (posedge clk5, posedge resetIn)  // async reset
      if (resetIn) resetFFn <= 1'b0;  // clear on reset
      else resetFFn <= 1'b1;  // otherwise set to 1 on clock edge

    assign reset = ~resetFFn;    // output reset signal active high

endmodule
