`timescale 1ns / 1ps
/*****************************************************************************/
/* Author   : Xilinx                                                         */
/* Date     : ??-??-????                                                     */
/* Function : https://www.xilinx.com/support/documentation/university/       */
/*                Vivado-Teaching/HDL-Design/2013x/Nexys4/Verilog/           */
/*                docs-pdf/lab5.pdf                                          */
/*****************************************************************************/
module SRLatchGate (input R, input S, output Q, output Qbar);
	nor (Q, R, Qbar);
	nor (Qbar, S, Q);
endmodule 