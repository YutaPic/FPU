`timescale 1ns / 100ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/11/03 01:15:59
// Design Name: 
// Module Name: itof, leadingZeroCounter_for_itof
// Project Name: C&P
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
module leadingZeroCounter_for_itof(
    input wire [30:0] x,
    output wire [4:0] y
    );
    assign y = 
    x[30] ? 0 :
    x[29] ? 1 :
    x[28] ? 2 :
    x[27] ? 3 :
    x[26] ? 4 :
    x[25] ? 5 :
    x[24] ? 6 :
    x[23] ? 7 :
    x[22] ? 8 :
    x[21] ? 9 :
    x[20] ? 10 :
    x[19] ? 11 :
    x[18] ? 12 :
    x[17] ? 13 :
    x[16] ? 14 :
    x[15] ? 15 :
    x[14] ? 16 :
    x[13] ? 17 :
    x[12] ? 18 :
    x[11] ? 19 :
    x[10] ? 20 :
    x[9] ? 21 :
    x[8] ? 22 :
    x[7] ? 23 :
    x[6] ? 24 :
    x[5] ? 25 :
    x[4] ? 26 :
    x[3] ? 27 :
    x[2] ? 28 :
    x[1] ? 29 :
    x[0] ? 30 : 31;
endmodule

module itof(
    input wire [31:0] a,
    output wire [31:0] b
    );
    wire [4:0] k;
    wire s = a[31];
    wire [31:0] a_p = s ? ~a + 1 : a;
    wire [30:0] y = a_p[30:0]; 
    leadingZeroCounter_for_itof u1(y, k);
    wire [4:0] shift = k > 6 ? k - 7 : 6 - k; 
    wire [35:0] m0s = y << shift;
    wire [22:0] m0 = m0s[22:0];
    wire [7:0] e0 = 8'd157 - {3'b0, k};
    wire [30:0] m1s = y >> shift;
    wire [23:0] m1 = m1s[23:0];
    wire guard = m1[0];
    wire [23:0] m2 = (m1 >> 1) + guard;
    wire [7:0] e = k > 6 ? e0 : m2[23] ? e0 + 1 : e0;
    wire [22:0] m = k > 6 ? m0 : m2[22:0];
    assign b = (a == 32'b0) ? 32'b0 : (a == 32'h80000000) ? 32'hcf000000 : {s, e, m};
endmodule
`default_nettype wire
