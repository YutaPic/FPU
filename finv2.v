`timescale 1ns / 100ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/26 22:22:15
// Design Name: 
// Module Name: finv
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


module finv(
    input wire clk,
    input wire [31:0] a,
    output wire [31:0] b
    );
    wire s0 = a[31];
    wire [7:0] e0 = a[30:23];
    wire [9:0] am0 = a[22:13];
    wire [12:0] al0 = a[12:0];
    wire [22:0] c1;
    wire [12:0] g1;
    reg [22:0] c2;
    reg [12:0] g2;
    reg [12:0] al1;
    wire [34:0] ag;
    //reg [23:0] ags;
    reg [7:0] e1, e2;
    reg s1, s2;
    //wire [7:0] e;
    wire [22:0] m;
    
    (* ram_style = "block" *) finv_const_table u1 (clk, am0, c1);
    (* ram_style = "block" *) finv_grad_table u2 (clk, am0, g1);
    
    initial begin
        al1 <= 0;
        //c2 <= 0;
        e1 <= 0;
        //e2 <= 0;
        s1 <= 0;
        //s2 <= 0;
        //ags <= 0;
    end
    
    always @(posedge clk) begin
        e1 <= e0;
        s1 <= s0;
        al1 <= al0;
        
        //ags <= ag >> 12;
        //c2 <= c1;
        //e2 <= e1;
        //s2 <= s1;
    end
    
    assign ag = al1 * g1;
    wire [23:0] ags = ag >> 12;
    assign m = c1 - ags;
    assign b = {s1, e1, m};
    
endmodule

`default_nettype wire