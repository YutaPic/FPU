`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/10/31 22:01:37
// Design Name: 
// Module Name: fsqrt
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


module fsqrt(
    input wire clk,
    input wire [31:0] a,
    output wire [31:0] b
    );
    wire s = a[31];
    wire [7:0] e = a[30:23];
    wire [9:0] key = a[23:14];
    wire [13:0] ml = a[13:0];
    wire [22:0] c1;
    wire [12:0] g1;
    reg [13:0] ml1;
    wire odd = (e[0] == 1) ? 1 : 0;
    reg odd1;
    wire [8:0] bei = e + 8'd127;
    wire [7:0] be = odd ? bei>>1 : (bei - 1)>>1;
    reg [7:0] be1;
    (* ram_style = "block" *) fsqrt_const_table u1 (clk, key, c1);
    (* ram_style = "block" *) fsqrt_grad_table u2 (clk, key, g1);
    
    wire [36:0] gm = g1 * ml1;
    wire [22:0] bm = odd1 ? c1 + (gm >> 14) : c1 + (gm >> 13);
    initial begin
        ml1 <= 0;
        be1 <= 0;
        odd1 <= 0;
    end
    
    always @(posedge clk) begin
        ml1 <= ml;
        be1 <= be;
        odd1 <= odd;
    end
    
    assign b = (s == 1) ? 0 : {1'b0, be1, bm};
endmodule
`default_nettype wire
