`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/10/19
// Design Name: fmul_for_fdiv
// Module Name: fmul_for_fdiv
// Project Name: C&P
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.02
//////////////////////////////////////////////////////////////////////////////////

module fmul_for_fdiv(
    input wire [31:0] x1,
    input wire [31:0] x2,
    output wire [31:0] y,
    output wire ovf);
    wire s1 = x1[31];
    wire s2 = x2[31];
    wire [8-1:0] e1 = x1[30:23];
    wire [8-1:0] e2 = x2[30:23];
    wire [23-1:0] m1 = x1[22:0];
    wire [23-1:0] m2 = x2[22:0];
    wire sy = s1 ^ s2;
    wire [9:0] eyp = e1 + 9'd126 - e2;
    wire [9:0] eypi = eyp + 1 ;
    wire underflow1 = eyp[9] || ~(|eyp[8:0]) ? 1 : 0;//but eypi needs checking here!!!
    wire underflow2 = eypi[9] || ~(|eypi[8:0]) ? 1 : 0;
    wire ovf_f = (~eyp[9] && eyp[8]) || &(eyp[7:0]) || &(e1) || &(e2) ? 1 : 0;
    wire [47:0] my1 = {1'b1, m1} * {1'b1, m2};
    assign ovf = ovf_f || (my1[47] && &(eypi[7:0]));
    wire [7:0] ey =
                    ovf ? 8'b11111111 : 
                    my1[47] && underflow2 ? 8'b00000000 : 
                    my1[47] ? eypi[7:0] : 
                    underflow1 ? 8'b00000000 :
                    eyp[7:0];
    wire [22:0] my = 
    (ovf) ? 23'b0 : 
    my1[47] && underflow2 ? 23'b0 :
    my1[47] ? my1[46:24] : 
    underflow1 ? 23'b0 : my1[45:23];
    assign y = {sy, ey, my};
endmodule

`default_nettype wire
