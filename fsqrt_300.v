`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/31 22:01:37
// Design Name: 
// Module Name: fsqrt
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


module fsqrt_300(
    input wire clk,
    input wire [31:0] a,
    output wire [31:0] b
    );
    wire s = a[31];
    reg s1, s2;
    wire [7:0] e = a[30:23];
    wire [9:0] key = a[23:14];
    wire [13:0] ml = a[13:0];
    wire [22:0] c0;
    wire [12:0] g0;
    reg [22:0] c1;
    reg [12:0] g1;
    reg [13:0] ml1, ml2;
    wire odd = (e[0] == 1) ? 1 : 0;
    reg odd1, odd2;
    wire [8:0] bei = e + 8'd127;
    wire [7:0] be = odd ? bei>>1 : (bei - 1)>>1;
    reg [7:0] be1, be2;
    (* ram_style = "block" *) fsqrt_const_table u1 (clk, key, c0);
    (* ram_style = "block" *) fsqrt_grad_table u2 (clk, key, g0);
   
    wire [36:0] gm = g1 * ml2;
    
    initial begin
        ml1 <= 0;
        ml2 <= 0;
        be1 <= 0;
        be2 <= 0;
        odd1 <= 0;
        odd2 <= 0;
        c1 <= 0;
        g1 <= 0;
        s1 <= 0;
        s2 <= 0;
    end
    
    reg [36:0] gm_1;
    reg [7:0] be3;
    reg odd3;
    reg [22:0] c2;
    reg s3;
    
    always @(posedge clk) begin
        ml1 <= ml;
        ml2 <= ml1;
        be1 <= be;
        be2 <= be1;
        be3 <= be2;
        odd1 <= odd;
        odd2 <= odd1;
        odd3 <= odd2;
        c1 <= c0;
        c2 <= c1;
        g1 <= g0;
        s1 <= s;
        s2 <= s1;
        s3 <= s2;
        gm_1 <= gm;
    end
    
    wire [22:0] bm = odd3 ? c2 + (gm_1 >> 14) : c2 + (gm_1 >> 13);
    
    assign b = s3 ? 0 : {1'b0, be3, bm};
endmodule
`default_nettype wire