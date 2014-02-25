`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:32:17 02/11/2014 
// Design Name: 
// Module Name:    master 
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
module master(
    input clk,
    input din,
    input start,
	 input reset,
	 input miso,
    output mosi,
    output sclk,
    output ss
    );
	 
	reg sclk, mosi, ss;
	
	reg [1:0] curr_state, next_state;
	reg [7:0] buffer, transfer_reg;
	
	reg [3:0] cnt;
	
	initial cnt = 0;
	
	parameter IDLE = 3'b000, LOAD = 3'b001, TRANSFER = 3'b10, FINISH = 3'b11, UNLOAD = 3'b100;
	
	always@(posedge clk or negedge reset)
	begin
		sclk <= clk;
		if(reset == 0)
		begin
			next_state <= IDLE;
			sclk = 1'b1;
			mosi = 1'b0;
			ss = 1'b1;
		end
		else
		begin //only execute at the posedge of clock
			curr_state <= next_state;
			if(ss == 1'b0) 
			begin
				transfer_reg[7:0] <= transfer_reg[7:0] << 1;
				transfer_reg[0] <= miso;
			end
			else
			begin
				buffer[7:0] <= buffer[7:0] << 1;
				buffer[0] <= din;
			end
		end
	end
	
	always@(negedge clk)
	begin
		sclk = clk;
		if(start == 1'b1) //when negedge clk && start == 1
		begin
			next_state <= LOAD;
		end
		else //if we're not done loading data, then accept new data into buffer
		begin
			buffer[7:0] <= buffer[7:0] << 1;
			buffer[0] <= din;
		end
	end
	
	always@(curr_state or transfer_reg)
	begin
		case(curr_state)
			IDLE:
			begin

			end
			
			LOAD:
			begin
				transfer_reg[7:0] = buffer[7:0];
				next_state = TRANSFER;
			end
			
			TRANSFER:
			begin
				if(cnt < 8)
				begin
					ss = 1'b0;
					mosi = transfer_reg[7];
					cnt = cnt + 1;
					if(cnt == 8)
					begin
						next_state = FINISH;
					end
				end
			end
			
			FINISH:
			begin
				ss = 1'b1;
				cnt = 1'b0;
				sclk = 1'b1;
				next_state = UNLOAD;
			end
			
			UNLOAD:
			begin
				buffer[7:0] = transfer_reg[7:0];
				next_state = IDLE;
			end
		endcase
	end

endmodule
