`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/07 11:03:20
// Design Name: 
// Module Name: floor
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module floor(
    input wire [31:0] a,
    output wire [31:0] b
    );
    wire s_a = a[31];
    wire [7:0] e_a = a[30:23];
    wire [22:0] m_a = a[22:0];
    wire [23:0] mi_a = {1'b1, m_a};
    wire [7:0] shift = 8'd150 - e_a;
    wire [22:0] filter = 23'h7fffff >> (e_a - 8'd127);
    wire nat = |(m_a & filter) ? 0 : 1;
    wire [23:0] m1 = mi_a >> shift;
    wire [24:0] m1_plus = (s_a && ~nat) ? {1'b0, m1} + 1 : {1'b0, m1};
    wire [24:0] m2 = m1_plus << shift;
    wire carry = m2[24] ? 1 : 0;
    wire [7:0] e_b = 
    ~s_a && e_a < 8'd127 ? 0:
    e_a < 8'd127 ? 8'h7f :
    e_a > 8'd150 ? e_a :
    e_a + carry;
    wire [22:0] m_b = 
    e_a > 8'd150 ? m_a :
    (e_b == 8'b0) || (e_b == 8'h7f) ? 23'b0 :
    m2[22:0];
    assign b =
    a == 32'h80000000 ? a : {s_a, e_b, m_b};
endmodule
`default_nettype wire