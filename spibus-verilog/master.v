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
    input [7:0] din,
	 input reset,
	 input start,
	 input miso,
    output reg mosi,
<<<<<<< HEAD
    output wire sclk,
=======
    output reg sclk,
>>>>>>> a914592263b1de724860b9419a6da0a06ffdbba1
    output reg ss
    );
	
	reg [1:0] curr_state, next_state;
	reg [7:0] buffer, transfer_reg;
	
	reg [4:0] cnt;
<<<<<<< HEAD
	
	assign sclk = clk;
=======
>>>>>>> a914592263b1de724860b9419a6da0a06ffdbba1
	
	initial cnt = 0;
	
	parameter IDLE = 2'b00, LOAD = 2'b01, TRANSFER = 2'b10, FINISH = 2'b11;
	
<<<<<<< HEAD
	always@(posedge clk, negedge reset) //sequential posedge block
	begin
		if(~reset)
		begin
			buffer <= 0;
		end
		else if(curr_state == IDLE) //accept new data into buffer when IDLE
		begin
			buffer <= din;
		end
		else
		begin
			buffer <= buffer;
		end
	end
	
	always@(negedge clk, negedge reset) //sequential negedge block
	begin
		curr_state <= ~reset ? IDLE : next_state;
	end
		
	always@(negedge clk)
	begin
		if(curr_state == TRANSFER) //transfer new data bit from MISO
		begin
			{mosi, transfer_reg[7:0]} <= {transfer_reg[7:0], miso};
		end
		else if(curr_state == LOAD)
=======
	always@(posedge clk or negedge reset) //sequential posedge block
	begin
		sclk <= clk;
		if(reset == 0) //if reset
		begin
			transfer_reg <= 'b0;
			buffer <= 'b0;
			next_state <= IDLE;
			mosi <= 1'b0;
			ss <= 1'b1;
		end
		if(start == 1'b1) //when posedge clk && start == 1
		begin
			next_state <= LOAD;
		end
		else if(curr_state == IDLE) //accept new data into buffer when IDLE
		begin
				buffer[7:0] <= buffer[7:0] << 1;
				buffer[0] <= din;
		end
	end
	
	always@(negedge clk) //sequential negedge block
	begin
		sclk <= clk;
		curr_state <= next_state;
		if(ss == 1'b0) //transfer new data bit from MISO
		begin
			transfer_reg[7:0] <= transfer_reg[7:0] << 1;
			transfer_reg[0] <= miso;
		end
		if(curr_state == IDLE) //accept new data into buffer when IDLE
>>>>>>> a914592263b1de724860b9419a6da0a06ffdbba1
		begin
			transfer_reg[7:0] <= buffer[7:0];
		end
		else if(curr_state == FINISH)
		begin
			buffer[7:0] <= transfer_reg[7:0];
		end
	end
	
	always@(curr_state or transfer_reg) //combinational block
	begin
		case(curr_state)
			IDLE:
			begin
				ss = 1'b1;
<<<<<<< HEAD
				if(start == 1'b1)
				begin
					next_state = LOAD;
				end
=======
>>>>>>> a914592263b1de724860b9419a6da0a06ffdbba1
			end
			LOAD:
			begin
				next_state = TRANSFER;
			end
			TRANSFER:
			begin
				if(cnt < 16)
				begin
					ss = 1'b0;
					cnt = cnt + 1;
					if(cnt == 16)
					begin
						next_state = FINISH;
					end
				end
			end
			
			FINISH:
			begin
				ss = 1'b1;
				cnt = 1'b0;
<<<<<<< HEAD
=======
				next_state = UNLOAD;
			end
			
			UNLOAD:
			begin
				buffer[7:0] = transfer_reg[7:0];
>>>>>>> a914592263b1de724860b9419a6da0a06ffdbba1
				next_state = IDLE;
			end
		endcase
	end

endmodule
