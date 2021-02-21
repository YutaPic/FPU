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


module ftoi_200(
    input wire clk,
    input wire [31:0] a,
    output wire [31:0] b
    );
    //wire s = a[31];
    wire [8-1:0] e = a[30:23];
    wire [23-1:0] m = a[22:0];
    wire [23:0] mi = {1'b1, m};
    wire over149 = e > 8'd149;
    wire [7:0] shift = over149 ? e - 8'd150 : 8'd149 - e;
    //wire [31:0] n0 = mi << shift;
    //wire [32:0] n1 = mi >> shift;
    reg [31:0] n0;
    reg [32:0] n1;
    reg s;
    reg over149_1;
    reg under126;
    reg over157;
    
    always @(posedge clk) begin
        n0 <= mi << shift;
        n1 <= mi >> shift;
        s <= a[31];
        over149_1 <= over149;
        under126 <= e < 8'd126;
        over157 <= e > 8'd157;
    end
    
    wire guard = n1[0];
    wire [31:0] n2 = (n1 >> 1) + guard;
    wire [31:0] b_pos = under126 ? 32'b0 : over157 ? 32'h7fffffff : over149_1 ? n0 : n2;
    wire [31:0] b_neg = ~b_pos + 1;
    assign b = s ? b_neg : b_pos;
endmodule
`default_nettype wire