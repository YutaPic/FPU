`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/11/03 13:21:33
// Design Name: ftoi
// Module Name: ftoi
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


module ftoi(
    input wire [31:0] a,
    output wire [31:0] b
    );
    wire s = a[31];
    wire [8-1:0] e = a[30:23];
    wire [23-1:0] m = a[22:0];
    wire [23:0] mi = {1'b1, m};
    wire [7:0] shift = e > 8'd149 ? e - 8'd150 : 8'd149 - e;
    wire [31:0] n0 = mi << shift;
    wire [32:0] n1 = mi >> shift;
    wire guard = n1[0];
    wire [31:0] n2 = (n1 >> 1) + guard;
    wire [31:0] b_pos = e < 8'd126 ? 32'b0 : e > 8'd157 ? 32'h7fffffff : e > 8'd149 ? n0 : n2;
    wire [31:0] b_neg = ~b_pos + 1;
    assign b = s ? b_neg : b_pos;
endmodule
`default_nettype wire