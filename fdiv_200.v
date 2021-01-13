`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/10/19
// Design Name: fmul 
// Module Name: fmul
// Project Name: C&P
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module fdiv_200 (
    input wire clk, 
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] q,
    output wire ovf);
    
    wire [31:0] bi;
    reg [31:0] areg [2:0];
    reg [31:0] bireg;

    finv_200 u1(clk, b, bi);
    fmul_for_fdiv u2(areg[2], bireg, q, ovf);
    
    initial begin
        areg[0] <= 0;
        areg[1] <= 0;
        areg[2] <= 0;
        bireg <= 0;
    end
    
    always @(posedge clk) begin
        areg[0] <= a;
        areg[1] <= areg[0];
        areg[2] <= areg[1];
        bireg <= bi;
    end
endmodule

`default_nettype wire