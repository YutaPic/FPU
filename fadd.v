`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/07/14 14:41:32
// Design Name: 
// Module Name: fadd
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
module fadd(
    input wire [31:0] x1,
    input wire [31:0] x2,
    output wire [31:0] y,
    output wire ovf
    );
    wire s1 = x1[31];
    wire s2 = x2[31];
    wire [8-1:0] e1 = x1[30:23];
    wire [8-1:0] e2 = x2[30:23];
    wire [23-1:0] m1 = x1[22:0];
    wire [23-1:0] m2 = x2[22:0];
    wire [25-1:0] ms, mi;
    wire [8-1:0] es, ei;
    wire ss;
    wire [5-1:0] de;
    compSign_add u2(s1, s2, e1, e2, m1, m2, ms, mi, es, ei,ss, de);
    wire [56-1:0] mia;
    wire tstck;
    alinePoint_add u3(mi, de, mia, tstck);
    wire [8-1:0] eyd;
    wire [27-1:0] myd;
    wire stck;
    wire ovfflag1;
    wire [5-1:0] se;
    operate_add u4(s1, s2, tstck, es, ms, mia, eyd, myd, stck, ovfflag1);
    leadingZeroCounter c1(myd, se);
    wire [8-1:0] eyr;
    wire [27-1:0] myf;
    round1 u5(eyd, myd, se, eyr, myf);
    wire [25-1:0] myr;
    round2 u6(myf, stck, s1, s2, myr);
    wire [8-1:0] ey;
    wire [23-1:0] my;
    wire ovfflag2;
    normalize u7(eyr, myr, ey, my, ovfflag2);
    wire sy = (ey == 0 && my == 0) ? s1 && s2 : ss;
    wire nzm1 = |(m1[22:0]);
    wire nzm2 = |(m2[22:0]);
    
    assign y =
    &(e1) && ~(&(e2)) ? {s1,8'd255,nzm1,m1[21:0]} :
    &(e2) && ~(&(e1)) ? {s2,8'd255,nzm2,m2[21:0]} :
    &(e1) && &(e2) && nzm2 ? {s2,8'd255,1'b1,m2[21:0]} :
    &(e1) && &(e2) && nzm1 ? {s1,8'd255,1'b1,m1[21:0]} :
    &(e1) && &(e2) && s1 == s2 ? {s1, 8'd255, 23'b0} :
    &(e1) && &(e2) ? {1'b1, 8'd255, 1'b1, 22'b0} :
    {sy, ey, my}/*{sy, ey, my}*/;
    
    assign ovf = (ovfflag2 || ovfflag1) && ~(&e1) && ~(&e2) ? 1 : 0;
    
endmodule

module leadingZeroCounter(
    input wire [26:0] x,
    output wire [4:0] y
    );
    assign y = x[25] ? 0 :
    x[24] ? 1 :
    x[23] ? 2 :
    x[22] ? 3 :
    x[21] ? 4 :
    x[20] ? 5 :
    x[19] ? 6 :
    x[18] ? 7 :
    x[17] ? 8 :
    x[16] ? 9 :
    x[15] ? 10 :
    x[14] ? 11 :
    x[13] ? 12 :
    x[12] ? 13 :
    x[11] ? 14 :
    x[10] ? 15 :
    x[9] ? 16 :
    x[8] ? 17 :
    x[7] ? 18 :
    x[6] ? 19 :
    x[5] ? 20 :
    x[4] ? 21 :
    x[3] ? 22 :
    x[2] ? 23 :
    x[1] ? 24 :
    x[0] ? 25 : 26;
endmodule

module compSign_add(
    input wire s1,
    input wire s2,
    input wire [8-1:0] e1,
    input wire [8-1:0] e2,
    input wire [23-1:0] m1,
    input wire [23-1:0] m2,
    output wire [25-1:0] ms,
    output wire [25-1:0] mi,
    output wire [8-1:0] es,
    output wire [8-1:0] ei,
    output wire ss,
    output wire [5-1:0] de
    );
    
    wire [25-1:0] m1a = {1'b0, |e1, m1};
    wire [25-1:0] m2a = {1'b0, |e2, m2};
    wire [8-1:0] e1a = |(e1) ? e1 : 8'b1;
    wire [8-1:0] e2a = |(e2) ? e2 : 8'b1;
    
    wire [8-1:0] e2ai = ~e2a;
    wire [9-1:0] te = {1'b0, e1a} + {1'b0, e2ai};
    wire ce = ~te[8];
    wire [8-1:0] tde = te[8] ? te[7:0] + 8'b1 : ~te[7:0];
    assign de = |tde[7:5] ? 5'b11111 : tde[4:0];
    wire sel = 
    (de == 0 && m1a > m2a) ? 0 : 
    (de == 0) ? 1 : ce;
    assign ms = sel ? m2a : m1a;
    assign mi = sel ? m1a : m2a;
    assign es = sel ? e2a : e1a;
    assign ei = sel ? e1a : e2a;
    assign ss = sel ? s2 : s1;
endmodule
    
module alinePoint_add(
    input wire [25-1:0] mi,
    input wire [5-1:0] de,
    output wire [56-1:0] mia,
    output wire tstck
    );
    wire [56-1:0] mie = {mi, 31'b0};
    assign mia = mie >> de;
 assign tstck = |(mia[28:0]);
endmodule

module operate_sub(
    input wire s1,
    input wire s2,
    input wire tstck,
    input wire [8-1:0] es,
    input wire [25-1:0] ms,
    input wire [56-1:0] mia,
    output wire [8-1:0] eyd,
    output wire [27-1:0] myd,
    output wire stck,
    output wire ovfflag1
    );
    wire [27-1:0] mye = (s1 == s2) ? {ms, 2'b0} + mia[55:29] : {ms, 2'b0} - mia[55:29];
    wire [8-1:0] esi = es + 8'b1;
    assign eyd = 
    (mye[26] && &esi) ? 8'd255 :
    (mye[26]) ? esi : es;
    assign myd =
    (mye[26] && &esi) ? {2'b01, 25'b0} :
    (mye[26]) ? mye >> 1'b1 : mye;
    assign stck =
    (mye[26] && &esi) ? 1'b0 :
    (mye[26]) ? tstck || mye[0] : tstck;
    assign ovfflag1 = (mye[26] && (&esi));
endmodule

module round1 (
    input wire [8-1:0] eyd,
    input wire [27-1:0] myd,
    input wire [5-1:0] se, 
    output wire [8-1:0] eyr, 
    output wire [27-1:0] myf);
    wire [9-1:0] eyf = {1'b0, eyd} - {4'b0, se};
    assign eyr =
    (~eyf[8] && (|eyf)) ? eyf[7:0] : 8'b0;
    assign myf =
    (~eyf[8] && (|eyf)) ? myd << se : myd << (eyd[4:0] - 5'b1);
endmodule

module round2(
    input wire [27-1:0] myf, 
    input wire stck, 
    input wire s1, 
    input wire s2, 
    output wire [25-1:0] myr);
    assign myr =
    myf[1] && ~myf[0] && ~stck && myf[2] ? myf[26:2] + 25'b1 :
    myf[1] && ~myf[0] && s1 == s2 && stck ?  myf[26:2] + 25'b1 :
    myf[1] && myf[0] ? myf[26:2] + 25'b1 : myf[26:2];
endmodule

module normalize(
    input wire [8-1:0] eyr, 
    input wire [25-1:0] myr, 
    output wire [8-1:0] ey, 
    output wire [23-1:0] my,
    output wire ovfflag2
    );
    wire [8-1:0] eyri = eyr + 8'b1;
    assign ey = 
    myr[24] ? eyri :
    |(myr[23:0]) ? eyr : 0;
    assign my =
    myr[24] ? 23'b0 :
    |(myr[23:0]) ? myr[22:0] : 23'b0;
    assign ovfflag2 = myr[24] && (&eyri);
endmodule

`default_nettype wire
