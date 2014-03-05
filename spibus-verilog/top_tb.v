`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:15:38 02/11/2014
// Design Name:   master
// Module Name:   C:/Users/hojmang/Documents/cpe187/spibus/top_tb.v
// Project Name:  spibus
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: master
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_tb;

	// Inputs
	reg clk;
	reg [7:0] din;
	reg start;
	reg reset;

	// Outputs
	wire mosi;
	wire sclk;
	wire ss;

	// Instantiate the Unit Under Test (UUT)
	master master1 (
		.clk(clk), 
		.din(din), 
		.start(start),
		.reset(reset),
		.miso(miso),
		.mosi(mosi),
		.sclk(sclk), 
		.ss(ss)
	);
	
//	slave slave1 (
//		.mosi(mosi),
//		.sclk(sclk),
//		.ss(ss),
//		.miso(miso),
//		.rdata(rdata)
//	);

	always #10 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		din = 8'b00000000;
		start = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		reset = 0;
		
		#10;
		reset = 1;
		#10;
		din = 8'b00000101;
		start = 1;
		#10;
		start = 0;
		#400;
		start = 1;
		#10;
		start = 0;
	end
      
endmodule

