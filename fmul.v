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
//正規化数のみ対応
//e = 0ならばその数を0(m = 0で固定)とみなす(入力、出力ともに)
//e = 255ならばその数を∞(m = 0で固定)とみなす(入力、出力ともに)
//組み合わせ回路   (dsp block 2個合成に使用)
//最大動作周波数 = 110MHz程度
//moduleの大半は無駄(?)
/*
module multi4(
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [7:0] p
    );
    wire t0 = a[0] & b[0];
    wire [1:0] t1 = (a[1] & b[0]) + (a[0] & b[1]);
    wire [1:0] t2 = (a[2] & b[0]) + (a[1] & b[1]) + (a[0] & b[2]);
    wire [2:0] t3 = (a[3] & b[0]) + (a[2] & b[1]) + (a[1] & b[2]) + (a[0] & b[3]);
    wire [1:0] t4 = (a[3] & b[1]) + (a[2] & b[2]) + (a[1] & b[3]);
    wire [1:0] t5 = (a[3] & b[2]) + (a[2] & b[3]);
    wire t6 = a[3] & b[3];
    
    wire [7:0] s1 = {1'b0, t6, t5[0], t4[0], t3[0], t2[0], t1[0], t0};
    wire [7:0] s2 = {1'b0, t5[1], t4[1], t3[1], t2[1], t1[1], 2'b0};
    wire [7:0] s3 = {2'b0, t3[2], 5'b0};
    
    assign p = s1 + s2 + s3;
endmodule

module multi8(
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [15:0] p
    );
    wire [3:0] ah = a[7:4];
    wire [3:0] bh = b[7:4];
    wire [3:0] al = a[3:0];
    wire [3:0] bl = b[3:0];
    wire [7:0] albl, ahbh, ab;
    multi4 u1(al, bl, albl);
    multi4 u2(ah, bh, ahbh);
    wire [4:0] as = {1'b0, ah} - {1'b0, al};
    wire [4:0] bs = {1'b0, bh} - {1'b0, bl};
    wire [3:0] asa = as[4] ? ~as[3:0] + 1 : as[3:0];
    wire [3:0] bsa = bs[4] ? ~bs[3:0] + 1 : bs[3:0];
    wire abs = as[4] ^ bs[4];
    multi4 u3(asa, bsa, ab);
    wire [8:0] sub = abs ? ahbh + albl + ab : ahbh + albl - ab;
    assign p = {ahbh, albl} + {3'b0, sub, 4'b0};
endmodule

module multi16(
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [31:0] p
    );
    wire [7:0] ah = a[15:8];
    wire [7:0] bh = b[15:8];
    wire [7:0] al = a[7:0];
    wire [7:0] bl = b[7:0];
    wire [15:0] albl;
    wire [15:0] ahbh;
    multi8 u1(al, bl, albl);
    multi8 u2(ah, bh, ahbh);
    wire [8:0] as = {1'b0, ah} - {1'b0, al};
    wire [8:0] bs = {1'b0, bh} - {1'b0, bl};
    wire [7:0] asa = as[8] ? ~as[7:0] + 1 : as[7:0];
    wire [7:0] bsa = bs[8] ? ~bs[7:0] + 1 : bs[7:0];
    wire abs = as[8] ^ bs[8];
    wire [15:0] ab;
    multi8 u3(asa, bsa, ab);
    wire [16:0] sub = abs ? ahbh + albl + ab : ahbh + albl - ab;
    assign p = {ahbh, albl} + {7'b0, sub, 8'b0};
endmodule

module multi32(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [63:0] p
    );
    wire [15:0] ah = a[31:16];
    wire [15:0] bh = b[31:16];
    wire [15:0] al = a[15:0];
    wire [15:0] bl = b[15:0];
    wire [31:0] albl;
    wire [31:0] ahbh;
    wire [31:0] ahbl, albh;
    multi16 u1(al, bl, albl);
    multi16 u2(ah, bh, ahbh);
    wire [16:0] as = {1'b0, ah} - {1'b0, al};
    wire [16:0] bs = {1'b0, bh} - {1'b0, bl};
    wire [15:0] asa = as[16] ? ~as[15:0] + 1 : as[15:0];
    wire [15:0] bsa = bs[16] ? ~bs[15:0] + 1 : bs[15:0];
    wire abs = as[16] ^ bs[16];
    wire [31:0] ab;
    multi16 u3(asa, bsa, ab);
    wire [32:0] sub = abs ? ahbh + albl + ab : ahbh + albl - ab;
    assign p = {ahbh, albl} + {15'b0, sub, 16'b0};
endmodule
*/
module fmul(
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
    wire [9:0] eyp = e1 + e2 - 9'd127;
    wire [9:0] eypi = eyp + 1 ;
    wire underflow = eyp[9] || ~(|e1) || ~(|e2) ? 1 : 0;
    wire ovf_f = (~eyp[9] && eyp[8]) || &(eyp[7:0]) || &(e1) || &(e2) ? 1 : 0;
    /*wire [23:0] m1i = {1'b1, m1};
    wire [23:0] m2i = {1'b1, m2};*/
    /*wire [63:0] my1;
    multi32 u1(m1i, m2i, my1);*/
    wire [47:0] my1 = {1'b1, m1} * {1'b1, m2};
    assign ovf = ovf_f || (my1[47] && &(eypi[7:0]));
    wire [7:0] ey = underflow ? 8'b00000000 : 
                    ovf ? 8'b11111111 : 
                    my1[47] ? eypi[7:0] : eyp[7:0];
    wire [22:0] my = (underflow || ovf) ? 23'b0 : my1[47] ? my1[46:24] : my1[45:23];
    assign y = {sy, ey, my};
endmodule

`default_nettype wire