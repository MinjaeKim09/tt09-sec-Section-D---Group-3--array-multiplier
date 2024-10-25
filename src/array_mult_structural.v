`timescale 1ns / 1ps

module array_mult_structural(
    input [3:0] m,    // 4-bit input m
    input [3:0] q,    // 4-bit input q
    output [7:0] p    // 8-bit product output
);

// Wires for partial products
wire pp0_0, pp0_1, pp0_2, pp0_3;
wire pp1_0, pp1_1, pp1_2, pp1_3;
wire pp2_0, pp2_1, pp2_2, pp2_3;
wire pp3_0, pp3_1, pp3_2, pp3_3;

// Wires for full adder results and carries
wire s1_1, c1_1, s1_2, c1_2, s1_3, c1_3;
wire s2_2, c2_2, s2_3, c2_3;
wire s3_3, c3_3;
wire c4_4;

// Generate partial products using AND gates
assign pp0_0 = m[0] & q[0];
assign pp0_1 = m[0] & q[1];
assign pp0_2 = m[0] & q[2];
assign pp0_3 = m[0] & q[3];

assign pp1_0 = m[1] & q[0];
assign pp1_1 = m[1] & q[1];
assign pp1_2 = m[1] & q[2];
assign pp1_3 = m[1] & q[3];

assign pp2_0 = m[2] & q[0];
assign pp2_1 = m[2] & q[1];
assign pp2_2 = m[2] & q[2];
assign pp2_3 = m[2] & q[3];

assign pp3_0 = m[3] & q[0];
assign pp3_1 = m[3] & q[1];
assign pp3_2 = m[3] & q[2];
assign pp3_3 = m[3] & q[3];

// Add partial products using full adders
// First row
assign p[0] = pp0_0;  // LSB

full_adder fa1_1(pp0_1, pp1_0, 1'b0, s1_1, c1_1);
full_adder fa1_2(pp0_2, pp1_1, c1_1, s1_2, c1_2);
full_adder fa1_3(pp0_3, pp1_2, c1_2, s1_3, c1_3);

// Second row
full_adder fa2_2(s1_2, pp2_0, c1_3, s2_2, c2_2);
full_adder fa2_3(s1_3, pp2_1, c2_2, s2_3, c2_3);

// Third row
full_adder fa3_3(s2_3, pp3_0, c2_3, s3_3, c3_3);

// Output product bits
assign p[1] = s1_1;
assign p[2] = s2_2;
assign p[3] = s3_3;
assign p[4] = pp2_2 ^ pp3_1 ^ c3_3;
assign p[5] = pp3_2 ^ pp2_3;
assign p[6] = pp3_3;
assign p[7] = 1'b0;   // MSB

endmodule

// Full Adder Module
module full_adder(
    input a,    // First input bit
    input b,    // Second input bit
    input cin,  // Carry input
    output sum, // Sum output
    output cout // Carry output
);
assign {cout, sum} = a + b + cin;
endmodule

