`default_nettype none
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/10/19
// Design Name: fmul 
// Module Name: fmul
// Project Name: CP
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
//e = 0‚È‚ç‚Î‚»‚Ì”‚ğ0(m = 0‚ÅŒÅ’è)‚Æ‚İ‚È‚·
//e = 255‚È‚ç‚Î‚»‚Ì”‚ğ‡(m = 0‚ÅŒÅ’è)‚Æ‚İ‚È‚·

module fmul_for_fdiv_300(
    input wire clk,
    input wire [31:0] x1,
    input wire [31:0] x2,
    output wire [31:0] y
    );
    wire s1 = x1[31];
    wire s2 = x2[31];
    wire [8-1:0] e1 = x1[30:23];
    wire [8-1:0] e2 = x2[30:23];
    wire [23-1:0] m1 = x1[22:0];
    wire [23-1:0] m2 = x2[22:0];
    reg sy;
    wire [9:0] eyp = e1 + 9'd126 - e2;
    wire [9:0] eypi = eyp + 1 ;
    reg [47:0] p2;// ;
    
    reg [7:0] eyp_2, eypi_2;
    reg underflow;
    reg ovf_f;
    reg [47:0] p1;
    
    always @(posedge clk) begin
            p1 <=  m1[16:0] * {1'b1, m2};
            ovf_f <= (~eyp[9] && eyp[8]) || &(eyp[7:0]) || &(e1) || &(e2) ? 1 : 0;
            underflow <= eyp[9] || ~(|e1) || ~(|e2) ? 1 : 0;
            eyp_2 <= eyp;
            eypi_2 <= eypi;
            sy <= s1 ^ s2;
            p2 <= {1'b1, m1[22:17]} * {1'b1, m2};
    end
    
    //wire [47:0] my1 = p1 + {p2, 17'b0};
    reg [47:0] my1;
    reg ovf_f_1, underflow_1, sy_1;
    reg [7:0] eypi_3, eyp_3;
    always @(posedge clk) begin
        my1 <= p1 + {p2, 17'b0};
        ovf_f_1 <= ovf_f;
        eypi_3 <= eypi_2;
        underflow_1 <= underflow;
        sy_1 <= sy;
        eyp_3 <= eyp_2;
    end
    wire ovf = ovf_f_1 || (my1[47] && &(eypi_3[7:0]));
    wire [7:0] ey = underflow_1 ? 8'b00000000 : 
                    ovf ? 8'b11111111 : 
                    my1[47] ? eypi_3 : eyp_3;
    wire [22:0] my = (underflow_1 || ovf) ? 23'b0 : my1[47] ? my1[46:24] : my1[45:23];
    assign y = {sy_1, ey, my};
endmodule

`default_nettype wire