`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/10/30
// Design Name: fdiv
// Module Name: fdiv
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
//100MHz, 4clock
module fdiv (
    input wire clk, 
    input wire [31:0] a, //normal
    input wire [31:0] b, //normal
    output wire [31:0] q, //q = a / b
    output wire ovf //if a value of q is infinity, then ovf = 1
);
    
    wire [31:0] bi;
    reg [31:0] areg [2:0];
    reg [31:0] bireg;

    finv u1(clk, b, bi);
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
