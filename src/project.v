/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_array_mult_structural (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // 4-bit inputs for multiplication
  wire [3:0] m = ui_in[3:0];
  wire [3:0] q = uio_in[3:0];

  // Partial products
  wire pp0_0 = m[0] & q[0];
  wire pp0_1 = m[0] & q[1];
  wire pp0_2 = m[0] & q[2];
  wire pp0_3 = m[0] & q[3];
  
  wire pp1_0 = m[1] & q[0];
  wire pp1_1 = m[1] & q[1];
  wire pp1_2 = m[1] & q[2];
  wire pp1_3 = m[1] & q[3];
  
  wire pp2_0 = m[2] & q[0];
  wire pp2_1 = m[2] & q[1];
  wire pp2_2 = m[2] & q[2];
  wire pp2_3 = m[2] & q[3];
  
  wire pp3_0 = m[3] & q[0];
  wire pp3_1 = m[3] & q[1];
  wire pp3_2 = m[3] & q[2];
  wire pp3_3 = m[3] & q[3];

  // Full adder stages and carry wires
  wire s1_1, c1_1, s1_2, c1_2, s1_3, c1_3;
  wire s2_2, c2_2, s2_3, c2_3;
  wire s3_3, c3_3;
  wire c4_4;

  // Summing up the partial products (in a series of adders)
  assign uo_out[0] = pp0_0;

  assign {c1_1, s1_1} = pp0_1 + pp1_0;
  assign {c1_2, s1_2} = pp0_2 + pp1_1 + pp2_0;
  assign {c1_3, s1_3} = pp0_3 + pp1_2 + pp2_1 + pp3_0;

  assign {c2_2, s2_2} = s1_2 + pp2_1 + pp3_0;
  assign {c2_3, s2_3} = s1_3 + pp2_2 + pp3_1;

  assign {c3_3, s3_3} = s2_3 + pp2_3 + pp3_2;

  assign uo_out[1] = s1_1;
  assign uo_out[2] = s1_2;
  assign uo_out[3] = s1_3;
  assign uo_out[4] = s2_2;
  assign uo_out[5] = s2_3;
  assign uo_out[6] = s3_3;
  assign uo_out[7] = c4_4;

  // Assign other outputs and unused signals
  assign uio_out = 0;
  assign uio_oe = 0;
    wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule
