`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuta Fukushima
// 
// Create Date: 2020/12/02
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
// Revision 1.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module fadd_200(
    input wire clk, reset,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] y//,
    //output wire ovf
    );
    wire a_s = a[31];
    wire [7:0] a_e = a[30:23];
    wire [23:0] a_m = {1'b1,a[22:0]};
    wire b_s = b[31];
    wire [7:0] b_e = b[30:23];
    wire [23:0] b_m = {1'b1,b[22:0]};
    
    wire larger = (a_e > b_e) ? 1 : ((a_e == b_e) &&(a_m > b_m)) ? 1 : 0;
    
    wire l_s = larger ? a_s : b_s;
    wire s_s = larger ? b_s : a_s;
    wire [7:0] l_e = larger ? a_e : b_e;
    wire [7:0] s_e = larger ? b_e : a_e;
    wire [23:0] l_m = larger ? a_m : b_m;
    wire [23:0] s_m = larger ? b_m : a_m;
    
    wire [7:0] diff = l_e - s_e;
    wire [4:0] diff_e = diff > 5'd24 ? 5'd24 : diff;
    wire [23:0] s_m_shift = s_m >> diff_e;
    wire [24:0] m_raw = (s_s ^ l_s) ? l_m - s_m_shift : l_m + s_m_shift;
    
    reg l_s_2;
    reg [7:0] l_e_2;
    reg [24:0] m_raw_2;
    
    wire m25 = m_raw_2[24];
    
    wire [4:0] shift_m;
    LZC_for_fadd lzc(m_raw_2[23:0], shift_m);
    wire [47:0] m_shift = m_raw_2[23:0] << shift_m;
    
    wire [22:0] m = 
    m25 ? m_raw_2[23:1] :
    m_shift[22:0] ;
    
    wire [8:0] e_shift = l_e_2 - shift_m;
    wire [8:0] e_inc = l_e_2 + 1;
    wire [7:0] e = 
    (m25 && e_inc[8]) ? 8'b11111111 :
    m25 ? e_inc[7:0] :
    e_shift[8] ? 0 :
    e_shift[7:0];
    
    assign y = 
    ~(|e) ? {l_s_2, 31'b0} :
    &e ? {l_s_2, e, 23'b0} :
    {l_s_2, e, m};
    
    always @(posedge clk) begin
        if (reset) begin
            l_s_2 <= 0;
            m_raw_2 <= 0;
            l_e_2 <= 0;
        end else begin
            l_s_2 <= l_s;
            m_raw_2 <= m_raw;
            l_e_2 <= l_e;
        end
    end
    
    //assign ovf = ~(&a_e) && ~(&b_e) && (&e) ? 1 : 0;
endmodule

module LZC_for_fadd(
    input wire [23:0] a,
    output wire [4:0] cnt
    );
    assign cnt =
    a[23] ? 0 :
    a[22] ? 1 :
    a[21] ? 2 :
    a[20] ? 3 :
    a[19] ? 4 :
    a[18] ? 5 :
    a[17] ? 6 :
    a[16] ? 7 :
    a[15] ? 8 :
    a[14] ? 9 :
    a[13] ? 10:
    a[12] ? 11 :
    a[11] ? 12 :
    a[10] ? 13 :
    a[9] ? 14 :
    a[8] ? 15 :
    a[7] ? 16 :
    a[6] ? 17 :
    a[5] ? 18 :
    a[4] ? 19 :
    a[3] ? 20 :
    a[2] ? 21 :
    a[1] ? 22 :
    a[0] ? 23 :
    24;
endmodule
`default_nettype wire