`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/16 13:33:52
// Design Name: 
// Module Name: fpu
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


module fpu(
    input wire clk, rst,
    input wire [31:0] arg1, arg2,
    input wire [2:0] fpucontrol,//ï€éù
    input wire fpu_ready,//åvéZÇÃ1clockëO
    output reg fpu_valid,//åvéZÇÃ1clockå„
    output reg [31:0] fpuout
    );
    wire ovf;//unused
    wire [31:0] fabs_rs, fmul_rs, fadd_rs, fsub_rs, fdiv_rs, fsqrt_rs;
    //assign fpu_valid = 1;
    reg wait0, wait1, wait2, wait3;
    
    always @* begin
        wait0 <= fpu_ready;
    end
    
    always @(posedge clk) begin
        if (rst) begin
            fpu_valid <= 0;
        end else
        if (wait0) begin
            if (fpucontrol == 3'b010) begin
                fpu_valid <= 1;
                fpuout <= fmul_rs;
            end else
            if (fpucontrol == 3'b101) begin // || fpucontrol == 3'b110 || fpucontrol == 3'b111
                fpu_valid <= 1;
                fpuout <= fabs_rs;
            end else
            if (fpucontrol == 3'b110) begin // || fpucontrol == 3'b111
                fpu_valid <= 1;
                fpuout <= arg2;
            end else
            if (fpucontrol == 3'b111) begin
                fpu_valid <= 1;
                fpuout <= {~arg2[31], arg2[30:0]};
            end
        end else
        if (wait1) begin
            if (fpucontrol == 3'b000) begin
                fpu_valid <= 1;
                fpuout <= fadd_rs;
            end else
            if (fpucontrol == 3'b001) begin
                fpu_valid <= 1;
                fpuout <= fsub_rs;
            end
        end else
        if (wait2) begin
            if (fpucontrol == 3'b100) begin
                fpu_valid <= 1;
                fpuout <= fsqrt_rs;
            end
        end else
        if (wait3) begin
            if (fpucontrol == 3'b011) begin
                fpu_valid <= 1;
                fpuout <= fsqrt_rs;
            end
        end
           
        /*case(fpucontrol)
            3'b000: begin
                fpu_valid <= wait1;
                fpuout <= fadd_rs;
            end
            
            3'b001: begin
                fpu_valid <= wait1;
                fpuout <= fsub_rs;
            end
            
            3'b010: begin
                fpu_valid <= fpu_ready;
                fpuout <= fmul_rs;
            end
            
            3'b011: begin //div.s
                fpu_valid <= wait3;
                fpuout <= fdiv_rs;
            end
            
            3'b100: begin //sqrt.s
                fpu_valid <= wait2;
                fpuout <= fsqrt_rs;
            end
            
            3'b101: begin
                fpu_valid <= fpu_ready;
                fpuout <= fabs_rs;
            end
            
            3'b110: begin //mov.s
                fpu_valid <= fpu_ready;
                fpuout <= arg2;//fd = ft
            end
            
            3'b111: begin //neg.s
                fpu_valid <= fpu_ready;
                fpuout <= {~arg2[31], arg2[30:0]};
            end
        endcase*/
    end
    
    always @(posedge clk) begin
        if (rst) begin
            wait1 <= 0;
            wait2 <= 0;
            wait3 <= 0;
        end else begin
            wait1 <= wait0;
            wait2 <= wait1;
            wait3 <= wait2;
        end
    end
        
    
    fabs fabs (arg2, fabs_rs);//fc = 101
    fmul fmul (arg1, arg2, fmul_rs, ovf); //fc = 010
    fadd_200 fadd(clk, rst, arg1, arg2, fadd_rs);
    fsub_200 fsub(clk, rst, arg1, arg2, fsub_rs);
    fdiv_200 fdiv(clk, arg1, arg2, fdiv_rs);
    fsqrt_200 fsqrt(clk, arg2, fsqrt_rs);
endmodule
