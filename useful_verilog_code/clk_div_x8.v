`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:50:15 02/18/2014 
// Design Name: 
// Module Name:    clk_div_x8 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clk_div_x8(
    input clk,
    output clk8
    );

reg [2:0] cnt;

initial cnt = 0;

always @(posedge clk)
   cnt <= cnt + 1;

assign clk8 = cnt[2];

endmodule
