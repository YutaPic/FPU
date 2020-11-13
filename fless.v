`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/11/06 13:19:50
// Design Name: fless
// Module Name: fless
// Project Name: C&P
// Target Devices: KCU105
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


module fless(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire c
    );
    wire s_a = a[31];
    wire s_b = b[31];
    wire [7:0] e_a = a[30:23];
    wire [7:0] e_b = b[30:23];
    wire [22:0] m_a = a[22:0];
    wire [22:0] m_b = b[22:0];
    
    wire [1:0] sel_s = 
    (~s_a & s_b) ? 0 : 
    (s_a & ~s_b) ? 1 :
    (s_a & s_b) ? 2: 3;
    
    assign c = 
    (sel_s == 1) ? 1 : 
    (sel_s == 2 && e_a > e_b) ? 1 :
    (sel_s == 3 && e_a < e_b) ? 1 :
    (sel_s == 2 && e_a == e_b && m_a > m_b) ? 1 :
    (sel_s == 3 && e_a == e_b && m_a < m_b) ? 1 : 0;
endmodule
`default_nettype wire