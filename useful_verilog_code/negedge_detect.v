`timescale 1ns / 1ps
/*{{{ ------ Negative Edge Detection Circuit ------
Author : Nathan Gonzales
FileName : negedge_detect.v
Date : 02/18/2014
}}}*/
module negedge_detect(
   input clk, d,
   output n_edge
);

reg q;

always @(posedge clk)
   q <= d;

assign n_edge = q&~d;

endmodule

