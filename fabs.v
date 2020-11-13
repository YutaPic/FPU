`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/11/13 14:29:27
// Design Name: 
// Module Name: fabs
// Project Name: 
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


module fabs(
    input wire [31:0] a, //input a
    output wire [31:0] b //output |a|
    );
    assign b = {1'b0, a[30:0]};
endmodule
`default_nettype wire