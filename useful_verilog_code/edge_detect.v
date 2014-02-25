`timescale 1ns / 1ps
/*{{{ ------ Edge Detection Circuit ------
Author : Nathan Gonzales
FileName : edge_detect.v
Date : 02/18/2014
}}}*/
module edge_detect(
   input clk, d,
   output p
);

reg q;

always @(posedge clk)
   q <= d;

assign p = q^d;

endmodule

