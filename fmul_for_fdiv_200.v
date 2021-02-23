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
//e = 0Ç»ÇÁÇŒÇªÇÃêîÇ0(m = 0Ç≈å≈íË)Ç∆Ç›Ç»Ç∑
//e = 255Ç»ÇÁÇŒÇªÇÃêîÇÅá(m = 0Ç≈å≈íË)Ç∆Ç›Ç»Ç∑

module fmul_for_fdiv_200(
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
    reg sy;// = s1 ^ s2;
    wire [9:0] eyp = e1 + 9'd126 - e2;
    wire [9:0] eypi = eyp + 1 ;
    reg [47:0] p2;// ;
    
    reg [7:0] eyp_2, eypi_2;
    reg underflow;
    reg ovf_f;
    reg [47:0] p1;
    wire [47:0] my1 = p1 + {p2, 17'b0};
    wire ovf = ovf_f || (my1[47] && &(eypi[7:0]));
    wire [7:0] ey = underflow ? 8'b00000000 : 
                    ovf ? 8'b11111111 : 
                    my1[47] ? eypi_2 : eyp_2;
    wire [22:0] my = (underflow || ovf) ? 23'b0 : my1[47] ? my1[46:24] : my1[45:23];
    assign y = {sy, ey, my};
    
    always @(posedge clk) begin
        /*if (rst) begin
            p1 <= 0;
            //m1_2 <= 0;
            //m2_2 <= 0; 
            ovf_f <= 0;
            underflow <= 0;
            eyp_2 <= 0;
            eypi_2 <= 0;
            sy <= 0;
            p2 <= 0;
        end else begin*/
            p1 <=  m1[16:0] * {1'b1, m2};
            //m1_2 <= m1;
            //m2_2 <= m2; 
            ovf_f <= (~eyp[9] && eyp[8]) || &(eyp[7:0]) || &(e1) || &(e2) ? 1 : 0;
            underflow <= eyp[9] || ~(|e1) || ~(|e2) ? 1 : 0;
            eyp_2 <= eyp;
            eypi_2 <= eypi;
            sy <= s1 ^ s2;
            p2 <= {1'b1, m1[22:17]} * {1'b1, m2};
        //end
    end
endmodule

`default_nettype wire