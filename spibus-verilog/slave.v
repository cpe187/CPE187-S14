`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:57:05 02/11/2014 
// Design Name: 
// Module Name:    slave 
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
module slave(
    input mosi,
    input sclk,
    input ss,
    output miso,
    output [7:0] rdata
    );

	reg sclk, mosi, ss;

	reg [7:0] buffer, transfer_reg;

	always@(negedge sclk)
	begin
		if(ss == 1'b0)
		begin
			transfer_reg[7:0] <= transfer_reg[7:0] << 1;
			buffer[0] <= mosi;
		end
	end

endmodule
